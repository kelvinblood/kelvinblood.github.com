---
layout: post
title: npm ERR! Cannot read property 'match' of undefined 
category: tech
tags: front-end
---
![](https://cdn.kelu.org/blog/tags/frontend.jpg)

跟往常一样运行npm install 的时候报错：

```bash
npm ERR! Cannot read property 'match' of undefined

npm ERR! A complete log of this run can be found in:
npm ERR!      C:\Users\kelvi\AppData\Roaming\npm-cache\_logs\2019-05-19T04_45_45_641Z-debug.log
```



rm -rf node_modules
rm package-lock.json
npm cache clear --force

npm install
--------------------- 