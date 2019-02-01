---
layout: post
title: github项目介绍 —— intellij-colors-solarized
category: tech
tags: intellij github
---
![](https://cdn.kelu.org/blog/tags/solarized.jpg)

项目地址：[jkaving](https://github.com/jkaving) / **[intellij-colors-solarized](https://github.com/jkaving/intellij-colors-solarized)**

这是一个 IDE 颜色配置的的方案。一直以来都是用浅色的，今天感觉眼睛又些累，遂选了这一款主题。

# 安装

### 1： 使用“导入设置...”

1. 转到`File | Import Settings...`并指定`intellij-colors-solarized`目录或`settings.jar`文件。单击`OK`出现的对话框。
2. 重启IntelliJ IDEA
3. 转到`Preferences | Editor | Colors & Fonts`并选择一个新的颜色主题。

### 2：手动安装

1. 复制`Solarized Dark.icls`并`Solarized Light.icls` 到 IntelliJ IDEA 首选项颜色的目录。*可能需要创建colors目录。*

   它通常在这些地方：

   **Mac OS X.**

   - `~/Library/Preferences/IntelliJIdeaXX/colors` [（IntelliJ IDEA终极版）](https://www.jetbrains.com/idea/help/project-and-ide-settings.html)，
   - `~/Library/Preferences/IdeaICXX/colors` [（IntelliJ IDEA社区版）](https://www.jetbrains.com/idea/help/project-and-ide-settings.html)，
   - `~/Library/Preferences/WebIDE70/colors` [（PHPStorm 7.0）](https://www.jetbrains.com/phpstorm/help/project-and-ide-settings.html)，
   - `~/Library/Preferences/WebIDE80/colors` [（PHPStorm 8.0）](https://www.jetbrains.com/phpstorm/help/project-and-ide-settings.html)，
   - `~/Library/Preferences/WebStorm8/colors` [（WebStorm 8.0）](https://www.jetbrains.com/webstorm/help/project-and-ide-settings.html)。

   **Linux**

   - `~/.<PRODUCT><VERSION>/colors` 通用路径，
   - `~/.IdeaICXX/config/colors` [（IntelliJ IDEA）](https://www.jetbrains.com/idea/help/project-and-ide-settings.html)，
   - `~/.PyCharmXX/colors` [（PyCharm）](https://www.jetbrains.com/pycharm/help/project-and-ide-settings.html)。

   **Win**

   - `%USERPROFILE%\.IdeaICXX\config\colors` [（IntelliJ IDEA社区版）](https://www.jetbrains.com/idea/help/project-and-ide-settings.html)，
   - `%USERPROFILE%\.PyCharm40\config\colors` [（PyCharm 4.5社区版）](https://www.jetbrains.com/pycharm/help/project-and-ide-settings.html)。

2. 重启IntelliJ IDEA

3. 转到`Preferences | Editor | Colors & Fonts`并选择一个新的颜色主题。