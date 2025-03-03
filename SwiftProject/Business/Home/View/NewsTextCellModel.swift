//
//  NewsCellModel.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/11.
//

import UIKit

class NewsTextCellModel: BaseCellModel<Any> {
    /// 底部工具栏frame
    var bottomToolsFrame: CGRect = .zero
    
    override func preHandle(data: Any) {
        guard let article = data as? Article else {
            return
        }
        super.preHandle(data: article)
        cellHeight = 44 + 15
        bottomToolsFrame = CGRectMake(kGlobalMarinLeft, cellHeight-20, kScreenWidth - 2*kGlobalMarinLeft, 15)
    }
}
