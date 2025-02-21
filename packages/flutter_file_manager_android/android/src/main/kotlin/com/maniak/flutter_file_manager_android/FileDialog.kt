package com.maniak.flutter_file_manager_android

import FlutterError
import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

private const val REQUEST_CODE_SAVE_FILE = 19112

class FileDialog(private val activity: Activity) : PluginRegistry.ActivityResultListener {
    private var completionCallback: ((Result<String>) -> Unit)? = null

    private var sourceFile: File? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (requestCode) {
            REQUEST_CODE_SAVE_FILE -> {
                if (resultCode == Activity.RESULT_OK && data?.data != null) {
                    val destinationFileUri = data.data
                    saveFileOnBackground(this.sourceFile!!, destinationFileUri!!)
                } else {
                    sourceFile?.delete()
                    completionCallback?.let { it(Result.failure(FlutterError("CANCELLED"))) }
                }
                true
            }

            else -> false
        }
    }

    fun saveFile(
        callback: (Result<String>) -> Unit,
        data: ByteArray,
        fileName: String,
        mimeType: String?,
    ) {
        this.completionCallback = callback

        val sourceFile = File.createTempFile(fileName, "")
        this.sourceFile = sourceFile
        sourceFile.writeBytes(data)

        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT)
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.putExtra(Intent.EXTRA_TITLE, fileName)
        intent.type = mimeType ?: "*/*"

        activity.startActivityForResult(intent, REQUEST_CODE_SAVE_FILE)
    }

    private fun saveFileOnBackground(sourceFile: File, destinationFileUri: Uri) {
        val uiScope = CoroutineScope(Dispatchers.Main)
        uiScope.launch {
            try {
                val filePath = withContext(Dispatchers.IO) {
                    saveFile(sourceFile, destinationFileUri)
                }
                completionCallback?.let { it(Result.success(filePath)) }
            } catch (e: SecurityException) {
                completionCallback?.let { it(Result.failure(FlutterError(code = "security_exception", message = e.localizedMessage))) }
            } catch (e: Exception) {
                completionCallback?.let { it(Result.failure(FlutterError(code = "save_file_failed", message = e.localizedMessage))) }
            } finally {
                sourceFile.delete()
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
}