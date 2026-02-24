# Flutter internals
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Fix for the "Missing class com.google.android.play.core" error
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# SharedPreferences and Pigeon (common Flutter internal communication)
-keep class dev.flutter.pigeon.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# If you use any custom models that are parsed from JSON,
# keep them so R8 doesn't rename the fields.
-keep class com.school_management_system.app.Model.** { *; }

# General Android support
-dontwarn android.util.Log
-dontwarn androidx.window.layout.SideProvider
-dontwarn androidx.window.extensions.layout.WindowLayoutComponent