# SguDrcomClientGUI

受到系统和拨号协议限制，请在使用之前阅读使用须知，并在终端中执行相应命令后再进行使用。

- Mac OS X 10.11 El Capitan和macOS 10.12 Sierra默认开启了SIP（System Integrity Protection），这会导致EasyDrcomGUI无法正常使用。如果您正在使用上述两个版本的系统，并且无法正常使用EasyDrcomGUI，请在禁用SIP后，在终端中输入下述命令以修复权限：

- ```shell
  sudo chmod 666 /dev/bpf* #赋予SGUDrcomGUI打开网卡接口的权限，执行后不会有提示
  ```


- 由于学校的内网认证的协议绑定了学生的MAC地址，需要将拨号的网卡的地址修改成绑定的MAC地址，请注意，修改的时候请确认网卡名称(如绑定的网卡就是现在所使用的网卡则跳过):

- ```shell
  ifconfig #可以用于查看需要修改MAC地址的网卡名
  sudo ifconfig en6 ether 44:8a:5b:f3:5f:49 #其中en6为对应的网卡名称，ether后为需要修改的MAC地址
  ```

- 最后，需要添加一个静态路由表，用于在PPPoE拨号后，确保认证心跳包能通过内网正确的发送到认证服务器，需要注意的是，请根据你现在所处的宿舍，输入对应的网关192.168.XXX.254 (XXX一般为所绑定的IP的第三组)后执行：

- ```shell
  sudo route -n add -net 192.168.0.0 -netmask 255.255.0.0 192.168.196.254  #添加路由表，参数分别为目的IP，子网掩码，默认网关
  ```


- 还要注意，某些系统在重启后以上命令会失效，嫌麻烦的话，可以新建一个shell脚本，在重启后执行会比较方便，使用编辑器新建空白文档并粘贴：

- ```shell
  #! /bin/bash
  chmod 666 /dev/bpf*
  route -n add -net 192.168.0.0 -netmask 255.255.0.0 192.168.196.254
  ifconfig en6 ether 44:8a:5b:f3:5f:49
  echo "Done"
  ```


- 保存成DrcomStart.sh(也就是shell脚本)到桌面，随后在终端中执行以下命令：

- ```shell
  cd ~/Desktop  #进入对应路径
  sudo chmod +x DrcomStart.sh  #赋予脚本执行权限
  sudo ./DrcomStart.sh  #运行对应脚本
  ```

- 假如没有报错并看到Done则证明大功告成了！

- 以上则是准备步骤，接下来打开SGUDrcomGUI，输入相应的账号和密码，点击连接就好了，看到已经连上则证明认证成功

- 外网拨号需要使用系统自带的PPPoE进行拨号，具体设置步骤详见百度





