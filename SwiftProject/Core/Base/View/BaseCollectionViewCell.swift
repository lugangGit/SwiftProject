//
//  BaseCollectionViewCell.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/11.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    /// 代理
    var indexPath: IndexPath?
    /// 基类代理
    weak var baseDelegate: BaseCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.background
        contentView.backgroundColor = AppColor.background
        clipsToBounds = true
        contentView.clipsToBounds = true
        makeUI()
        handleEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() { }
    
    func handleEvent() { }
    
}
