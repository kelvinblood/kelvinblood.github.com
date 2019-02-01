---
layout: post
title: Chrome 插件vimium —— vim党的福音
category: software
tags: chrome google
---

使用vimium已经很长时间了，然而每次应用仅限于hjkl几个上下左右键和KJ标签页操作这种最低级的操作。实际上vimium有很多实用的快捷键。 这几天换了新的办公地点，除了熟悉vimium这个插件外，索性给自己再来点新的感觉——使用左手鼠标。三天过去了，慢慢习惯了，确实不错。倒不是因为效率上带来的提高，而是由此带来的新鲜感，将平日的疲惫和懈怠感一扫而空。

# 最常用

hjkldu 页面内移动
JK 标签页切换
HL 后退前进 

| Command | Note |
|---|---|
| O	|在新标签页中打开 URl、书签或历史记录| 
| t	|创建一个新标签页| 
| x	|关闭当前标签页| 

# 页面导航

| Command | Note |
|---|---|
| j, `<c-e>` | 向下滚动| 
| k, `<c-y>` | 向上滚动| 
| h	| 向左滚动| 
| l	| 向右滚动| 
| gg	| 滚动到页面顶部| 
| G	| 滚动到页面底部| 
| zH	| 滚动到页面最左边| 
| zL	| 滚动到页面最右边| 
| d	| 向下滚动（相当于 PageDown 键）| 
| u	| 向上滚动（相当于 PageUp 键）| 
| r	|重载页面| 
| gs	|查看页面源代码| 
| yy	|复制当前 URL 到剪贴板| 
| yf	|复制一个 URL 链接到剪贴板| 
| p	|打开剪贴板中的 URL 到当前标签页| 
| P	|打开剪贴板中的 URL 到新标签页| 
| gu	|跳转到当前 URL 的上一层| 
| gU	|跳转到当前 URL 的最高层| 
| i	|进入插入模式| 
| v	|Enter visual mode (beta feature) (enterVisualMode)| 
| V	|Enter visual line mode (beta feature) (enterVisualLineMode)| 
| gi	|焦点第一个文本输入框。使用 tab 可以在文本输入框之间循环跳转| 
| f	|在当前标签页中打开一个链接| 
| F	|在新标签页中打开一个链接| 
| `<a-f>`	|在新标签页中打开多个链接| 
| `[[`	|Follow the link labeled previous or < (goPrevious)| 
| `]]`	|Follow the link labeled next or > (goNext)| 
| gf	|Cycle forward to the next frame on the page (nextFrame)| 
| gF	|Select the tab's main/top frame (mainFrame)| 
| m	|创建新标记| 



# 使用 Vomnibar 

| Command	|Note| 
|---|---|
| o	|打开 URl、书签或历史记录| 
| O	|在新标签页中打开 URl、书签或历史记录| 
| T	|搜索已打开的标签页| 
| b	|打开书签| 
| B	|在新窗口中打开书签| 
| ge	|编辑当前 URL| 
| gE	|编辑当前 URL 并在新标签页中打开| 

# 使用查询 

| Command	|Note| 
|---|---|
| /	|进入查询模式| 
| n	|下一个已查询到的值（页面内循环查找）| 
| N	|上一个已查询到的值（页面内循环查找）| 

# 导航历史 

| Command	|Note| 
|---|---|
| H	|根据浏览历史后退一页| 
| L	|根据浏览历史前进一页| 

# 标签操纵

| Command	|Note| 
|---|---|
| K, gt	| 向右移动一个标签页| 
| J, gT	| 向左移动一个标签页| 
| g0	|移动到第一个标签页| 
| g$	|移动到最后一个标签页| 
| t	|创建一个新标签页| 
| yt	|复制当前标签页| 
| x	|关闭当前标签页| 
| X	|恢复已关闭的标签页| 
| W	|将标签页移动到新窗口| 
| `<a-p>`|固定/取消固定当前标签页| 
| <<	| 向左移动标签页| 
| >>	| 向右移动标签页| 

# 其他 

| Command	|Note| 
|---|---|
| ?	|显示帮助| 

# 参考资料

* [Vimium 快捷键指南 - segmentfault](https://segmentfault.com/a/1190000004208306)
* [Vimium - github](https://github.com/philc/vimium)
