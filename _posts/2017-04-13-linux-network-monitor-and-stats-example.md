---
layout: post
title: Linux 网络监控与统计实例
category: tech
tags: linux shell
---

![](https://cdn.kelu.org/blog/tags/linux.jpg)

最近写到相关的代码，做个记录。

# 知识补充

首先补充本文用到的 Shell/Linux 的一些知识。

* 数组
* grep
* awk
* sed
* ss    
* tcpdump

## 数组

    ArrayName=("element 1" "element 2" "element 3") ## 定义数组
    ${distro[0]}        ## 访问数组
    ${#distro[@]}       ## 数组长度
    
## grep
    
实例：

    ifconfig | grep -E -o "^[a-z0-9]+" | grep -v "lo"
    ifconfig | grep -A 1 eth0

手册：
    
    grep [OPTIONS] PATTERN [FILE...]
    grep [OPTIONS] [-e PATTERN | -f FILE] [FILE...]
    
    Matcher Selection
       -E, --extended-regexp 正则
    General Output Control
        -o, --only-matching 仅匹配非空格
        -v, --invert-match 非匹配
    Context Line Control
        -A NUM, --after-context=NUM 打印匹配行之后第几行
        
## awk
        
以前写过一篇[Linux命令之awk](/tech/2015/01/21/linux-command-awk.html),详细内容可以进去查看。这里只涉及需要用到的。
    
实例：

    cat xxx | awk -F'[: ]+' '$0~/inet addr:/{printf $4"|"}
    awk -v eth=$eth -F'[: ]+' '{if ($0 ~eth){print $3,$11}}
    
手册：
    
    awk '/search pattern1/ {Actions}    
         /search pattern2/ {Actions}' file    
         
    * search pattern是正则表达式
    * Actions 输出的语法
    * 在Awk 中可以存在多个正则表达式和多个输出定义
    * file 输入文件名
    * 单引号的作用是包裹起来防止shell截断

背景概念：    
    
    awk默认是以行为单位处理文本的 awk中的两个术语：
    
        记录（默认就是文本的每一行）
        字段 （默认就是每个记录中由空格或TAB分隔的字符串）
    
    $0就表示一个记录，$1表示记录中的第一个字段。
    
解释：    
    
    -F'[: ]+' 以：或者空格作为分隔符
    $0表示一个记录(行)
    ~ 表示模式开始。/ /中是模式。
    /inet addr:/这就是一个正则表达式的匹配
    {printf $4"|"} 打印按照分隔符分割所成数组的第四个字段
    
    -v 是将 Shell 变量 $eth 的值传给 awk 变量。
    
## sed

sed在处理文本文件的时候，会在内存上创建一个模式空间，然后把这个文件的每一行调入模式空间用相应的命令处理，处理完输出；接着处理下一行，直到最后。

    cat xxx | sed -e 's/|$//' 
    cat xxx | sed  -n '1,3p' ## 打印1~3行

手册：

    sed [选项]  [定址commands] [inputfile]
    
    关于定址：
    定址可以是0个、1个、2个；通知sed去处理文件的哪几行。
    0个：没有定址，处理文件的所有行
    1个：行号，处理行号所在位置的行
    2个：行号、正则表达式，处理被行号或正则表达式包起来的行
    
    
##  /proc/net/dev

    Inter-|   Receive                                                |  Transmit
     face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
      ppp1: 2007461   25873    0    0    0     0          0         0 33320940   30484    0    0    0     0       0          0
        lo: 443577110 1042128    0    0    0     0          0         0 443577110 1042128    0    0    0     0       0          0
      ppp0: 5894011   36473    0    0    0     0          0         0 72146111   64491    0    0    0     0       0          0
    docker0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
      eth0: 59705148255 56461407    0    0    0     0          0         0 49418615742 41712001    0    0    0     0       0          0

## ss    

ss命令可以用来获取socket统计信息，它可以显示和netstat类似的内容。

## tcpdump

tcpdump可以将网络中传送的数据包的“头”完全截获下来提供分析。它支持针对网络层、协议、主机、网络或端口的过滤。

基本上tcpdump总的的输出格式为：系统时间 来源主机.端口 > 目标主机.端口 数据包参数

    -i eth0  # 监视指定网络接口的数据包 

# 例子


代码如下：[下载地址](https://www.centos.bz/wp-content/uploads/2014/06/network-analysis.sh)

    #!/bin/bash
     
    #write by zhumaohai(admin#centos.bz)
    #author blog: www.centos.bz
     
     
    #显示菜单(单选)
    display_menu(){
    local soft=$1
    local prompt="which ${soft} you'd select: "
    eval local arr=(\${${soft}_arr[@]})
    while true
    do
        echo -e "#################### ${soft} setting ####################\n\n"
        for ((i=1;i<=${#arr[@]};i++ )); do echo -e "$i) ${arr[$i-1]}"; done
        echo
        read -p "${prompt}" $soft
        eval local select=\$$soft
        if [ "$select" == "" ] || [ "${arr[$soft-1]}" == ""  ];then
            prompt="input errors,please input a number: "
        else
            eval $soft=${arr[$soft-1]}
            eval echo "your selection: \$$soft"             
            break
        fi
    done
    }
     
    #把带宽bit单位转换为人类可读单位
    bit_to_human_readable(){
        #input bit value
        local trafficValue=$1
     
        if [[ ${trafficValue%.*} -gt 922 ]];then
            #conv to Kb
            trafficValue=`awk -v value=$trafficValue 'BEGIN{printf "%0.1f",value/1024}'`
            if [[ ${trafficValue%.*} -gt 922 ]];then
                #conv to Mb
                trafficValue=`awk -v value=$trafficValue 'BEGIN{printf "%0.1f",value/1024}'`
                echo "${trafficValue}Mb"
            else
                echo "${trafficValue}Kb"
            fi
        else
            echo "${trafficValue}b"
        fi
    }
     
    #判断包管理工具
    check_package_manager(){
        local manager=$1
        local systemPackage=''
        if cat /etc/issue | grep -q -E -i "ubuntu|debian";then
            systemPackage='apt'
        elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
            systemPackage='yum'
        elif cat /proc/version | grep -q -E -i "ubuntu|debian";then
            systemPackage='apt'
        elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
            systemPackage='yum'
        else
            echo "unkonw"
        fi
     
        if [ "$manager" == "$systemPackage" ];then
            return 0
        else
            return 1
        fi   
    }
     
     
    #实时流量
    realTimeTraffic(){
        local eth=""
        local nic_arr=(`ifconfig | grep -E -o "^[a-z0-9]+" | grep -v "lo" | uniq`)
        local nicLen=${#nic_arr[@]}
        if [[ $nicLen -eq 0 ]]; then
            echo "sorry,I can not detect any network device,please report this issue to author."
            exit 1
        elif [[ $nicLen -eq 1 ]]; then
            eth=$nic_arr
        else
            display_menu nic
            eth=$nic
        fi   
     
        local clear=true
        local eth_in_peak=0
        local eth_out_peak=0
        local eth_in=0
        local eth_out=0
     
        while true;do
            #移动光标到0:0位置
            printf "\033[0;0H"
            #清屏并打印Now Peak
            [[ $clear == true ]] && printf "\033[2J" && echo "$eth--------Now--------Peak-----------"
            traffic_be=(`awk -v eth=$eth -F'[: ]+' '{if ($0 ~eth){print $3,$11}}' /proc/net/dev`)
            sleep 2
            traffic_af=(`awk -v eth=$eth -F'[: ]+' '{if ($0 ~eth){print $3,$11}}' /proc/net/dev`)
            #计算速率
            eth_in=$(( (${traffic_af[0]}-${traffic_be[0]})*8/2 ))
            eth_out=$(( (${traffic_af[1]}-${traffic_be[1]})*8/2 ))
            #计算流量峰值
            [[ $eth_in -gt $eth_in_peak ]] && eth_in_peak=$eth_in
            [[ $eth_out -gt $eth_out_peak ]] && eth_out_peak=$eth_out
            #移动光标到2:1
            printf "\033[2;1H"
            #清除当前行
            printf "\033[K"   
            printf "%-20s %-20s\n" "Receive:  $(bit_to_human_readable $eth_in)" "$(bit_to_human_readable $eth_in_peak)"
            #清除当前行
            printf "\033[K"
            printf "%-20s %-20s\n" "Transmit: $(bit_to_human_readable $eth_out)" "$(bit_to_human_readable $eth_out_peak)"
            [[ $clear == true ]] && clear=false
        done
    }
     
    #流量和连接概览
    trafficAndConnectionOverview(){
        if ! which tcpdump > /dev/null;then
            echo "tcpdump not found,going to install it."
            if check_package_manager apt;then
                apt-get -y install tcpdump
            elif check_package_manager yum;then
                yum -y install tcpdump
            fi
        fi
     
        local reg=""
        local eth=""
        local nic_arr=(`ifconfig | grep -E -o "^[a-z0-9]+" | grep -v "lo" | uniq`)
        local nicLen=${#nic_arr[@]}
        if [[ $nicLen -eq 0 ]]; then
            echo "sorry,I can not detect any network device,please report this issue to author."
            exit 1
        elif [[ $nicLen -eq 1 ]]; then
            eth=$nic_arr
        else
            display_menu nic
            eth=$nic
        fi
     
        echo "please wait for 10s to generate network data..."
        echo
        #当前流量值
        local traffic_be=(`awk -v eth=$eth -F'[: ]+' '{if ($0 ~eth){print $3,$11}}' /proc/net/dev`)
        #tcpdump监听网络
        tcpdump -v -i $eth -tnn > /tmp/tcpdump_temp 2>&1 &
        sleep 10
        clear
        kill `ps aux | grep tcpdump | grep -v grep | awk '{print $2}'`

        #10s后流量值
        local traffic_af=(`awk -v eth=$eth -F'[: ]+' '{if ($0 ~eth){print $3,$11}}' /proc/net/dev`)
        #打印10s平均速率
        local eth_in=$(( (${traffic_af[0]}-${traffic_be[0]})*8/10 ))
        local eth_out=$(( (${traffic_af[1]}-${traffic_be[1]})*8/10 ))
        echo -e "\033[32mnetwork device $eth average traffic in 10s: \033[0m"
        echo "$eth Receive: $(bit_to_human_readable $eth_in)/s"
        echo "$eth Transmit: $(bit_to_human_readable $eth_out)/s"
        echo

        local regTcpdump=$(ifconfig | grep -A 1 $eth | awk -F'[: ]+' '$0~/inet addr:/{printf $4"|"}' | sed -e 's/|$//' -e 's/^/(/' -e 's/$/)\\\\\.[0-9]+:/')
      
        #新旧版本tcpdump输出格式不一样,分别处理
        if awk '/^IP/{print;exit}' /tmp/tcpdump_temp | grep -q ")$";then
            #处理tcpdump文件
            awk '/^IP/{print;getline;print}' /tmp/tcpdump_temp > /tmp/tcpdump_temp2
        else
            #处理tcpdump文件
            awk '/^IP/{print}' /tmp/tcpdump_temp > /tmp/tcpdump_temp2
            sed -i -r 's#(.*: [0-9]+\))(.*)#\1\n    \2#' /tmp/tcpdump_temp2
        fi
        
        awk '{len=$NF;sub(/\)/,"",len);getline;print $0,len}' /tmp/tcpdump_temp2 > /tmp/tcpdump

        #统计每个端口在10s内的平均流量
        echo -e "\033[32maverage traffic in 10s base on server port: \033[0m"
        awk -F'[ .:]+' -v regTcpdump=$regTcpdump '{if ($0 ~ regTcpdump){line="clients > "$8"."$9"."$10"."$11":"$12}else{line=$2"."$3"."$4"."$5":"$6" > clients"};sum[line]+=$NF*8/10}END{for (line in sum){printf "%s %d\n",line,sum[line]}}' /tmp/tcpdump | \
        sort -k 4 -nr | head -n 10 | while read a b c d;do
            echo "$a $b $c $(bit_to_human_readable $d)/s"
        done
        echo -ne "\033[11A"
        echo -ne "\033[50C"
        echo -e "\033[32maverage traffic in 10s base on client port: \033[0m"
        awk -F'[ .:]+' -v regTcpdump=$regTcpdump '{if ($0 ~ regTcpdump){line=$2"."$3"."$4"."$5":"$6" > server"}else{line="server > "$8"."$9"."$10"."$11":"$12};sum[line]+=$NF*8/10}END{for (line in sum){printf "%s %d\n",line,sum[line]}}' /tmp/tcpdump | \
        sort -k 4 -nr | head -n 10 | while read a b c d;do
                echo -ne "\033[50C"
                echo "$a $b $c $(bit_to_human_readable $d)/s"
        done   
            
        echo

        #统计在10s内占用带宽最大的前10个ip
        echo -e "\033[32mtop 10 ip average traffic in 10s base on server: \033[0m"
        awk -F'[ .:]+' -v regTcpdump=$regTcpdump '{if ($0 ~ regTcpdump){line=$2"."$3"."$4"."$5" > "$8"."$9"."$10"."$11":"$12}else{line=$2"."$3"."$4"."$5":"$6" > "$8"."$9"."$10"."$11};sum[line]+=$NF*8/10}END{for (line in sum){printf "%s %d\n",line,sum[line]}}' /tmp/tcpdump | \
        sort -k 4 -nr | head -n 10 | while read a b c d;do
            echo "$a $b $c $(bit_to_human_readable $d)/s"
        done
        echo -ne "\033[11A"
        echo -ne "\033[50C"
        echo -e "\033[32mtop 10 ip average traffic in 10s base on client: \033[0m"
        awk -F'[ .:]+' -v regTcpdump=$regTcpdump '{if ($0 ~ regTcpdump){line=$2"."$3"."$4"."$5":"$6" > "$8"."$9"."$10"."$11}else{line=$2"."$3"."$4"."$5" > "$8"."$9"."$10"."$11":"$12};sum[line]+=$NF*8/10}END{for (line in sum){printf "%s %d\n",line,sum[line]}}' /tmp/tcpdump | \
        sort -k 4 -nr | head -n 10 | while read a b c d;do
            echo -ne "\033[50C"
            echo "$a $b $c $(bit_to_human_readable $d)/s"
        done 

        echo
        #统计连接状态
        local regSS=$(ifconfig | grep -A 1 $eth | awk -F'[: ]+' '$0~/inet addr:/{printf $4"|"}' | sed -e 's/|$//')
        ss -an | grep -v -E "LISTEN|UNCONN" | grep -E "$regSS" > /tmp/ss
        echo -e "\033[32mconnection state count: \033[0m"
        awk 'NR>1{sum[$(NF-4)]+=1}END{for (state in sum){print state,sum[state]}}' /tmp/ss | sort -k 2 -nr
        echo
        #统计各端口连接状态
        echo -e "\033[32mconnection state count by port base on server: \033[0m"
        awk 'NR>1{sum[$(NF-4),$(NF-1)]+=1}END{for (key in sum){split(key,subkey,SUBSEP);print subkey[1],subkey[2],sum[subkey[1],subkey[2]]}}' /tmp/ss | sort -k 3 -nr | head -n 10   
        echo -ne "\033[11A"
        echo -ne "\033[50C"
        echo -e "\033[32mconnection state count by port base on client: \033[0m"
        awk 'NR>1{sum[$(NF-4),$(NF)]+=1}END{for (key in sum){split(key,subkey,SUBSEP);print subkey[1],subkey[2],sum[subkey[1],subkey[2]]}}' /tmp/ss | sort -k 3 -nr | head -n 10 | awk '{print "\033[50C"$0}'   
        echo   
        #统计端口为80且状态为ESTAB连接数最多的前10个IP
        echo -e "\033[32mtop 10 ip ESTAB state count at port 80: \033[0m"
        cat /tmp/ss | grep ESTAB | awk -F'[: ]+' '{sum[$(NF-2)]+=1}END{for (ip in sum){print ip,sum[ip]}}' | sort -k 2 -nr | head -n 10
        echo
        #统计端口为80且状态为SYN-RECV连接数最多的前10个IP
        echo -e "\033[32mtop 10 ip SYN-RECV state count at port 80: \033[0m"
        cat /tmp/ss | grep -E "$regSS" | grep SYN-RECV | awk -F'[: ]+' '{sum[$(NF-2)]+=1}END{for (ip in sum){print ip,sum[ip]}}' | sort -k 2 -nr | head -n 10
    }
     
    main(){
        while true; do
            echo -e "1) real time traffic.\n2) traffic and connection overview.\n"
            read -p "please input your select(ie 1): " select
            case  $select in
                1) realTimeTraffic;break;;
                2) trafficAndConnectionOverview;break;;
                *) echo "input error,please input a number.";;
            esac
        done   
    }
     
    main

## 获得本机 ip

    ifconfig | grep -A 1 $eth | awk -F'[: ]+' '$0~/inet addr:/{printf $4"|"}' | sed -e 's/|$//' -e 's/^/(/' -e 's/$/)\\\\\.[0-9]+:/'
    
结果：
    
    (103.29.71.237)\\.[0-9]+:#

## 接口流量/proc/net/dev

    awk -F'[: ]+' '{if ($0 ~eth0){print $3,$11}}' /proc/net/dev

## tcpdump监听网络

    tcpdump -v -i eth0 -tnn > /tmp/tcpdump_temp 2>&1 &
    
## 杀死进程

    kill `ps aux | grep tcpdump | grep -v grep | awk '{print $2}'`
    
## 统计10s内速率

    awk -F'[ .:]+' -v regTcpdump=$regTcpdump '{if ($0 ~ regTcpdump){line="clients > "$8"."$9"."$10"."$11":"$12}else{line=$2"."$3"."$4"."$5":"$6" > clients"};sum[line]+=$NF*8/10}END{for (line in sum){printf "%s %d\n",line,sum[line]}}' /tmp/tcpdump | \
    sort -k 4 -nr | head -n 10 | while read a b c d;do
        echo "$a $b $c $(bit_to_human_readable $d)/s"
    done
    
这一段太复杂了，看不懂Orz    
    
# 参考资料
    
* [How To Find BASH Shell Array Length ( number of elements ))](https://www.cyberciti.biz/faq/finding-bash-shell-array-length-elements)    
* [Shell脚本编程30分钟入门](https://github.com/qinjx/30min_guides/blob/master/shell.md)    
* [网络分析shell脚本(实时流量+连接统计)](https://www.centos.bz/2014/06/shell-script-for-network-analysis/)    
* [Linux tcpdump命令详解](http://www.cnblogs.com/ggjucheng/archive/2012/01/14/2322659.html)
