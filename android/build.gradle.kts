// Fichier: android/build.gradle.kts (projet racine)

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirige le dossier build pour le projet racine
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Redirige le dossier build pour chaque sous-projet
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Assure que le projet :app est évalué avant les sous-projets
subprojects {
    project.evaluationDependsOn(":app")
}

// Tâche de nettoyage
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
