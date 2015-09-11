---
title: gradle and xldeploy
layout: post
---
Our company uses [XLDeploy](https://xebialabs.com/products/xl-deploy) from XebiaLabs to deploy apps and configurations. In order to create a deployment we need to create and import a so called dar package. XLDeploy will then figure out which parts of the archive has changed based on checksums and only deploy those. We previously used a maven plugin to generate the dar package, but we ended up with a very long and repetative pom file since we have more than 20 modules in one dar. Sometimes we would get problems with the deployments because we had typos in the pom. It was not nice.

## Gradle to the rescue
A dar package is a zip archive that consist of an xml manifest file and the artifacts. Groovy has a great way of creating xml with it's [MarkupBuilder](http://docs.groovy-lang.org/latest/html/api/groovy/xml/MarkupBuilder.html), and with Gradle's [ZipTask](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.bundling.Zip.html), why not let Gradle do it all for us?

1. So the first step would be to place all the artifacts in a folder.
2. Then we would need to create the xml manifest file.
3. Finally, zip the whole folder, and there you have it!


Our team is using a multiproject gradle build. Apart from some common modules, all subprojects are own web services that will be generated into a deployable war file.

{% highlight groovy linenos %}
task darManifest {
    outputs.upToDateWhen { false } // force run
    def manifestFile = file(buildDir.path + '/dar/deployit-manifest.xml')
    def buildNumber = project.property('buildNumber')
    def version = "1.0.$buildNumber"
    doLast {
        def writer = new FileWriter(manifestFile).
          append('<?xml version="1.0" encoding="UTF-8"?>\n')
        new MarkupBuilder(writer).'udm.DeploymentPackage'('version': version,
          'application': 'WAS/WEBSHOP_NO/webshop-deployit-bundle') {
            deployables {
                subprojects.findAll { !it.name.contains('webshop-common') }.each { module ->
                    'was.War'('name': module.name, 'file': module.name + '/' + module.name) {
                        contextRoot('/' + module.name)
                        virtualHostName('intranet_host')
                        classloaderMode('PARENT_LAST')
                        warClassloaderMode('PARENT_LAST')
                    }
                }
            }
        }
        writer.close()
    }
    outputs.file manifestFile
}

task dar (dependsOn: darManifest, type: Zip) {
    inputs.dir file(buildDir.path + '/dar')
    from buildDir.path + '/dar'
    destinationDir file(buildDir.path + '/libs')
    baseName = 'webshop'
    extension 'dar'
}

war {
  destinationDir file("${parent.buildDir}/dar/${project.name}")
}
dar.dependsOn war
{% endhighlight %}
