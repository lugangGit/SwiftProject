//
//  HomeViewController.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/31.
//

import UIKit
import SVProgressHUD

class HomeViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let defaultCellIdentifier = "DefaultCell"
    
    private lazy var tableView: BaseTableView = {
        let tableView = BaseTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.uHead = URefreshHeader{ [weak self] in
            self?.refreshData()
        }
        tableView.uFoot = URefreshFooter { [weak self] in
            self?.loadMoreData()
        }
        tableView.retryAction = { [weak self] in
            self?.retryAction()
        }
        tableView.showPlaceholder(true)
        tableView.register(NewsTextCell.self, forCellReuseIdentifier: defaultCellIdentifier)
        return tableView
    }()
    
    lazy var homeViewModel: HomeViewModel = {
        if viewModel != nil {
            return viewModel as! HomeViewModel
        } else {
            return HomeViewModel()
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar?.title = "home".localized
    }
    
    private func refreshData() {
        homeViewModel.refresh()
        bindViewModel()
    }
    
    private func loadMoreData() {
        homeViewModel.loadMore()
        bindViewModel()
    }
    
    private func retryAction() {
        refreshData()
        tableView.showPlaceholder(true)
    }

    override func makeUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(kTopHeight)
            make.left.right.bottom.equalTo(0)
        }
    }
    
    override func handleLanguageChange() {
        navigationBar?.title = "home".localized
    }
    
    override func bindViewModel() {
        homeViewModel.transform(parentId: 0) { [weak self] success, responseModel in
            guard let self = self else { return }
            if (success) {
                tableView.uHead.endRefreshing()
//                self.tableView.uFoot.endRefreshing()
                tableView.uFoot.endRefreshingWithNoMoreData()
                
                tableView.showPlaceholder(false)
                tableView.reloadData()
            }else {
                tableView.showPlaceholder(true, state: responseModel?.networkState)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeViewModel.list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath) as! NewsTextCell
        cell.bind(to: self.homeViewModel.list![indexPath.row])
//        cell.textLabel?.text = "标题\(indexPath.row)" + "home".localized
//        cell.textLabel?.font = AppTextStyle.headline1.font
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.homeViewModel.list![indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ToastManager.show(type: ToastType.text(message: "标题\(indexPath.row)"))
    }
}

