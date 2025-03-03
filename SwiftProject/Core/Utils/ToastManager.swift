//
//  ProgressHUDManager.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/15.
//

import UIKit
import SVProgressHUD

extension SVProgressHUD {
    enum Time: Double {
        case quickly = 1.0
        case custom = 1.5
        case long_3 = 3.0
        case long_5 = 5.0
        case long_10 = 10.0
        case forever = 100000000000.0
    }
}

enum ToastType {
    case text(message: String? = nil, delay: SVProgressHUD.Time = SVProgressHUD.Time.custom)      // 文字
    case loading(message: String? = nil)      // 加载
    case success(message: String, delay: SVProgressHUD.Time = SVProgressHUD.Time.custom) // 成功
    case error(message: String, delay: SVProgressHUD.Time = SVProgressHUD.Time.custom)   // 错误
    case info(message: String, delay: SVProgressHUD.Time = SVProgressHUD.Time.custom)    // 信息
    case progress(value: Float, message: String? = nil)      // 进度
    case custom(image: UIImage, message: String, delay: SVProgressHUD.Time = SVProgressHUD.Time.custom) // 自定义图标
}

class ToastManager {
    // MARK: - Setup
    static func initProgressHUD() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setRingThickness(4.0)
        SVProgressHUD.setRingRadius(24.0)
        SVProgressHUD.setCornerRadius(10.0)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.8))
        SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
    }

    // MARK: - Unified Display Method
    static func show(type: ToastType, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            switch type {
            case .text(let message, let delay):
                SVProgressHUD.setImageViewSize(CGSizeZero)
                SVProgressHUD.showInfo(withStatus: message)
                SVProgressHUD.dismiss(withDelay: delay.rawValue) {
                    completion?()
                }
            case .loading(let message):
                if let message = message {
                    SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
                    SVProgressHUD.show(withStatus: message)
                } else {
                    SVProgressHUD.show()
                }
            case .success(let message, let delay):
                SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
                SVProgressHUD.showSuccess(withStatus: message)
                SVProgressHUD.dismiss(withDelay: delay.rawValue) {
                    completion?()
                }
            case .error(let message, let delay):
                SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
                SVProgressHUD.showError(withStatus: message)
                SVProgressHUD.dismiss(withDelay: delay.rawValue) {
                    completion?()
                }
            case .info(let message, let delay):
                SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
                SVProgressHUD.showInfo(withStatus: message)
                SVProgressHUD.dismiss(withDelay: delay.rawValue) {
                    completion?()
                }
            case .progress(let value, let message):
                if let message = message {
                    SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
                    SVProgressHUD.showProgress(value, status: message)
                } else {
                    SVProgressHUD.showProgress(value)
                }
            case .custom(let image, let message, let delay):
                SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
                SVProgressHUD.show(image, status: message)
                SVProgressHUD.dismiss(withDelay: delay.rawValue) {
                    completion?()
                }
            }
        }
    }

    // MARK: - Dismiss
    static func dismiss(after delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss(withDelay: delay) {
                completion?()
            }
        }
    }
}

