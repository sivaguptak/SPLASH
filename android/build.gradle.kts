// BEGIN project_build_gradle_full_replace
// Purpose: Project-level Gradle. Provides Google Services classpath only.
// NOTE: No `plugins {}` / `android {}` blocks belong in this file.

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Make the Google Services plugin available to subprojects (app module)
        classpath("com.google.gms:google-services:4.4.2")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// (Your custom shared build dir logic)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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
// END project_build_gradle_full_replace
