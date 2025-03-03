//
//  BaseWebViewModel.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/24.
//

import UIKit
import SwiftyJSON

class BaseWebViewModel: BaseViewModel {
    var request: URLRequest?
    
    override init() {
    }
    
    // 便利初始化器
    convenience init(url: String?) {
        self.init()
        if let validURL = url, let urlObject = URL(string: validURL) {
            self.request = URLRequest(url: urlObject)
        } else {
            self.request = URLRequest(url: URL(string: "")!)
        }
    }
}
