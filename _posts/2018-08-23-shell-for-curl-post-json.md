---
layout: post
title: linux 下 CURL POST JSON 数据
category: tech
tags: linux curl
---
![](https://cdn.kelu.org/blog/tags/linux.jpg)

纯粹做个记录，在 Jenkins 的 pipeline 脚本中，需要 curl post 一个 json 数据到远端应用，临时实现如下：

```
steps {

sh '''\
echo $TEST_URL/$JOB_NAME/$BUILD_ID
while [[ $(curl -sL -w "%{http_code}" -H "'Content-type':'application/json'" -X POST "$TEST_URL/$JOB_NAME/$BUILD_ID" -d '{"image":"'$MY_TAG'","kelu":"'test'"}' -o /dev/null) != "200" ]]; do
echo "backend is unavailable - sleeping"
sleep 5
done
'''

}
```

需要注意的是 -H 、 -X 和 -d 参数。如果不带 -H 参数，则 -d 中传递的是普通的 POST 参数，远端使用 json 解析是解析不出来的。