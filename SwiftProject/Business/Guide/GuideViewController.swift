//
//  GuideViewController.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/27.
//

import UIKit


class GuideViewController: UIViewController, UIScrollViewDelegate {
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let button = UIButton()
    private let images = ["image1", "image2", "image3"] // 替换为你的图片名称
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupScrollView()
        setupPageControl()
        setupButton()
    }
    
    // MARK: - 设置滚动视图
    private func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: view.bounds.height)
        view.addSubview(scrollView)
        
        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.backgroundColor = kColorRandom()
            imageView.contentMode = .scaleAspectFill
            imageView.frame = CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width, height: view.bounds.height)
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
        }
    }
    
    // MARK: - 设置分页指示器
    private func setupPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - 设置按钮
    private func setupButton() {
        button.setTitle("进入首页", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(enterHome), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(round(scrollView.contentOffset.x / view.bounds.width))
        pageControl.currentPage = page
        
        // 最后一页显示按钮
        button.isHidden = page != images.count - 1
    }
    
    // MARK: - 按钮事件
    @objc private func enterHome() {
        AppConfig.shared.guideStatus = true
        Application.shared.presentScreen(in: kKeyWindow)
    }
}



