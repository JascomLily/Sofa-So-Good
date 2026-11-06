package com.furni3d.app.furni3d_mobile

import android.os.Build
import android.os.Bundle
import android.view.WindowInsets
import android.view.WindowInsetsController
import android.view.WindowManager
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Set decorFitsSystemWindows to TRUE so Android window manager automatically reserves
        // space for the top status bar (clock/wifi/battery) and bottom navigation bar (3 system buttons)
        WindowCompat.setDecorFitsSystemWindows(window, true)
        ensureSystemBarsVisible()
    }

    override fun onResume() {
        super.onResume()
        ensureSystemBarsVisible()
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            ensureSystemBarsVisible()
        }
    }

    private fun ensureSystemBarsVisible() {
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
        window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
        window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
        WindowCompat.setDecorFitsSystemWindows(window, true)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val insetsController = window.insetsController
            if (insetsController != null) {
                insetsController.show(WindowInsets.Type.statusBars() or WindowInsets.Type.navigationBars())
                insetsController.systemBarsBehavior = WindowInsetsController.BEHAVIOR_DEFAULT
            }
        }
    }
}
