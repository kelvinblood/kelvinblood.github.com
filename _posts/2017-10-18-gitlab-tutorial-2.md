---
layout: post
title: gitlab 入门（二）—— gitlab文档目录
category: tech
tags: git gitlab docker
---
![](https://cdn.kelu.org/blog/tags/gitlab.jpg)

参照第一篇文章，安装好 gitlab 之后，接下来应该做点什么呢？感觉还是从看文档开始，更全面地了解gitlab。

所以这一篇看看官方文档<https://docs.gitlab.com/ce/README.html>里面都有些什么内容。

# 最受欢迎的文章

* [GitLab CI/CD](https://docs.gitlab.com/ce/ci/README.html) 
* [入门指南](https://docs.gitlab.com/ce/ci/quick_start/README.html) 
* [API](https://docs.gitlab.com/ce/api/README.html) 
* [Configuring `.gitlab-ci.yml`](https://docs.gitlab.com/ce/ci/yaml/README.html)
* [SSH 认证](https://docs.gitlab.com/ce/ssh/README.html)
* [Docker 镜像](https://docs.gitlab.com/ce/ci/docker/using_docker_images.html) 
* [GitLab Pages](https://docs.gitlab.com/ce/user/project/pages/index.html)

*   [用户文档](https://docs.gitlab.com/ce/user/index.html)
*   [管理员文档](https://docs.gitlab.com/ce/README.html#administrator-documentation)
*   [技术文章](https://docs.gitlab.com/ce/articles/index.html)

基本的用户操作，用过github的人应该都熟悉了。就略过去了，只看管理员文档。

## 管理员文档

### 安装，更新，升级，迁移

*   [安装](https://docs.gitlab.com/ce/install/README.html)
*   [Mattermost](https://docs.gitlab.com/omnibus/gitlab-mattermost/): Mattermost是一个“用于私有云的Slack替代方案”，GitLab将会“继续提供并推荐使用Mattermost，用于团队内部的交流”。
*   [将 GitLab CI迁移到CE / EE](https://docs.gitlab.com/ce/migrate_ci_to_ce/README.html)
*   [重启 GitLab](https://docs.gitlab.com/ce/administration/restart_gitlab.html)
*   [升级](https://docs.gitlab.com/ce/update/README.html)

### 用户权限

*   [访问控制](https://docs.gitlab.com/ce/user/admin_area/settings/visibility_and_access_controls.html#enabled-git-access-protocols)
*   [身份验证/授权 ](https://docs.gitlab.com/ce/topics/authentication/index.html#gitlab-administrators): Enforce 2FA, 配置LDAP，SAML，CAS和其他Omniauth提供者的外部身份验证。

### 特性

*   [Docker 容器注册](https://docs.gitlab.com/ce/administration/container_registry.html): 使用GitLab配置Docker注册表。
*   [Git hooks 钩子](https://docs.gitlab.com/ce/administration/custom_hooks.html)
*   [Git LFS](https://docs.gitlab.com/ce/workflow/lfs/lfs_administration.html): Git LFS（Large File Storage, 大文件存储）是可以把音乐、图片、视频等指定的任意文件存在 Git 仓库之外，而在 Git 仓库中用一个占用空间 1KB 不到的文本指针来代替的小工具。
*   [GitLab Pages](https://docs.gitlab.com/ce/administration/pages/index.html)
*   [高可用](https://docs.gitlab.com/ce/administration/high_availability/README.html)
*   [用户队列](https://docs.gitlab.com/ce/user/admin_area/user_cohorts.html) 
*   [Web terminals](https://docs.gitlab.com/ce/administration/integration/terminal.html)
*   GitLab CI
    *   [CI 管理](https://docs.gitlab.com/ce/user/admin_area/settings/continuous_integration.html): Define max artifacts size and expiration time.

### 集成

*   [集成](https://docs.gitlab.com/ce/integration/README.html): JIRA, Redmine, Twitter.
*   [Mattermost](https://docs.gitlab.com/ce/user/project/integrations/mattermost.html)

### 监控

*   [InfluxDB](https://docs.gitlab.com/ce/administration/monitoring/performance/introduction.html)
*   [Prometheus](https://docs.gitlab.com/ce/administration/monitoring/prometheus/index.html)
*   [检测正常运行时间](https://docs.gitlab.com/ce/user/admin_area/monitoring/health_check.html)

### 性能

*   [整理](https://docs.gitlab.com/ce/administration/housekeeping.html) 保持您的Git仓库整齐，快速。
*   [操作](https://docs.gitlab.com/ce/administration/operations.html) 保持GitLab的运行。
*   [轮询](https://docs.gitlab.com/ce/administration/polling.html) 配置GitLab UI轮询更新的频率。
*   [Request Profiling](https://docs.gitlab.com/ce/administration/monitoring/performance/request_profiling.html):获取缓慢请求的配置
*   [性能栏](https://docs.gitlab.com/ce/administration/monitoring/performance/performance_bar.html): 获取当前页面的性能信息

### 定制

*   [时区](https://docs.gitlab.com/ce/workflow/timezone.html)
*   [环境变量](https://docs.gitlab.com/ce/administration/environment_variables.html)
*   [logo](https://docs.gitlab.com/ce/customization/branded_page_and_email_header.html)
*   [关闭一个 Issue](https://docs.gitlab.com/ce/administration/issue_closing_pattern.html)
*   [Libravatar](https://docs.gitlab.com/ce/customization/libravatar.html): 使用Libravatar 替换 Gravatar .
*   [欢迎信息](https://docs.gitlab.com/ce/customization/welcome_message.html)

### 管理工具

*   [Gitaly](https://docs.gitlab.com/ce/administration/gitaly/index.html):Gitaly是一个Git RPC服务，用于处理GitLab发出的所有git调用。
*   [Raketasks](https://docs.gitlab.com/ce/raketasks/README.html): _Rake Task _是一些用Ruby 写的脚本，方便对程序进行批处理操作。比如备份，维护，自动Webhook设置和项目导入等。
    *   [备份还原](https://docs.gitlab.com/ce/raketasks/backup_restore.html)
*   [邮件回复](https://docs.gitlab.com/ce/administration/reply_by_email.html)
*   [Repository checks](https://docs.gitlab.com/ce/administration/repository_checks.html) 定期检查
*   [Repository storage paths](https://docs.gitlab.com/ce/administration/repository_storage_paths.html) 路径管理
*   [Security](https://docs.gitlab.com/ce/security/README.html)
*   [系统挂钩 hooks](https://docs.gitlab.com/ce/system_hooks/system_hooks.html)

### 故障排查

*   [调试提示](https://docs.gitlab.com/ce/administration/troubleshooting/debug.html)
*   [日志系统](https://docs.gitlab.com/ce/administration/logs.html)
*   [Sidekiq故障](https://docs.gitlab.com/ce/administration/troubleshooting/sidekiq.html)


# 参考资料

* [GitLab 安装配置心得记录](http://feg.netease.com/archives/gitlab-summary.html)
* <https://docs.gitlab.com/ce/README.html>
* [利用docker搭建gitlab及持续集成模块](http://blog.fatedier.com/2016/04/05/install-gitlab-supporting-ci-with-docker/)