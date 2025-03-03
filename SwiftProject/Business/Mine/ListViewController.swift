//
//  ListViewController.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/20.
//

import UIKit
import JXSegmentedView
import MJRefresh

class ListViewController: BaseViewController, JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
    
    private var tableView: UITableView!
    private var dataSource: [String] = []
    private var currentPage = 1
    private let pageSize = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialData()
    }
    
    private func setupUI() {
        // 设置tableView
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: kScreenHeight - kBottomHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        // 添加上拉加载
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadMoreData()
        })
    }
    
    private func loadInitialData() {
        // 模拟初始数据加载
        currentPage = 1
        dataSource = (1...pageSize).map { "第\($0)条数据" }
        tableView.reloadData()
    }
    
    private func loadMoreData() {
        // 模拟网络请求延迟
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            // 模拟加载更多数据
            let startIndex = self.dataSource.count + 1
            let endIndex = startIndex + self.pageSize - 1
            let newData = (startIndex...endIndex).map { "第\($0)条数据" }
            
            self.dataSource.append(contentsOf: newData)
            self.currentPage += 1
            
            self.tableView.reloadData()
            self.tableView.mj_footer?.endRefreshing()
            
            // 如果数据超过100条，模拟没有更多数据的情况
            if self.dataSource.count >= 100 {
                self.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource, JXPagingViewListViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    //加上footer之后，下滑滚动就变得丝般顺滑了
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect.zero)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        listViewDidScrollCallback?(scrollView)
    }
    
    // 实现必要的代理方法
    func listScrollView() -> UIScrollView {
        return tableView
    }
    
}


public protocol JXPagingViewListViewDelegate: NSObjectProtocol {
    /// 如果列表是VC，就返回VC.view
    /// 如果列表是View，就返回View自己
    ///
    /// - Returns: 返回列表视图
    func listView() -> UIView
    /// 返回listView内部持有的UIScrollView或UITableView或UICollectionView
    /// 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView
    ///
    /// - Returns: listView内部持有的UIScrollView或UITableView或UICollectionView
    func listScrollView() -> UIScrollView
    /// 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
    ///
    /// - Parameter callback: `scrollViewDidScroll`回调时调用的callback
    func listViewDidScrollCallback(callback: @escaping (UIScrollView)->())
}

private var ListControllerViewDidScrollKey: Void?
extension JXPagingViewListViewDelegate where Self: UIViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> ())? {
        get { objc_getAssociatedObject(self, &ListControllerViewDidScrollKey) as? (UIScrollView) -> () }
        set { objc_setAssociatedObject(self, &ListControllerViewDidScrollKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

extension JXPagingViewListViewDelegate where Self: UIViewController {
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        listViewDidScrollCallback = callback
    }

    func listView() -> UIView { view }
}

