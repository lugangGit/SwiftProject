//
//  TabBarItem.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/3.
//

import UIKit

class TabBarItem: UITabBarItem {
    open var contentView: TabBarItemContentView?
    
    // MARK: UIBarItem properties
    open override var title: String? // default is nil
        {
        didSet { self.contentView?.title = title }
    }
    
    open override var image: UIImage? // default is nil
        {
        didSet { self.contentView?.image = image }
    }
    
    // MARK: UITabBarItem properties
    open override var selectedImage: UIImage? // default is nil
        {
        didSet { self.contentView?.selectedImage = selectedImage }
    }
    
    public init(_ contentView: TabBarItemContentView = TabBarItemContentView(), title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, tag: Int = 0) {
        super.init()
        self.contentView = contentView
        self.setTitle(title, image: image, selectedImage: selectedImage, tag: tag)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setTitle(_ title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, tag: Int = 0) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.tag = tag
    }
    
}
