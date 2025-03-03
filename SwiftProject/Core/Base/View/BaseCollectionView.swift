//
//  BaseCollectionView.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/15.
//


import UIKit

class BaseCollectionView: UICollectionView {

    // MARK: - Properties
    private var emptyView: UIView?
    private var errorView: UIView?
    var onScrollToBottom: (() -> Void)? // 滚动到底部的回调

    // MARK: - Initializer
    init(frame: CGRect, layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
    }

    // MARK: - Setup
    private func setupCollectionView() {
        self.backgroundColor = AppColor.background
        self.alwaysBounceVertical = true
        self.delegate = self
    }

    // MARK: - Empty View
    func setEmptyView(_ view: UIView) {
        self.emptyView = view
    }

    func showEmptyView(_ show: Bool) {
        if show {
            guard let emptyView = emptyView else { return }
            emptyView.frame = self.bounds
            self.addSubview(emptyView)
        } else {
            emptyView?.removeFromSuperview()
        }
    }

    // MARK: - Error View
    func setErrorView(_ view: UIView) {
        self.errorView = view
    }

    func showErrorView(_ show: Bool) {
        if show {
            guard let errorView = errorView else { return }
            errorView.frame = self.bounds
            self.addSubview(errorView)
        } else {
            errorView?.removeFromSuperview()
        }
    }
}

extension BaseCollectionView: UICollectionViewDelegate {
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
