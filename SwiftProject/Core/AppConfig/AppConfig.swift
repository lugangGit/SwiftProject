//
//  AppConfig.swift
//  Xiangyu
//
//  Created by 王盼盼 on 2022/7/20.
//

import Foundation


struct AppConfig: Codable {
    static var shared: AppConfig = {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: appMap, options: [])
            
//            let path = Bundle.main.path(forResource: "AppJson", ofType: "json")
//            let jsonData = NSData(contentsOfFile: path!)
            
            let appConfig = try JSONDecoder().decode(AppConfig.self, from: jsonData)
            return appConfig
        } catch {
            fatalError("初始化 AppConfig 失败: \(error)")
        }
    }()
    
    private init() { }
    
    /// app名字
    var appName = ""
    /// 状态
    var isRelease: Bool = false
    /// appId
    var appId = ""
    /// 后台获取
//    var app: App?
    /// ShareSDK
    var appShare: AppShare?
    /// 欢迎界面
    var showGuide = true
    /// 进入详情页获取积分停留时间
    var articleDetailScoreTime = 0
    /// 0是网站，1是触屏，2移动App，3分享页(只限稿件点赞)
    var channel: Int = 2
    /// 限制字数
    var limitWords: Int = 300
    /// 图片压缩比例
    var compressionQuality: CGFloat = 1.0
    var downloadUrl: String = ""
    /// tts
    var ttsAppId: String = ""
    /// 个推
    var geTui: GeTui?
    /// 推送是否注册appId tag
    var registerPushTag: Bool = true
    /// 推送序列
    var getuiSn: String = "sn1"
    /// 友盟
    var umeng: Umeng?
    /// link
    var jmlink: Jmlink?
    /// 积分商城开关
    var scoreMall: Bool = false
    /// 启动广告
    var bigDataEnable: Bool = false
    /// 是否展示栏目标签
    var showColumnNameTags: Bool = true
    /// 是否检测版本更新
    var detectVersionUpdates: Bool = true
    /// 小视频循环轮播
    var smallVideoLoopPlay: Bool = true
}

struct AppShare: Codable {
    var appKey: String? = ""
    var appSecret: String? = ""
    var universalLink: String? = ""
    var qq: QQ?
    var weibo: Weibo?
    var wechat: Wechat?
}

struct QQ: Codable {
    var appId: String? = ""
    var appKey: String? = ""
    var universalLink: String? = ""
}

struct Weibo: Codable {
    var appKey: String? = ""
    var appSecret: String? = ""
    var callbackUri: String? = ""
    var redirectUrl: String? = ""
    var universalLink: String? = ""
}

struct Wechat: Codable {
    var appId: String? = ""
    var appSecret: String? = ""
    var path: String? = ""
    var miniProgramId: String? = ""
}

struct GeTui: Codable {
    private var release: GeTuiInfo?
    private var test: GeTuiInfo?
    var appId: String {
        if AppConfig.shared.isRelease {
            return release?.appId ?? ""
        } else {
            return test?.appId ?? ""
        }
    }
    var appKey: String {
        if AppConfig.shared.isRelease {
            return release?.appKey ?? ""
        } else {
            return test?.appKey ?? ""
        }
    }
    var appSecret: String {
        if AppConfig.shared.isRelease {
            return release?.appSecret ?? ""
        } else {
            return test?.appSecret ?? ""
        }
    }
}

private struct GeTuiInfo: Codable {
    var appId: String?
    var appKey: String?
    var appSecret: String?
}

struct Umeng: Codable {
    var iosAppKey: String?
    var channel: String?
}

struct Jmlink: Codable {
    var appKey: String?
    var universalLink1: String?
    var universalLink2: String?
}
