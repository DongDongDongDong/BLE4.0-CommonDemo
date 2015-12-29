# BLE4.0-CommonDemo
蓝牙4.0搜索，配对，连接，数据传输等... 最近公司项目中刚好涉及到了蓝牙这块，顺便把自己写的调试demo传上来，代码有详尽注释，方便日后学习交流用。
此demo仅供参考。
在写代码之前，还是应该先捋一下BLE的基础知识和开发思路：
iOS中蓝牙的实现方案

iOS中提供了4个框架用于实现蓝牙连接
GameKit.framework（用法简单）
只能用于iOS设备之间的连接，多用于游戏（比如五子棋对战），从iOS7开始过期

MultipeerConnectivity.framework
只能用于iOS设备之间的连接，从iOS7开始引入，主要用于文件共享（仅限于沙盒的文件）

ExternalAccessory.framework
可用于第三方蓝牙设备交互，但是蓝牙设备必须经过苹果MFi认证（国内较少）

CoreBluetooth.framework（时下热门）
可用于第三方蓝牙设备交互，必须要支持蓝牙4.0
硬件至少是4s，系统至少是iOS6
蓝牙4.0以低功耗著称，一般也叫BLE（BluetoothLowEnergy）
目前应用比较多的案例：运动手坏、嵌入式设备、智能家居
1.CoreBluetooth框架的核心其实是两个东西，peripheral和central, 可以理解成外设和中心。对应他们分别有一组相关的API和类
