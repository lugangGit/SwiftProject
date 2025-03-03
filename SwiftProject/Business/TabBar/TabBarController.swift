//
//  TabBarController.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/24.
//

import UIKit

/// TabBar 配置结构体
struct TabBarItemConfiguration {
    let title: String
    let image: UIImage?
    let selectedImage: UIImage?
    let viewController: UIViewController
    let contentView: TabBarItemContentView
}

class TabBarController: BaseTabBarController, TabBarDelegate, UITabBarControllerDelegate {
    
    lazy var tabBarVM: TabBarViewModel = {
        if viewModel != nil {
            return viewModel as! TabBarViewModel
        } else {
            fatalError("init(_ viewModel:) has not been implemented")
        }
    }()
    
    /// Observer tabBarController's selectedIndex. change its selection when it will-set.
    open override var selectedIndex: Int {
        willSet {
            guard let tabBar = self.tabBar as? TabBar, let items = tabBar.items else {
                return
            }
            tabBar.select(itemAtIndex: newValue, animated: false)
        }
    }
    
    var navigator: Navigator!

    // 初始化方法，接受一个配置数组
    init(_ viewModel: BaseViewModel?, navigator: Navigator) {
        super.init(viewModel)
        self.navigator = navigator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 使用自定义的 UITabBar
        let customTabBar = TabBar()
        customTabBar.backgroundColor = AppColor.canvas
        customTabBar.customDelegate = self
        self.delegate = self
        self.setValue(customTabBar, forKey: "tabBar")

        let configurations = [
            TabBarItemConfiguration(
                title: "home".localized,
                image: UIImage(named: ImageName.tabbar_home),
                selectedImage: UIImage(named: ImageName.tabbar_home_press),
                viewController: HomeViewController(HomeViewModel(title: "首页")),
                contentView: BasicContentView()
            ),
            TabBarItemConfiguration(
                title: "",
                image: UIImage(named: ImageName.tabbar_play),
                selectedImage: UIImage(named: ImageName.tabbar_play_press),
                viewController: AIAssistantViewController(),
                contentView: irregularityContentView()
            ),
            TabBarItemConfiguration(
                title: "mine".localized,
                image: UIImage(named: ImageName.tabbar_me),
                selectedImage: UIImage(named: ImageName.tabbar_me_press),
                viewController: MineViewController(BaseViewModel()),
                contentView: BasicContentView()
            )
        ]
        setupTabBar(with: configurations)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLanguageChange), name: Notification.Name(AppNotification.languageChanged), object: nil)
    }
    
    @objc func handleLanguageChange() {

        // 更新 TabBar 标题
        if let items = self.tabBar.items {
            // 使用原始配置的索引更新标题
            items[0].title = "home".localized
            // 中间按钮保持空标题
            items[2].title = "mine".localized
        }
        
        // 强制更新界面
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

    
    /// 设置 TabBar 的子控制器
    private func setupTabBar(with configurations: [TabBarItemConfiguration]) {
        var viewControllers: [UIViewController] = []
        
        configurations.forEach { config in
            let navController = createNavController(for: config.viewController,
                                                    contentView: config.contentView,
                                                    title: config.title,
                                                    image: config.image,
                                                    selectedImage: config.selectedImage)
            viewControllers.append(navController)
        }
        
        self.viewControllers = viewControllers
    }
    
    /// 创建导航控制器
    private func createNavController(for rootViewController: UIViewController,
                                      contentView: TabBarItemContentView,
                                      title: String,
                                      image: UIImage?,
                                      selectedImage: UIImage?) -> UINavigationController {
        rootViewController.title = title
        let navController = BaseNavigationController(rootViewController: rootViewController)
        navController.tabBarItem = TabBarItem.init(contentView, title: title, image: image, selectedImage: selectedImage)
        return navController
    }
    

    // MARK: - ESTabBar delegate
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
        }
        return true
    }
    
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
        }
        return true
    }
    
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem) {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            print("didHijack called for \(vc.title ?? "Unknown")")
//            delegate?.tabBarController!(self, shouldSelect: vc)
            selectedIndex = idx
        }
    }
    
//     func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//         print("shouldSelect called for \(viewController.title ?? "Unknown")")
//         return true
//     }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(AppNotification.languageChanged), object: nil)
    }
}



