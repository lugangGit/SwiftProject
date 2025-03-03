//
//  BaseTabBarController.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/24.
//

import UIKit

class BaseTabBarController: UITabBarController {
    public var viewModel: BaseViewModel?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(_ viewModel: BaseViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // 状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let selectedViewController = selectedViewController {
            return selectedViewController.preferredStatusBarStyle
        }
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        if let selectedViewController = selectedViewController {
            return selectedViewController.prefersStatusBarHidden
        }
        return false
    }
    
    // 屏幕旋转
    override var shouldAutorotate: Bool {
        if let selectedViewController = selectedViewController {
            return selectedViewController.shouldAutorotate
        }
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let selectedViewController = selectedViewController {
            return selectedViewController.supportedInterfaceOrientations
        }
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let selectedViewController = selectedViewController {
            return selectedViewController.preferredInterfaceOrientationForPresentation
        }
        return .portrait
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
