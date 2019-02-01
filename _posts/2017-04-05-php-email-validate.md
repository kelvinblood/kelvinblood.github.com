---
layout: post
title: php 邮件验证
category: tech
tags: php
---

![](https://cdn.kelu.org/blog/tags/php.jpg)

起因是昨天看到有人twitter上吐槽网站遇到注册机：

![](https://cdn.kelu.org/blog/2017/04/20170406111051.jpg) 

一般拿来说，对于初级的注册机，可以在页面上添加一些字段作为session验证。也可以做一个IP统计窗口，同一个IP注册时限不得低于10s，IP连续注册超过N个识别为恶意IP然后封禁。

还有一个简单的办法，就是做邮箱有效性判断。当然也可以将这几个办法结合起来。这里我贴一个github上的邮箱有效性判断的代码。来源已经不记得在哪了Orz

    function emailValidate($email)
    {
        $isValid = true;
        $atIndex = strrpos($email, "@");
        if (is_bool($atIndex) && !$atIndex) {
            $isValid = false;
        } else {
            $domain = substr($email, $atIndex + 1);
            $local = substr($email, 0, $atIndex);
            $localLen = strlen($local);
            $domainLen = strlen($domain);
            if ($localLen < 1 || $localLen > 64) {
                // local part length exceeded
                info('local part length exceeded:' . $localLen);
                $isValid = false;
            } else if ($domainLen < 1 || $domainLen > 255) {
                // domain part length exceeded
                info('domain part length exceeded:' . $domainLen);
                $isValid = false;
            } else if ($local[0] == '.' || $local[$localLen - 1] == '.') {
                // local part starts or ends with '.'
                info('local part starts or ends with .:' . $localLen);
                $isValid = false;
            } else if (preg_match('/\\.\\./', $local)) {
                // local part has two consecutive dots
                info('local part has two consecutive dots:' . $local);
                $isValid = false;
            } else if (!preg_match('/^[A-Za-z0-9\\-\\.]+$/', $domain)) {
                // character not valid in domain part
                info('character not valid in domain part:' . $domain);
                $isValid = false;
            } else if (preg_match('/\\.\\./', $domain)) {
                // domain part has two consecutive dots
                info('domain part has two consecutive dots:' . $domain);
                $isValid = false;
            } else if (!preg_match('/^(\\\\.|[A-Za-z0-9!#%&`_=\\/$\'*+?^{}|~.-])+$/', str_replace("\\\\", "", $local))) {
                // character not valid in local part unless
                // local part is quoted
                if (!preg_match('/^"(\\\\"|[^"])+"$/', str_replace("\\\\", "", $local))) {
                    info('character not valid in local part: ' . $local);
                    $isValid = false;
                }
            }
            if ($isValid && !(checkdnsrr($domain, "MX") || checkdnsrr($domain, "A"))) {
                // domain not found in DNS
                $isValid = false;
            }
        }
        return $isValid;
    }