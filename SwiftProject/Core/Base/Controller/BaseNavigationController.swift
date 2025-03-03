//
//  BaseNavigationController.swift
//  Xiangyu
//
//  Created by 王盼盼 on 2022/7/19.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        view.backgroundColor = AppColor.background
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let topViewController = topViewController {
            return topViewController.preferredStatusBarStyle
        }
        return .default
    }
    override var prefersStatusBarHidden: Bool {
        if let selectedViewController = topViewController {
            return selectedViewController.prefersStatusBarHidden
        }
        return false
    }
    
    // 屏幕旋转
    override var shouldAutorotate: Bool {
        if let selectedViewController = topViewController {
            return selectedViewController.shouldAutorotate
        }
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let selectedViewController = topViewController {
            return selectedViewController.supportedInterfaceOrientations
        }
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let selectedViewController = topViewController {
            return selectedViewController.preferredInterfaceOrientationForPresentation
        }
        return .portrait
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            print("暗黑模式")
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
