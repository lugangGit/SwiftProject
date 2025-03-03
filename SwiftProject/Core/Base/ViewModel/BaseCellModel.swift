//
//  BaseCellModel.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/11.
//

import UIKit

class BaseCellModel<T> {
    /// data
    var data: T
    /// cell高度 缓存 默认44
    public var cellHeight: CGFloat = 44
    /// cell 大小 针对CollectionView
    public var cellSize: CGSize = .zero
    /// cell 绑定cell
    var cellClassName: String {
        get {
            String(describing: Self.self)
        }
    }
    // MARK: - 初始化
    /// 初始化
    init(_ data: T) {
        self.data = data
        
        self.mockData(data: data)
        self.preHandle(data: data)
    }
    // MARK: - 测试数据
    /// 测试数据
    func mockData(data: T) {
        
    }
    // MARK: - 预处理数据
    /// 预处理数据
    func preHandle(data: T) {
        
    }
}

