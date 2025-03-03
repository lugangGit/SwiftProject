//
//  SwiftHeader.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/7.
//

import Foundation
import UIKit

//let KBaseUrl_Release = "https://appif-app.kjrb.com.cn/app_if/"
let KBaseUrl_Release = "https://api.rmdbw.cn/app_if/"
let KBaseUrl_Test = "http://csappif.stdaily.com:8090/app_if/"

// MARK: - 系统
var kKeyWindow: UIWindow {
    // 动态获取
    if let window = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap({ $0.windows })
        .first(where: { $0.isKeyWindow }) {
        return window
    } else {
        return UIWindow()
    }
}
let kAppName = Bundle.main.infoDictionary?["CFBundleDisplayName"]
let kAppVersion: String = {
    let infoDictionary = Bundle.main.infoDictionary
    if let info = infoDictionary {
        if info.keys.contains("CFBundleShortVersionString") {
            return info["CFBundleShortVersionString"] as! String
        } else {
            return ""
        }
    }
    return ""
}()
let kDeviceId = DeviceUtil.current.deviceId
let kModelName = DeviceUtil.current.modelName
let kSystemName = DeviceUtil.current.systemName
let kSystemVersion = UIDevice.current.systemVersion
let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
var kAppDelegate: AppDelegate? {
    UIApplication.shared.delegate as? AppDelegate
}


// MARK: - 尺寸系列
var kScreenWidth: CGFloat {
    UIScreen.main.bounds.width
}
var kScreenHeight: CGFloat {
    UIScreen.main.bounds.height
}
var kNavBarHeight: CGFloat {
    let navBarHeight = UINavigationController().navigationBar.frame.size.height
    return navBarHeight > 0 ? navBarHeight : 44
}
func kSafeAreaTop() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        //return kKeyWindow.safeAreaInsets.top
        
    } else {
        return 0
    }
}
func kSafeAreaBottom() -> CGFloat {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        //return kKeyWindow.safeAreaInsets.bottom
    } else {
        return 0
    }
}
func kStatusBarH() -> CGFloat {
    var height: CGFloat = 0
    if #available(iOS 13.0, *) {
        height = kKeyWindow.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        //return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
    } else {
        height = UIApplication.shared.statusBarFrame.height
    }
    // 11.2.6
    let defalutStatusHeight: CGFloat = 20.0
    if height < defalutStatusHeight {
        if kIsIphonXLater {
            return 44.0
        } else {
            return defalutStatusHeight
        }
    }
    return height
}

var kIsIphonXLater: Bool {
    // 是否是iPhone X以及 之后的机型
    kSafeAreaBottom() > 0
}
var kTopHeight: CGFloat {
    kSafeAreaTop() + kNavBarHeight
}
let kTabBarHeight = 49.0 //默认49.0 底部安全34
var kBottomHeight: CGFloat {
    kTabBarHeight + kSafeAreaBottom() // 加上安全范围
}
let kVideoHeight: CGFloat = CGFloat(ceil(kScreenWidth * 211.0 / 375.0))
/// 比例 对比iphone6的比例 如plus 比例 1.0 1.04 1.1 1.14
let kScale: CGFloat = round(min(kScreenWidth, kScreenHeight) / 375 * 100) / 100
/// 分割线 0.5
let kDividerHeight = 0.5
/// border 宽度 0.5
let kBorderHeight = 0.5
let kSpace10: CGFloat = 10.0
let kSpace15: CGFloat = 15.0
let kSpace20: CGFloat = 20.0
let kSpace4: CGFloat = 4.0

/// 全局 MarginLeft
var kGlobalMarinLeft: CGFloat {
    kSpace15
}
/// 15
var kGlobalMarinRight: CGFloat {
    kSpace15
}
/// 15
var kGlobalMarinTop: CGFloat {
    kSpace15
}
/// 15
var kGlobalMarinBottom: CGFloat {
    kSpace15
}

// MARK: - log日志
func PrintDebugLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let dateForamtter = getFormatter()
    dateForamtter.timeStyle = .medium
    dateForamtter.dateStyle = .none
    let time = dateForamtter.string(from: Date())

    let fileName = (file as NSString).lastPathComponent
    print("\(fileName) \(time) \(funcName) (\(lineNum)): \(message)")
    #endif
}


// MARK: - 颜色
func kColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}
func kColorRGB(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}
func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
}
func kColorRandom() -> UIColor {
    return UIColor(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1.0)
}


// MARK: - 闭包声明
typealias CompletionHandler = ((Bool, ResponseModel?) -> Void)
typealias VoidClosure = (() -> Void)
typealias DicType = [String: Any]


public func getFormatter(format: String = "yyyy-MM-dd HH:mm:ss") -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    /// 防止12小时制 HH 和 hh问题 设置 locale可以解决了
    formatter.locale = NSLocale.system
    formatter.calendar = Calendar.init(identifier: .gregorian)
    return formatter
}
// 时间formatter
public let fz_formatter = getFormatter()

//// MARK: - 用户
//var kUser: User {
//    User.currentUser()
//}
//var kUserId: Int {
//    kUser.userId
//}
///// 是否登录
//var isLogin: Bool {
//    User.isLogin()
//}
///// 是否没登录
//var isNotLogin: Bool {
//    !isLogin
//}
