//
//  Bundle+Ex.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/12.
//

import Foundation
import ObjectiveC

extension Bundle {
    private static var bundleKey: UInt8 = 0
    
    static var localizedBundle: Bundle? {
        get {
            return objc_getAssociatedObject(self, &bundleKey) as? Bundle
        }
        set {
            objc_setAssociatedObject(self, &bundleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    static func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            localizedBundle = nil
            return
        }
        localizedBundle = Bundle(path: path)
    }
    
    static var current: Bundle {
        return localizedBundle ?? Bundle.main
    }
    
    var localizedBundle: Bundle {
        return Bundle.current
    }
}
