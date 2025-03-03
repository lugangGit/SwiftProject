//
//  Extension.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/27.
//

import Foundation
import UIKit

extension AppConfig {
    /// baseUrl
    var baseUrl: String {
        if isRelease {
            if let url = appMap["baseUrl"] as? String {
                return url
            }
        } else {
//            if let result = AppCache.get(id: .baseUrl).stringValue, result.count > 0 {
//                return result
//            } else {
//                if let url = appMap["baseUrl"] as? String {
//                    return url
//                }
//            }
        }
        return KBaseUrl_Release
    }

    var guideStatus: Bool {
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: AppUserDefaultsKey.guide)
            userDefaults.synchronize()
        }
        get {
            let userDefaults = UserDefaults.standard
            let value = userDefaults.value(forKey: AppUserDefaultsKey.guide)
            if let value = value as? Bool, value == true {
                return true
            } else {
                return false
            }
        }
    }
    
    var realmSchemaVersion: Int {
        get {
            let userDefaults = UserDefaults.standard
            let value = userDefaults.value(forKey: "realmSchemaVersion")
            if let value = value as? Int {
                if AppConfig.shared.realmAppVersion == kAppVersion {
                    return value
                } else {
                    AppConfig.shared.realmAppVersion = kAppVersion
                    return updateRealmSchemaVersion()
                }
            } else {
                return updateRealmSchemaVersion()
            }
        }
    }
    
    @discardableResult
    func updateRealmSchemaVersion() -> Int {
        let userDefaults = UserDefaults.standard
        var version: Int = 0
        if let cacheVersion = userDefaults.value(forKey: AppUserDefaultsKey.realmSchemaVersion) as? Int {
            version = cacheVersion
        } else {
            version = 100
        }
        // 每次加1
        version += 1
        userDefaults.set(version, forKey: AppUserDefaultsKey.realmSchemaVersion)
        userDefaults.synchronize()
        return version
    }
    
    private var realmAppVersion: String {
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: AppUserDefaultsKey.appVersion)
            userDefaults.synchronize()
        }
        get {
            let userDefaults = UserDefaults.standard
            if let version = userDefaults.value(forKey: AppUserDefaultsKey.appVersion) as? String {
                return version
            } else {
                userDefaults.set(kAppVersion, forKey: AppUserDefaultsKey.appVersion)
                userDefaults.synchronize()
                return kAppVersion
            }
        }
    }
    
    /// 当前是否是暗黑状态[控制器返回可能不准确]
    static var isDark: Bool {
        switch ThemeManager.shared.currentThemeType {
        case .dark:
            return true
        case .normal:
            return false
        case .system:
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
}
