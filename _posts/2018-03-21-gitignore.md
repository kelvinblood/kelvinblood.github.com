---
layout: post
title: 适用于各种项目的 gitignore
category: tech
tags: linux git
---
![](https://cdn.kelu.org/blog/tags/git.jpg)

这篇文章会不断更新。

### 简约版

```
# Eclipse
.classpath
.project
.settings/
 
# Intellij
.idea/
*.iml
*.iws
 
# Mac
.DS_Store
 
# Maven
log/
target/

# Vim
*~
*.swp
```

### 完全版

以下是由 github 官方维护的，专门针对 JetBrains 全线产品的 gitignore:

```
# Covers JetBrains IDEs: IntelliJ, RubyMine, PhpStorm, AppCode, PyCharm, CLion, Android Studio and WebStorm
# Reference: https://intellij-support.jetbrains.com/hc/en-us/articles/206544839

# User-specific stuff
.idea/**/workspace.xml
.idea/**/tasks.xml
.idea/dictionaries

# Sensitive or high-churn files
.idea/**/dataSources/
.idea/**/dataSources.ids
.idea/**/dataSources.local.xml
.idea/**/sqlDataSources.xml
.idea/**/dynamic.xml
.idea/**/uiDesigner.xml

# Gradle
.idea/**/gradle.xml
.idea/**/libraries

# CMake
cmake-build-debug/
cmake-build-release/

# Mongo Explorer plugin
.idea/**/mongoSettings.xml

# File-based project format
*.iws

# IntelliJ
out/

# mpeltonen/sbt-idea plugin
.idea_modules/

# JIRA plugin
atlassian-ide-plugin.xml

# Cursive Clojure plugin
.idea/replstate.xml

# Crashlytics plugin (for Android Studio and IntelliJ)
com_crashlytics_export_strings.xml
crashlytics.properties
crashlytics-build.properties
fabric.properties

# Editor-based Rest Client
.idea/httpRequests
```



# 参考资料

* [github/gitignore](https://github.com/github/gitignore/blob/master/Global/JetBrains.gitignore)

