---
layout: post
title: Linux shell 新增 Cron 任务
category: tech
tags: linux
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

嗯.

```
# write out current crontab
crontab -l > mycron

# echo new cron into cron file
echo "00 09 * * 1-5 echo hello" >> mycron

# install new cron file
crontab mycron

rm mycron
```

# 参考资料

* [How to create a cron job using Bash automatically without the interactive editor?](https://stackoverflow.com/questions/878600/how-to-create-a-cron-job-using-bash-automatically-without-the-interactive-editor)
