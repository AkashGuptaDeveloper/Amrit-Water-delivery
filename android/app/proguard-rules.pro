# Keep essential Google Play Core classes
-keep class com.google.android.play.** { *; }
-keep interface com.google.android.play.** { *; }

# Flutter-specific rules
-keep class io.flutter.** { *; }
-keep class com.app.amritmineralwater.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn io.flutter.plugins.**

# Remove debug logs to reduce APK size and improve security
-assumenosideeffects class android.util.Log { public static *** d(...); }
-assumenosideeffects class android.util.Log { public static *** v(...); }
-assumenosideeffects class android.util.Log { public static *** i(...); }

# Keep referenced classes
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.plugin.editing.** { *; }

# Network and serialization libraries
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keep class com.fasterxml.jackson.** { *; }
-keepnames class javax.servlet.** { *; }
-keepnames class org.ietf.jgss.** { *; }

# Prevent unnecessary warnings
-dontwarn org.w3c.dom.**
-dontwarn org.joda.time.**
-dontwarn org.shaded.apache.**
-dontwarn org.ietf.jgss.**

# Preserve annotations and class metadata
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep Crashlytics stack traces intact
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Twilio SDK specific rules
-keep class tvi.webrtc.** { *; }
-keep class com.twilio.video.** { *; }
-keep class com.twilio.common.** { *; }
-keepattributes InnerClasses