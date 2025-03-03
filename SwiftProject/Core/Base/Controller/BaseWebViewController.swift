//
//  WebViewController.swift
//  SwiftProject
//
//  Created by 梓源 on 2024/12/31.
//

import UIKit
import WebKit

class BaseWebViewController: BaseViewController {
    
    lazy var baseWebViewModel: BaseWebViewModel = {
        if viewModel != nil {
            return viewModel as! BaseWebViewModel
        } else {
            return BaseWebViewModel()
        }
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self;
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackImage = UIImage.init(named: "nav_bg")
        progressView.progressTintColor = UIColor.white
        return progressView
    }()
    
//    // 构造器
//    convenience init(url: String?) {
//        self.init()
//        self.request = URLRequest(url: URL(string: url ?? "")!)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(baseWebViewModel.request!)
    }
    
    override func makeUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
    
    @objc func reload() {
        webView.reload()
    }
    
//    override func pressBack() {
//        if webView.canGoBack {
//            webView.goBack()
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
//    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension BaseWebViewController: WKNavigationDelegate, WKUIDelegate {
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if (keyPath == "estimatedProgress") {
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
}
