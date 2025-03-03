# 开发框架

采用MVVM框架开发，代码结构分为App、Business、Core三层结构；

## App
路由管理

## Business
容器业务：底部菜单、二级菜单、组合栏目、综合栏目、搜索..

通用业务:新闻、直播、活动..

公共业务：登录、分享、评论...

## Core
1. models:跨业务的model
2. views:通用组件
3. manager:日志、网络、主题色单例库
4. networks:网络库封装

## ThirdParty

手动导入三方

## Resource

### fonts：方正字体

主要用 `FZYaSong-M-GBK_YS`

## SupportFile

### Info.plist 配置

### LaunchScreen 启动图

### Assets 图片资源

# 三方库管理

采用Carthage进行代码依赖；

* 安装carthage

    `brew install carthage`
    
* 运行carthage

 `    carthage update --use-xcframeworks --platform iOS `

* 更新单个库

 `    carthage update *** --use-xcframeworks --platform iOS `

## 采用[CocoaPods](https://cocoapods.org)方式 方便查看源码

```
安装 
gem install cocoapods

安装三方库
pod install
```

### [Rx](https://github.com/ReactiveX/RxSwift)

```
pod 'RxSwift', '6.5.0'
pod 'RxCocoa', '6.5.0'

Installing RxCocoa (6.5.0)
Installing RxRelay (6.5.0)
Installing RxSwift (6.5.0)
```

[ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift)

```
#pod 'ReactiveSwift', '~> 6.1'

Installing ReactiveSwift 6.7.0
```

### [网络Moya](https://github.com/Moya/Moya)

```
pod 'Moya', '~> 15.0'

Installing Alamofire (5.6.2)
Installing Moya (15.0.0)
```





### 数据

[SwiftyJSON)](https://github.com/SwiftyJSON/SwiftyJSON)、[ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper)、[RealmSwift](https://github.com/realm/realm-swift)

```
pod 'SwiftyJSON', '~> 4.0'
pod 'ObjectMapper', '~> 3.5'
pod 'RealmSwift', '~>10'


Installing ObjectMapper (3.5.3)
Installing SwiftyJSON (4.3.0)
Installing Realm (10.28.6)
Installing RealmSwift (10.28.6)
```

[RealmSwift文档](https://www.mongodb.com/docs/realm/sdk/swift/install/#std-label-ios-install)



### [布局SnapKit](https://github.com/search?q=SnapKit)

```
pod 'SnapKit', '~> 5.6.0'

Installing SnapKit (5.6.0)
```

### [刷新pull-to-refresh](https://github.com/eggswift/pull-to-refresh)

```
pod "ESPullToRefresh"

Installing ESPullToRefresh (2.9.3)
```

### [主题SwiftTheme](https://github.com/wxxsw/SwiftTheme)

```
pod 'SwiftTheme'


Installing SwiftTheme (0.6.4)
```

### [SDWebImage](https://github.com/SDWebImage/SDWebImage)

```
pod 'SDWebImage', '~> 5.0'


Installing SDWebImage (5.13.2)
```

### [YY系列](https://github.com/ibireme/YYKit)

```
pod 'YYText'

Installing YYText (1.0.7)
```

### [钥匙串](https://github.com/soffes/SAMKeychain)

```
pod 'SAMKeychain'

Installing SAMKeychain (1.5.3)
```



