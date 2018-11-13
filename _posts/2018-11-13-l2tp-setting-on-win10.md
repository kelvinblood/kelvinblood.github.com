---
layout: post
title: 在 win10 中使用 l2tp
category: tech
tags: windows 
---
![](https://cdn.kelu.org/blog/tags/windows.jpg)

# 背景

工作需要，使用 l2tp 连接到当地环境，使用 win7 可以无障碍接入，但是 windows 10 死活没办法连上，看到鱼目混杂的一些资料鼓捣了一会，解决了这个问题，记录一下。

# 一、添加配置

1. 右键单击系统托盘中的无线/网络图标。
2. 选择 **打开网络和共享中心**。或者，如果你使用 Windows 10 版本 1709 或以上，选择 **打开"网络和 Internet"设置**，然后在打开的页面中单击 **网络和共享中心**。
3. 单击 **设置新的连接或网络**。
4. 选择 **连接到工作区**，然后单击 **下一步**。
5. 单击 **使用我的Internet连接 (VPN)**。
6. 在 **Internet地址** 字段中输入`你的 VPN 服务器 IP`。
7. 在 **目标名称** 字段中输入任意内容。单击 **创建**。
8. 返回 **网络和共享中心**。单击左侧的 **更改适配器设置**。
9. 右键单击新创建的 VPN 连接，并选择 **属性**。
10. 单击 **安全** 选项卡，从 **VPN 类型** 下拉菜单中选择 "使用 IPsec 的第 2 层隧道协议 (L2TP/IPSec)"。
11. 单击 **允许使用这些协议**。确保选中 "质询握手身份验证协议 (CHAP)" 复选框。

![54210938867](https://cdn.kelu.org/blog/2018/11/1542109388672.jpg)

![54210948167](https://cdn.kelu.org/blog/2018/11/1542109481677.jpg)

# 二、检查IPsec Policy Agent服务

Windows + R -> 运行 ，输入 services.msc，打开“服务”窗口。确认 IPsec Policy Agent 服务开启。

![54210928568](https://cdn.kelu.org/blog/2018/11/1542109285685.jpg)

# 三、修改注册表

来自官方的解答：

[Win10 VPN L2TP始终连接不上 已经根据网上所说的改成1了](https://answers.microsoft.com/zh-hans/windows/forum/all/win10-vpn/cb5d27a0-1ef5-4c2f-9acb-c4a36d93680c)

需要修改注册表信息，同时按快捷键“Win + R”，打开“运行”窗口，输入 regedit 命令，然后点击“确定”

   在“注册表编辑器”中，找到以下注册表子项：

1. `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Rasman\Parameters`
   * 新建一个DWORD类型，名为ProhibitIpSec，然后然后创建DWORD值为1
   * 找到“AllowL2TPWeakCrypto”，然后把值改成“1”
2. `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PolicyAgent`
   * 新建一个DWORD类型，名为AssumeUDPEncapsulationContextOnSendRule的键，将值修改为2 。

![54210897098](https://cdn.kelu.org/blog/2018/11/1542108970985.jpg)



# 四、重启

# 参考资料

* <https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients-zh.md#windows>
* <https://answers.microsoft.com/zh-hans/windows/forum/all/win10-vpn/cb5d27a0-1ef5-4c2f-9acb-c4a36d93680c>

