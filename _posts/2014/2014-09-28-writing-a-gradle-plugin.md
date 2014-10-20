---
title: writing a gradle plugin
layout: post
---
A lot of the development teams in my company use Jenkins every day. We even have a big TV where we show the status of the builds. A while back we decided to convert our buildscript from Maven to Gradle. When we ran the first build on Jenkins everything went OK. But the second time, Jenkins started to complain about old timestamps on the test reports and marked the build as failed. 

I came across [this post](http://www.practicalgradle.org/blog/2011/06/incremental-tests-with-jenkins/) which provided a solution to update the timestamp on the test report files each build. It worked, and Jenkins got happy. I had to modify the code a bit to make it compatible with Gradle 2.x, since the original code uses some depricated properties.

### But why write a plugin from a piece of code thats not even 10 lines of code?
* Your build script will be a little shorter and a little cleaner
* I finally have something to blog about, besides how I created the blog

Checkout the GitHub page for the plugin: https://github.com/fowlie/gradle-jenkins-test
