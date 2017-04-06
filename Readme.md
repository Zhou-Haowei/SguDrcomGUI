# SguDrcomClientGUI



## SGUDrcomGUI

**SguDrcomGUI** 是以[**SguDrcomClient**](https://github.com/laijingwu/sgu_drcom_client)为核心(本页下方有介绍)，[Steven](https://github.com/Zhou-Haowei) 为韶关学院编写的**第三方 DrCom GUI客户端(目前仅适配MacOS)**，后续会对更多的平台进行适配。

SGUDrcomGUI 开发的初衷是为了提供另一种途径，使大家能更加自由地使用校园网，解决了在MacOS等平台下官方拨号器无法正常使用的现象。



## Special Thanks

**SguDrcomGUI** 的诞生离不开“巨人的肩膀”，特别是适配 DrCom 5.2.1 P版的，由 **Shindo** 编写的 **[EasyDrcomGUI](https://github.com/coverxit/EasyDrcomGUI)**。

本客户端在**Shindo** 编写的 **[EasyDrcomGUI](https://github.com/coverxit/EasyDrcomGUI)**的基础上进行了大规模重构。



## Notice

***MacOS：***

- 本客户端解决了在MacOS平台下官方拨号器无法正常使用的现象，能较快的进行内网拨号，外网拨号请使用系统原生PPPOE拨号。
- 受到系统和拨号协议限制，请在使用之前阅读使用须知，并在命令行中执行相应命令后再进行使用。
- Mac OS 版 SGUEasyDrcomGUI-MacOS使用 XCode 8.2.1 开发，语言为 C++（包括C++ 11的部分特性）和 Objective-C。
- 经过短暂的测试，借助于[**SguDrcomClient**](https://github.com/laijingwu/sgu_drcom_client)核心，解决了拨号协议的心跳问题，能保持在线，但由于测试时间较短，部分系统兼容性和软件健壮性不一定符合预期，希望在使用之后有问题的可以进行反映。




## Current Version

- MacOS: v1.0




## Supported OS

| macOS 10.12 Sierra (Already pass the test) |
| ---------------------------------------- |
| Mac OS X 10.11 El Capitan                |
| Mac OS X 10.10 Yosemite                  |
| Mac OS X 10.9 Mavericks                  |

- 注1：Mac OSX 10.12 Sierra及以下版本未经测试，其兼容性情况未知。
- 注2：受到系统和拨号协议限制，请在使用之前阅读使用须知，并在终端中执行相应命令后再进行使用。




## License

SGUDrcomGUI License:

```
Copyright (C) 2017 laijingwu & Steven
```

```
 Copyright (C) 2017 Steven
 Licensed under the GPL, Version 3.0 (the "License");
 You may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007	             				
 					<http://fsf.org/>
 
 Everyone is permitted to copy and distribute verbatim copies of             this license document.
 Changing it is not allowed.
```



EasyDrcomGUI License:

```
Copyright (C) 2014 - 2016 Shindo 
```

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissionss and
limitations under the License.
```



glibc License:

```
GNU C Library is licensed under GNU Lesser General Public License.
```

```
This library is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or (at
your option) any later version.

This library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
USA.
```



libpcap License:

```
License: BSD
```

```
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.
  3. The names of the authors may not be used to endorse or promote
     products derived from this software without specific prior
     written permission.

THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
```



STPrivilegedTask License:

```
STPrivilegedTask - NSTask-like wrapper around AuthorizationExecuteWithPrivileges
Copyright (C) 2009-2015 Sveinbjorn Thordarson <sveinbjornt@gmail.com>
 
BSD License
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of Sveinbjorn Thordarson nor that of any other
       contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.
  
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL  BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```



# SguDrcomClient

### Introduction

**SguDrcomClient** 是由 **[laijingwu](https://laijingwu.com)** 和 **[Steven-Zhou](https://github.com/Zhou-Haowei)** 联合为韶关学院特别编写的**第三方 DrCom 客户端**，适用于韶关学院西区丁香苑等接入电信网络且使用DrCom 5.2.1(X)客户端的学生宿舍，它依赖于libpcap, pthread库，可编译后运行于 *Linux*。暂时只适配 *Linux*，*MacOS* 后续将继续适配 *Windows, MacOS, OpenWrt*。

### Special Thanks

**SguDrcomClient** 的诞生离不开“巨人的肩膀”，特别是适配 DrCom 5.2.1 P版的，由 **Shindo** 编写的 **[EasyDrcom](https://github.com/coverxit/EasyDrcom)**。

此外，还要感谢 [**CuberL**](http://cuberl.com/2016/09/17/make-a-drcom-client-by-yourself/) 博客提供帮助。

### Special Attention

作者开源的初衷即是为了学习交流，严禁使用该源代码从事商业活动并从中谋取利益，如有违反，后果与作者无关。

### License

> Copyright (C) 2017 laijingwu & Steven-Zhou
>
> GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
>
> ​	<http://fsf.org/>
>
> Everyone is permitted to copy and distribute verbatim copies of this license document, but changing it is not allowed.



