//
//  BaseTableView.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/15.
//

import UIKit

class BaseTableView: UITableView {
    var retryAction: VoidClosure?

    // MARK: - Properties
    private var placeholderView: UIView?
    
    var onScrollToBottom: (() -> Void)? // 滚动到底部的回调
    
    // MARK: - Initializers
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        self.backgroundColor = AppColor.background
//        self.showsVerticalScrollIndicator = false
//        self.showsHorizontalScrollIndicator = false
//        self.separatorStyle = .singleLine
//        self.rowHeight = UITableView.automaticDimension
//        self.estimatedRowHeight = 44.0
//        self.delegate = self
//        if #available(iOS 11.0, *) {
//            self.contentInsetAdjustmentBehavior = .never
//        }
//        #if compiler(>=5.5)
//        if #available(iOS 15.0, *) {
//            self.sectionHeaderTopPadding = 0
//        }
//        #endif
    }
    
    // MARK: - Empty View
    func setPlaceholder(_ view: UIView) {
        self.placeholderView = view
    }
    
    func showPlaceholder(_ show: Bool, state: NetworkState? = NetworkState.loading()) {
        if show {
//            guard let emptyView = emptyView else { return }
//            emptyView.frame = self.bounds
            if placeholderView == nil {
                placeholderView = PlaceholderView(frame: self.bounds)
                self.addSubview(placeholderView!)
                placeholderView?.snp.makeConstraints { make in
                    make.top.left.equalTo(0)
                    make.height.equalToSuperview()
                    make.width.equalToSuperview()
                }
            }
            guard let placeholder = placeholderView as? PlaceholderView else { return }
            placeholder.retryAction = { [weak self] in
                self?.retryAction?()
            }
            placeholder.setState(state ?? .loading(message: "正在加载..."))
        } else {
            placeholderView?.removeFromSuperview()
            placeholderView = nil
        }
    }
}

extension BaseTableView: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 检测滚动到底部
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            onScrollToBottom?()
        }
    }
}
