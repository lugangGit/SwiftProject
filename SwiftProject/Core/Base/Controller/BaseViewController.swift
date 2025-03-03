//
//  BaseViewController.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/31.
//

import UIKit

class BaseViewController: UIViewController, CustomNavigationBarProtocol {

    public var viewModel: BaseViewModel?
    
    public var navigationBar: BaseNavigationBar?

    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    /// viewModel 默认初始化 viewModel可以作为传递参数
    init(_ viewModel: BaseViewModel?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {

        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = AppColor.background
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleLanguageChange), name: Notification.Name(AppNotification.languageChanged), object: nil)
        
        makeUI()

        navigationBar = createNavigationBar()
        
        bindViewModel()
    }
    
    @objc func handleLanguageChange() {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    /// UI
    public func makeUI() {
        
    }

    /// 绑定触发 viewModel
    public func bindViewModel() {
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(AppNotification.languageChanged), object: nil)
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
