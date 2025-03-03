//
//  BaseViewModel.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/24.
//

import UIKit

class BaseViewModel: NSObject {
    /// 分页
    var page = 0
    /// 数量
    var pageSize = 20
}


class ViewModel<T>: BaseViewModel {
    var model: T?
}


class ListViewModel<T>: ViewModel<T> {
    var list: [T]? = []
    
    public func refresh() {
        page = 0
        list?.removeAll()
    }
    
    public func loadMore() {
        page += 1
    }
}

