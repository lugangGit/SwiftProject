//
//  TabBar.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/4.
//

import UIKit

/// 对UITabBarDelegate进行扩展，以支持UITabBarControllerDelegate的相关方法桥接
internal protocol TabBarDelegate: NSObjectProtocol {

    /// 当前item是否支持选中
    ///
    /// - Parameters:
    ///   - tabBar: tabBar
    ///   - item: 当前item
    /// - Returns: Bool
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool
    
    /// 当前item是否需要被劫持
    ///
    /// - Parameters:
    ///   - tabBar: tabBar
    ///   - item: 当前item
    /// - Returns: Bool
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool
    
    /// 当前item的点击被劫持
    ///
    /// - Parameters:
    ///   - tabBar: tabBar
    ///   - item: 当前item
    /// - Returns: Void
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem)
}


class TabBar: UITabBar, UITabBarDelegate {
    
    internal weak var customDelegate: TabBarDelegate?
    
    var curIndex: Int?
    
    override var items: [UITabBarItem]? {
        didSet {
            reload()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = self
    }
       
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updateLayout()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    internal func reload() {
        guard let tabBarItems = self.items else {
            return
        }

        for (idx, item) in tabBarItems.enumerated() {
            if let item = item as? TabBarItem, let contentView = item.contentView {
                item.contentView?.frame = CGRect(x: kScreenWidth / CGFloat(tabBarItems.count) * CGFloat((idx)), y: item.contentView?.insets.top ?? 0, width: kScreenWidth / CGFloat(tabBarItems.count), height: kBottomHeight)
                // 添加点击手势
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                item.contentView?.tag = idx+1000
                item.contentView?.addGestureRecognizer(tapGesture)
                item.contentView?.isUserInteractionEnabled = true
                item.contentView?.updateLayout()
                addSubview(contentView)
            }
        }
        
        self.setNeedsLayout()
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let newIndex = max(0, sender.view!.tag - 1000)
        if (newIndex != curIndex) {
            select(itemAtIndex: newIndex, animated: true)
            if let item = self.items?[newIndex] as? TabBarItem {
                customDelegate?.tabBar(self, didHijack: item)
            }
        }
    }
    
    @objc internal func select(itemAtIndex idx: Int, animated: Bool) {
        if let item = self.items?[idx] as? TabBarItem, let curItem = self.items?[curIndex ?? 0] as? TabBarItem {
            curItem.contentView?.deselect(animated:true, completion: nil)
            item.contentView?.select(animated:true, completion: nil)
            curIndex = idx
        }
    }
    
    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        self.reload()
    }

}


internal extension TabBar /* Layout */ {
    func updateLayout() {
        guard let tabBarItems = self.items else {
            return
        }
        
        let tabBarButtons = subviews.filter { subview -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subview.isKind(of: cls)
            }
            return false
            } .sorted { (subview1, subview2) -> Bool in
                return subview1.frame.origin.x < subview2.frame.origin.x
        }
        
        if isCustomizing {
            for (idx, _) in tabBarItems.enumerated() {
                tabBarButtons[idx].isHidden = false
            }
        } else {
            for (idx, item) in tabBarItems.enumerated() {
                if let _ = item as? TabBarItem {
                    tabBarButtons[idx].isHidden = true
                } else {
                    tabBarButtons[idx].isHidden = false
                }
            }
        }
        
    }
}
