import UIKit
import JXSegmentedView
import MJRefresh

// MARK: - Properties
 let headerImageHeight: CGFloat = 250
 let segmentHeight: CGFloat = 50

class MineViewController: BaseViewController {
    
    private let defaultCellIdentifier = "DefaultCell"
    
    // 添加控制变量
    private var isMainTableViewCanScroll: Bool = true
    private var isListCanScroll: Bool = false
    public private(set) var currentScrollingListView: UIScrollView?

    
    lazy var containerView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: kScreenHeight - segmentHeight - kBottomHeight))
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let listContainerView = JXSegmentedListContainerView(dataSource: self)
        listContainerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: kScreenHeight - headerImageHeight - kBottomHeight - kBottomHeight)
        return listContainerView
    }()
    
    
    lazy var dataSource: JXSegmentedTitleDataSource = {
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.titles = []
        dataSource.titleNormalColor = AppColor.text1
        dataSource.titleSelectedColor = AppColor.text1
        dataSource.titles = ["猴哥", "青蛙王子", "旺财"]
        dataSource.titleNormalFont = AppTextStyle.title20.font
        dataSource.titleSelectedFont = AppTextStyle.title20.font
        dataSource.isTitleColorGradientEnabled = true
        dataSource.isItemSpacingAverageEnabled = true
        dataSource.itemSpacing = 20
        dataSource.titleSelectedZoomScale = 1.0
        dataSource.isTitleZoomEnabled = true
        dataSource.isSelectedAnimable = true
        return dataSource
    }()
    
    // 创建分段视图
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = AppColor.background
        segmentedView.delegate = self
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 20
        segmentedView.indicators = [indicator]
        
        return segmentedView
    }()
    
    lazy var mineViewModel: BaseViewModel = {
        if viewModel != nil {
            return viewModel!
        } else {
            return BaseViewModel()
        }
    }()
    
    private lazy var tableView: JXPagingMainTableView = {
        let tableView = JXPagingMainTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollsToTop = false
        tableView.uHead = URefreshHeader{ [weak self] in
            self?.refreshData()
        }
        tableView.retryAction = { [weak self] in
            self?.retryAction()
        }
//        tableView.showPlaceholder(true)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCellIdentifier)
        return tableView
    }()
    
    private func refreshData() {
        tableView.uHead.endRefreshing()
    }
    
    private func retryAction() {
        refreshData()
    }
    
    private lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: headerImageHeight))
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: headerImageHeight))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: ImageName.launch_logo)
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar?.isHidden = true
        loadInitialData()
    }
    
    override func makeUI() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // 对于 iOS 11 之前的版本，这行代码不会有作用
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.backgroundColor = AppColor.canvas
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(-kBottomHeight)
            make.top.left.right.equalTo(0)
        }
        // 设置 headerView
        headerView.addSubview(headerImageView)
        tableView.tableHeaderView = headerView
        
//        containerView.addSubview(segmentedView)
//        containerView.addSubview(listContainerView)

        // 联动
        segmentedView.listContainer = listContainerView
        segmentedView.dataSource = dataSource
        // 设置默认index
        segmentedView.defaultSelectedIndex = 0
        
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        panGesture.delegate = self
//        tableView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    }
   
    private func loadInitialData() {
        tableView.reloadData()
    }
    
    @objc private func pullToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadInitialData()
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight - segmentHeight - kBottomHeight
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return segmentHeight
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentedView
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect.zero)
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.red
        if listContainerView.superview != cell.contentView {
            cell.contentView.addSubview(listContainerView)
        }
        if listContainerView.frame != cell.bounds {
            listContainerView.frame = cell.bounds
        }
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension MineViewController: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            tableView.reloadData()
        }
    }
    
    // 修改 scrollViewDidScroll 方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        preferredProcessMainTableViewDidScroll(scrollView)
    }
    
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
//    }
    
    /// 外部传入的listView，当其内部的scrollView滚动时，需要调用该方法
    func listViewDidScroll(scrollView: UIScrollView) {
        currentScrollingListView = scrollView
        preferredProcessListViewDidScroll(scrollView: scrollView)
    }
    
    func mainTableViewMaxContentOffsetY() -> CGFloat {
        return CGFloat(headerImageHeight)
    }
    
    func minContentOffsetYInListScrollView(_ scrollView: UIScrollView) -> CGFloat {
        if #available(iOS 11.0, *) {
            return -scrollView.adjustedContentInset.top
        }
        return -scrollView.contentInset.top
    }
    
    func setListScrollViewToMinContentOffsetY(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: minContentOffsetYInListScrollView(scrollView))
    }
    
    func setMainTableViewToMaxContentOffsetY() {
        tableView.contentOffset = CGPoint(x: 0, y: mainTableViewMaxContentOffsetY())
    }
    
    open func preferredProcessListViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if (tableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            //mainTableView的header还没有消失，让listScrollView一直为0
            setListScrollViewToMinContentOffsetY(scrollView)
        } else {
            //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
            setMainTableViewToMaxContentOffsetY()
        }
    }
    
    open func preferredProcessMainTableViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentScrollingListView = currentScrollingListView else { return }
        if (currentScrollingListView.contentOffset.y > minContentOffsetYInListScrollView(currentScrollingListView)) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            setMainTableViewToMaxContentOffsetY()
        }

        if (tableView.contentOffset.y < mainTableViewMaxContentOffsetY()) {
            setListScrollViewToMinContentOffsetY(UIScrollView())
        }

        if scrollView.contentOffset.y > mainTableViewMaxContentOffsetY() && currentScrollingListView.contentOffset.y == minContentOffsetYInListScrollView(currentScrollingListView) {
            //当往上滚动mainTableView的headerView时，滚动到底时，修复listView往上小幅度滚动
            setMainTableViewToMaxContentOffsetY()
        }
    }
}


extension MineViewController: JXSegmentedViewDelegate, JXSegmentedListContainerViewDataSource {
    //点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，而不关心具体是点击还是滚动选中的情况。
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {}
    // 点击选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {}
    // 滚动选中的情况才会调用该方法
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {}
    // 正在滚动中的回调
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {}
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 3
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = ListViewController()
        vc.view.backgroundColor = [.red, .green, .blue][index]
        vc.listViewDidScrollCallback = { [weak self] scrollView in
            guard let self = self else { return }
            
            self.listViewDidScroll(scrollView: scrollView)
        }
        return vc
    }
}

extension MineViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //禁止segmentedView左右滑动的时候，上下和左右都可以滚动
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}



