# Keep rules for missing classes
-keep class com.google.j2objc.annotations.ReflectionSupport { *; }
-keep class com.google.j2objc.annotations.ReflectionSupport$Level { *; }
-keep class com.google.common.util.concurrent.AbstractFuture { *; }
-dontwarn com.google.j2objc.annotations.ReflectionSupport$Level
-dontwarn com.google.j2objc.annotations.ReflectionSupport