package com.aeryn.deutsch

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

/**
 * MainActivity for Aeryn-Deutsch
 * Uses Flutter Android Embedding V2
 */
class MainActivity: FlutterActivity() {
    /**
     * Configure the Flutter engine with all plugins
     */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
