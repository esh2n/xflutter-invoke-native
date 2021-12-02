package dev.esh2n.sample

import android.content.res.Configuration
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterFragment
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.platform.PlatformViewsController

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, METHOD_CHANNEL).setMethodCallHandler { methodCall, result ->
            val args = methodCall.arguments
            when (methodCall.method) {
                "isReachable" -> {
                    // val activeNetwork: NetworkInfo? = connectivityManager.activeNetworkInfo
                    // result.success(activeNetwork?.isConnected ?: false)
                    result.success(true)
                }
            }
        }

        // EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.eventchannel/interop").setStreamHandler(
        //         object : StreamHandler {
        //             override fun onListen(arguments: Any?, events: EventSink) {
        //                 eventSink = events
        //                 Handler().postDelayed({
        //                     eventSink?.success("Android")
        //                     //eventSink?.endOfStream()
        //                     //eventSink?.error("error code", "error message","error details")
        //                 }, 500)
        //             }
        //             override fun onCancel(arguments: Any?) {
        //             }
        //         })
    }
    companion object {
        private val METHOD_CHANNEL = "platform_channel/method_channel"
        private val EVENT_CHANNEL = "platform_channel/event_channel"
    }
}
