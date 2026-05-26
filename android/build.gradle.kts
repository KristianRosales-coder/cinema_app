allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// FIX: Add namespace for flutter_inappwebview to fix Error 153
subprojects {
    if (name == "flutter_inappwebview") {
        extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.apply {
            namespace = "com.pichillilorenzo.flutter_inappwebview"
        }
    }
}