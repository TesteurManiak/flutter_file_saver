package com.maniak.flutter_file_manager_android

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

private const val REQUEST_CODE_SAVE_FILE = 19112

class FileDialog(private val activity: Activity): PluginRegistry.ActivityResultListener {
    private var flutterResult: MethodChannel.Result? = null

    private var sourceFile: File? = null
    private var isSourceFileTemp: Boolean = false

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (requestCode) {
            REQUEST_CODE_SAVE_FILE -> {
                if (resultCode == Activity.RESULT_OK && data?.data != null) {
                    val destinationFileUri = data.data
                    saveFileOnBackground(this.sourceFile!!, destinationFileUri!!)
                } else {
                    if (isSourceFileTemp) {
                        sourceFile?.delete()
                    }
                    flutterResult?.success(null)
                }
                true
            }
            else -> false
        }
    }

    fun saveFile(
            result: MethodChannel.Result,
            sourceFilePath: String?,
            data: ByteArray?,
            fileName: String?,
            mimeTypesFilter: Array<String>?,
            localOnly: Boolean
    ) {
        this.flutterResult = result

        if (sourceFilePath != null) {
            isSourceFileTemp = false
            sourceFile = File(sourceFilePath)
            if (!sourceFile!!.exists()) {
                flutterResult?.error(
                        "file_not_found",
                        "Source file is missing",
                        sourceFilePath
                )
                return
            }
        } else {
            isSourceFileTemp = true
            sourceFile = File.createTempFile(fileName!!, "")
            sourceFile!!.writeBytes(data!!)
        }

        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.putExtra(Intent.EXTRA_TITLE, fileName ?: sourceFile!!.name)
        if (localOnly) {
            intent.putExtra(Intent.EXTRA_LOCAL_ONLY, true)
        }
        applyMimeTypesFilterToIntent(mimeTypesFilter, intent)

        activity.startActivityForResult(intent, REQUEST_CODE_SAVE_FILE)
    }

    private fun saveFileOnBackground(sourceFile: File, destinationFileUri: Uri) {
        val uiScope = CoroutineScope(Dispatchers.Main)
        uiScope.launch {
            try {
                val filePath = withContext(Dispatchers.IO) {
                    saveFile(sourceFile, destinationFileUri)
                }
                flutterResult?.success(filePath)
            } catch (e: SecurityException) {
                flutterResult?.error(
                        "security_exception",
                        e.localizedMessage,
                        e.toString()
                )
            } catch (e: Exception) {
                flutterResult?.error("save_file_failed", e.localizedMessage, e.toString())
            } finally {
                if (isSourceFileTemp) {
                    sourceFile.delete()
                }
            }
        }
    }

    private fun saveFile(sourceFile: File, destinationFileUri: Uri): String {
        sourceFile.inputStream().use { inputStream ->
            activity.contentResolver.openOutputStream(destinationFileUri).use { outputStream ->
                inputStream.copyTo(outputStream!!)
            }
        }
        return destinationFileUri.path!!
    }

    private fun applyMimeTypesFilterToIntent(mimeTypesFilter: Array<String>?, intent: Intent) {
        if (mimeTypesFilter != null) {
            if (mimeTypesFilter.size == 1) {
                intent.type = mimeTypesFilter.first()
            } else {
                intent.type = "*/*"
                intent.putExtra(Intent.EXTRA_MIME_TYPES, mimeTypesFilter)
            }
        } else {
            intent.type = "*/*"
        }
    }
}