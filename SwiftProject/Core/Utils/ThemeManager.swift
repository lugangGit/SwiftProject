//
//  ThemeManage.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/30.
//

import UIKit

// 主题协议
protocol Theme {
    var interfaceStyle: UIUserInterfaceStyle { get }
}

// 默认主题实现
struct SystemTheme: Theme {
    var interfaceStyle: UIUserInterfaceStyle { .unspecified }
}

struct LightTheme: Theme {
    var interfaceStyle: UIUserInterfaceStyle { .light }
}

struct DarkTheme: Theme {
    var interfaceStyle: UIUserInterfaceStyle { .dark }
}

// 主题类型枚举
enum AppThemeType: Int {
    case system = 0
    case normal = 1
    case dark = 2
    
    // 通过枚举获取具体的主题实现
    func theme() -> Theme {
        switch self {
        case .system: return SystemTheme()
        case .normal: return LightTheme()
        case .dark: return DarkTheme()
        }
    }
}

class ThemeManager {
    
    // 单例模式
    static let shared = ThemeManager()
    private init() {}
    
    private(set) var currentThemeType: AppThemeType = .system // 当前主题类型
    
    /// 初始化主题（启动时调用）
    func initializeTheme() {
        currentThemeType = getCurrentTheme()
        applyTheme(currentThemeType.theme())
    }
    
    /// 切换并保存主题
    func saveTheme(_ type: AppThemeType) {
        guard type != currentThemeType else { return }
        
        currentThemeType = type
        saveThemeToStorage(type)
        applyTheme(type.theme())
        notifyThemeChanged()
    }
    
    /// 应用主题
    private func applyTheme(_ theme: Theme) {
        guard #available(iOS 13.0, *) else { return }
        
        // 设置所有窗口的 UI 样式
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = theme.interfaceStyle }
    }
    
    private func getCurrentTheme() -> AppThemeType {
        let value = UserDefaults.standard.integer(forKey: AppUserDefaultsKey.themeTypeKey)
        return AppThemeType(rawValue: value) ?? .system
    }
    
    private func saveThemeToStorage(_ type: AppThemeType) {
        UserDefaults.standard.set(type.rawValue, forKey: AppUserDefaultsKey.themeTypeKey)
    }
    
    private func notifyThemeChanged() {
        NotificationCenter.default.post(name: .themeChanged, object: currentThemeType)
    }
}

// 通知扩展
extension Notification.Name {
    static let themeChanged = Notification.Name(AppNotification.themeChanged)
}


//enum AppThemeType: Int {
//    case system = 0
//    case normal = 1
//    case dark = 2
//}
//
//extension AppColor {
//    /// 获取当前主题
//    static func currentTheme() -> AppThemeType {
//        let value = UserDefaults.standard.integer(forKey: AppUserDefaultsKey.themeTypeKey)
//        return AppThemeType(rawValue: value) ?? .system
//    }
//    
//    /// 保存主题并应用
//    static func saveTheme(_ type: AppThemeType) {
//        // 保存到 UserDefaults
//        UserDefaults.standard.set(type.rawValue, forKey: AppUserDefaultsKey.themeTypeKey)
//        UserDefaults.standard.synchronize()
//        
//        // 应用主题
//        applyTheme(type)
//    }
//    
//    /// 应用主题
//    static func applyTheme(_ type: AppThemeType) {
//        guard #available(iOS 13.0, *) else { return } // iOS 13 以下不支持
//        
//        // 设置样式
//        let style: UIUserInterfaceStyle
//        switch type {
//        case .system:
//            style = .unspecified
//        case .normal:
//            style = .light
//        case .dark:
//            style = .dark
//        }
//        
//        // 更新所有窗口的样式
//        UIApplication.shared.connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .flatMap { $0.windows }
//            .forEach { $0.overrideUserInterfaceStyle = style }
//    }
//    
//    /// 初始化应用主题（启动时调用）
//    static func initializeTheme() {
//        applyTheme(currentTheme())
//    }
//}
//
