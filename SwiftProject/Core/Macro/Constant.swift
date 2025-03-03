//
//  Constant.swift
//  Xiangyu
//
//  Created by 王盼盼 on 2022/7/19.
//

import Foundation

// UserDefaults Key
internal enum AppUserDefaultsKey {
    static let app = "kApp"
    static let user = AppConfig.shared.appName + "kUser"
    static let guide = "kGuide"
    static let realmSchemaVersion = "kRealmSchemaVersion"
    static let appVersion =  "kAppVersion"
    static let themeTypeKey = "kThemeTypeKey"
    static let languageKey = "kAppLanguage"

}


// UNotification name
internal enum AppNotification {
    static let themeChanged = "kThemeChanged"
    static let languageChanged = "kLanguageChanged"
}
