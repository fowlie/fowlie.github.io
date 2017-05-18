---
title: gradle and xldeploy
layout: post
comments: true
---
Our company uses [XLDeploy](https://xebialabs.com/products/xl-deploy) from XebiaLabs to deploy apps and configurations. In order to create a deployment we need to create and import a so called dar package. XLDeploy will then figure out which parts of the archive has changed based on checksums and only deploy those. We previously used a maven plugin to generate the dar package, but we ended up with a very long and repetative pom file since we have more than 20 modules in one dar. Sometimes we would get problems with the deployments because we had typos in the pom. It was not nice.

## Gradle to the rescue
A dar package is a zip archive that consist of an xml manifest file and the artifacts. Groovy has a great way of creating xml with it's [MarkupBuilder](http://docs.groovy-lang.org/latest/html/api/groovy/xml/MarkupBuilder.html), and with Gradle's [ZipTask](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.bundling.Zip.html), why not let Gradle do it all for us?

The idea is to place all artifacts and the xml manifest file in a temporary folder, and then just zip all files in that folder. Our team is using a multiproject gradle build. Apart from some common modules, all subprojects are own web services that will be generated into a deployable war file.

## Configure the war task
Here we let the war task put all war files in the build/dar folder.
{% highlight groovy %}
war {
  destinationDir file("${parent.buildDir}/dar")
}
dar.dependsOn war
{% endhighlight %}

## Generate the XML manifest file
Then we create a task to generate the xml manifest file. The format is documented by XebiaLabs [here](https://docs.xebialabs.com/xl-deploy/concept/xl-deploy-manifest-format.html). In this case, it will add all subprojects as war artifacts, except the ones whose name contains the string 'common'.
{% highlight groovy linenos %}
task darManifest {
    outputs.upToDateWhen { false } // force run
    def manifestFile = file(buildDir.path + '/dar/deployit-manifest.xml')
    def buildNumber = project.property('buildNumber')
    def version = '1.0.' + project.property('buildNumber')
    doLast {
        def writer = new FileWriter(manifestFile).
          append('<?xml version="1.0" encoding="UTF-8"?>\n')
        new MarkupBuilder(writer).'udm.DeploymentPackage'('version': version,
          'application': 'WAS/WEBSHOP_NO/webshop-deployit-bundle') {
            deployables {
                subprojects.findAll { !it.name.contains('common') }.each { module ->
                    'was.War'('name': module.name, 'file': module.name + '.war') {
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
{% endhighlight %}

## Zip it!
The dar package is really just a zip file with another extension. Easy, we just use the extension property on the zip task. The result of this task is a file in build/libs called webshop.dar.
{% highlight groovy %}
task dar (dependsOn: darManifest, type: Zip) {
    inputs.dir file(buildDir.path + '/dar')
    from buildDir.path + '/dar'
    destinationDir file(buildDir.path + '/libs')
    baseName = 'webshop'
    extension 'dar'
}
{% endhighlight %}

## Import it to XLDeploy
Building the deployment artifacts is a job for the build server. You don't wanna end up in a situation where your prod servers are running packages built from someones local machine. Who knows what kind of state the source was in at his or hers computer? Having that said, there are multiple ways of importing the dar package into XLDeploy. If you're running Jenkins, you could use the [XL Deploy Plugin](https://wiki.jenkins-ci.org/display/JENKINS/XL+Deploy+Plugin). You can also use XLDeploy's REST API, and I'll show you how.
{% highlight groovy %}
task uploadDarPackage(dependsOn: dar, type: Exec) {
    commandLine 'sh', 'uploadDar.sh', dar.outputs.files[0]
}
{% endhighlight %}
uploadDar.sh
{% highlight shell %}
#!/bin/sh
curl -u <username>:<password> -X POST -H "content-type:multipart/form-data" \
http://<host>:<port>/deployit/package/upload/tmp.dar -F fileData=@$1
{% endhighlight %}
