import Foundation
import UIKit

enum AppLanguage: String {
    case english = "en"
    case chinese = "zh-Hans"
    
    static var `default`: AppLanguage {
        return .chinese
    }
    
    static var all: [AppLanguage] {
        return [.chinese, .english]
    }
}

final class LanguageManager {
    static let shared = LanguageManager()
    private let languageKey = AppUserDefaultsKey.languageKey
    
    private init() {}
    
    func initLanguage() {
        if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
           let language = AppLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            currentLanguage = getPreferredLanguage()
        }
    }
    
    var currentLanguage: AppLanguage {
        get {
            if let savedLanguage = UserDefaults.standard.string(forKey: languageKey),
               let language = AppLanguage(rawValue: savedLanguage) {
                return language
            }
            return getPreferredLanguage()
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: languageKey)
            UserDefaults.standard.synchronize()
            applyLanguage(newValue)
        }
    }
    
    func isLanguageAvailable(_ language: AppLanguage) -> Bool {
        return Bundle.main.path(forResource: language.rawValue, ofType: "lproj") != nil
    }
    
    private func getPreferredLanguage() -> AppLanguage {
        if let preferredLanguage = Locale.preferredLanguages.first,
           let language = AppLanguage(rawValue: preferredLanguage),
           isLanguageAvailable(language) {
            return language
        }
        return AppLanguage.default
    }
    
    private func applyLanguage(_ language: AppLanguage) {
        guard isLanguageAvailable(language) else {
            print("Warning: Language bundle not found for \(language.rawValue)")
            return
        }
        
        Bundle.setLanguage(language.rawValue)
        NotificationCenter.default.post(
            name: Notification.Name(AppNotification.languageChanged),
            object: language
        )
        
        #if DEBUG
        print("Language changed to: \(language.rawValue)")
        #endif
    }
}
