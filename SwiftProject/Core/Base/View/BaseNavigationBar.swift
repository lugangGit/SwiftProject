//
//  BaseNavigationBar.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/2.
//

import UIKit

protocol CustomNavigationBarProtocol {
    /// 创建导航栏
    func createNavigationBar() -> BaseNavigationBar
}

extension CustomNavigationBarProtocol where Self: UIViewController {
    @discardableResult func createNavigationBar() -> BaseNavigationBar {
        let naviBar = BaseNavigationBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kTopHeight))
        naviBar.currentVC = self
        view.addSubview(naviBar)
        view.bringSubviewToFront(naviBar)
        return naviBar
    }
}

class BaseNavigationBar: UIView {
    weak var currentVC: UIViewController? {
        didSet {
            setBackButton()
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleView: UIView? {
        didSet {
            setTitleView()
        }
    }

    public lazy var container: UIView = {
        let container = UIView()
        addSubview(container)
        return container
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppTextStyle.title20.font
        label.textColor =  AppTextStyle.title20.textColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.font(UIFont.systemFont(ofSize: 16))
        button.setImage(UIImage(named: ImageName.navibar_back_grey), for: .normal)
        button.addTarget(self, action: #selector(leftButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.font(UIFont.systemFont(ofSize: 16))
        button.addTarget(self, action: #selector(rightButtonAction(_:)), for: .touchUpInside)
        container.addSubview(button)
        return button
    }()
    
    
    lazy var bottomLineView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = AppColor.divider
        return view
    }()
    
    var leftButtonClick:(() -> Void)?
    var rightButtonClick:(() -> Void)?
    
    init() {
        super.init(frame: CGRect.zero)
        makeUI()
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
      
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    // MARK: - Setup Methods
    private func makeUI() {
        backgroundColor = AppColor.canvas
        container.backgroundColor = AppColor.canvas
        
        self.addSubview(container)
        container.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(kNavBarHeight)
        }
        
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            // 小于等于
            make.width.lessThanOrEqualTo(kScreenWidth - 100)
        }
        
        container.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
      private func setBackButton() {
          guard let navigationController = currentVC?.navigationController,
                navigationController.viewControllers.first != currentVC else { return }
          
          container.addSubview(leftButton)
          leftButton.snp.makeConstraints { make in
              make.left.equalTo(4)
              make.centerY.equalToSuperview()
              make.size.equalTo(CGSize(width: 44, height: 44))
          }
      }
      
    
    private func setTitleView() {
        guard let titleView = titleView else { return }
        titleLabel.removeFromSuperview()
        container.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - 100)
        }
    }
    
    func setLeftButton(title: String? = nil, image: UIImage? = nil, action: Selector? = nil, target: Any? = nil) {
        leftButton.setTitle(title, for: .normal)
        leftButton.setImage(image, for: .normal)
         if let action = action {
             leftButton.addTarget(target, action: action, for: .touchUpInside)
         }
     }
    
    func setRightButton(title: String? = nil, image: UIImage? = nil, action: Selector? = nil, target: Any? = nil) {
        rightButton.setTitle(title, for: .normal)
        rightButton.setImage(image, for: .normal)
        if let action = action, let target = target {
            rightButton.addTarget(target, action: action, for: .touchUpInside)
        }
        rightButton.snp.makeConstraints { make in
            make.right.equalTo(-4)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
     }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension BaseNavigationBar {
    @objc fileprivate func leftButtonAction(_ button: UIButton) -> Void {
        if let leftButtonClick = leftButtonClick {
            leftButtonClick()
            return
        }
        guard currentVC?.navigationController != nil else {
            currentVC?.dismiss(animated: true, completion: nil)
            return
        }
        if currentVC?.navigationController?.popViewController(animated: true) == nil {
            currentVC?.dismiss(animated: true)
        }
    }
    
    @objc fileprivate func rightButtonAction(_ button: UIButton) -> Void {
        if let rightButtonClick = rightButtonClick {
            rightButtonClick()
       } else {
           print("右侧按钮点击")
       }
    }
    
    func scrollPercent(percent: CGFloat) {
        backgroundColor = rgba(255, 255, 255, percent)
        container.backgroundColor = rgba(255, 255, 255, percent)
        bottomLineView.alpha = percent
        if percent > 0.5 {
            leftButton.setImage(UIImage(named: ImageName.navibar_back_grey), for: .normal)
            rightButton.setImage(UIImage(named: ImageName.navibar_more_grey), for: .normal)
        } else {
            leftButton.setImage(UIImage(named: ImageName.navibar_back_white), for: .normal)
            rightButton.setImage(UIImage(named: ImageName.navibar_more_white), for: .normal)
        }
    }
}

