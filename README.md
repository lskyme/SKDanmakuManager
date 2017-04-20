# SKDanmakuManager

只需几句代码，就可以快速地创建一条条弹幕并显示在播放界面上。

## 功能特点
- 弹幕基于CATextLayer，渲染更快性能消耗更少

- 弹幕的播放、暂停、显示和隐藏

- 速度范围设置

- 弹幕的垂直间距及水平间距设置

- 字体大小、颜色修改

- 开启/关闭碰撞检测

- 小屏及全屏切换

- 支持emoji表情 

#### TODO:
- 支持自定义字体

- 其他还没想到~

## 系统要求
	iOS 8.0+
## 效果图
- 发送弹幕（关闭碰撞检测）

  <img src="http://i4.buimg.com/591904/63f2640a61155020.gif">
  <img src="http://i4.buimg.com/591904/bcfad181fa9a6f55.gif">
  
- 发送弹幕（开启碰撞检测）

  <img src="http://i4.buimg.com/591904/951653069837919b.gif">

- 显示/隐藏弹幕

  <img src="http://i4.buimg.com/591904/b714489efbd8b3c2.gif">

- 暂停/继续弹幕

  <img src="http://i4.buimg.com/591904/7ddce125e43e2660.gif">

## 安装
### 1. Cocoapods
打开`Podfile`, 加入以下内容：

```
platform :ios, '8.0'
pod 'SKDanmakuManager', '~>1.0.0'
```
然后执行以下命令：
```
pod install
```
在项目中引入头文件`SKDanmakuManager/SKDanmakuManager.h`
### 2. Clone
打开命令行工具，执行以下命令：

```
git clone https://github.com/lskyme/SKDanmakuManager.git
```
将`SKDanmakuManager`文件夹引入项目中并添加头文件`SKDanmakuManager.h`即可。
## 使用方法
### 初始化
```
@property(nonatomic, strong) SKDanmakuManager *manager;
...
    _manager = [SKDanmakuManager managerWithLayer:_playerLayer];
	//or
    //_manager = [[SKDanmakuManager alloc] init];
    //_manager.layer = _playerLayer;
```
### 参数设置
```
///以下参数都有默认值，初始化后可以不改变
	//是否开启碰撞检测
    //_manager.allowCovered = NO;
    
    //设置弹幕字体大小
    _manager.fontSize = 15.0f;
    
    //设置弹幕最大/最小速度
    //_manager.maxSpeed = 100.0f;
    //_manager.minSpeed = 50.0f;
    
    //设置弹幕之间的垂直间距
    //_manager.verticalSpacing = 10.0f;
    
    //设置弹幕之间的水平间距
    //_manager.horizontalSpacing = 10.0f;
```

### 创建弹幕
```
	[_manager createDanmakuWithText:_inputTextField.text color:[UIColor whiteColor]];
```

### 屏幕大小改变
当视频的`frame`改变后（如进入全屏、退出全屏等），应该使用以下方法来刷新弹幕：

```
	[_manager layoutDanmakusWithFontSize:24];
```
### 其他功能
```
	请查看`SKDanmakuManager.h`头文件
```
## 许可
详情见`LICENSE`文件
## 声明
- 如果您在使用中发现了任何bug，请提交issue

- 如果您有任何意见或者建议，请联系`lskyme@sina.com`

- 如果您喜欢本库，请`star`一下表示支持

