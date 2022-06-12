package com.maniak.flutter_file_manager_android

import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterFileManagerAndroidPlugin */
class FlutterFileManagerAndroidPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  private var activityBinding: ActivityPluginBinding? = null
  private var fileDialog: FileDialog?  = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_file_manager_android")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (fileDialog == null) {
      if (!createFileDialog()) {
        result.error("init_failed", "Not attached", null)
        return
      }
    }

    if (call.method == "writeFile") {
      val sourceFilePath = call.argument<String>("sourceFilePath")
      val name = call.argument<String>("name")
      val bytes = call.argument<ByteArray>("bytes")
      val mimeTypesFilter = call.argument<List<String>>("types")?.toTypedArray()
      val localOnly = call.argument<Boolean>("localOnly")

      handleWriteFile(result, sourceFilePath, bytes, name, mimeTypesFilter, localOnly)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun handleWriteFile(
          @NonNull result: Result,
          sourceFilePath: String?,
          bytes: ByteArray?,
          fileName: String?,
          mimeTypesFilter: Array<String>?,
          localOnly: Boolean?
  ) {
    fileDialog!!.saveFile(
            result,
            sourceFilePath,
            bytes,
            fileName,
            mimeTypesFilter,
            localOnly == true
    )
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    doOnDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityBinding = binding
  }

  override fun onDetachedFromActivity() {
    doOnDetachedFromActivity()
  }

  private fun doOnDetachedFromActivity() {
    if (fileDialog != null) {
      activityBinding?.removeActivityResultListener(fileDialog!!)
      fileDialog = null
    }
    activityBinding = null
  }

  private fun createFileDialog(): Boolean {
    var fileDialog: FileDialog? = null
    if (activityBinding != null) {
      fileDialog = FileDialog(activity = activityBinding!!.activity)
      activityBinding!!.addActivityResultListener(fileDialog)
    }
    this.fileDialog = fileDialog
    return fileDialog != null
  }
}
