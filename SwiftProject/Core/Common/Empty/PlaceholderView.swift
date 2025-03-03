//
//  PlaceholderView.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/15.
//

import UIKit
import Kingfisher

enum NetworkState: Equatable {
    case loading(image: UIImage? = nil, message: String? = "正在加载...")
    case empty(message: String? = "暂无数据")
    case error(message: String? = "数据出错")
    case networkError(message: String? = "服务异常", error: NSError? = nil)
    case noNetwork(message: String? = "网络开小差！")
    case custom(image: UIImage?, message: String?, retry: String?)
}

class PlaceholderView: UIView {
    var retryAction: (() -> Void)?

    open var message: String? {
        didSet { self.messageLabel.text = message }
    }
    
    func setState(_ state: NetworkState) {
        func updateViewVisibility(imageHidden: Bool, messageHidden: Bool, retryHidden: Bool) {
            imageView.isHidden = imageHidden
            messageLabel.isHidden = messageHidden
            retryButton.isHidden = retryHidden
        }
        
        switch state {
        case .loading(let image, let message):
            if image == nil {
                if let gifUrl = Bundle.main.url(forResource: "digital_human_big_img", withExtension: "gif") {
                    imageView.kf.setImage(with: gifUrl)
                }
            }else {
                imageView.image = image
            }
            updateViewVisibility(imageHidden: false, messageHidden: false, retryHidden: true)
            messageLabel.text = message
        case .empty(let message):
            updateViewVisibility(imageHidden: false, messageHidden: false, retryHidden: false)
            messageLabel.text = message
            imageView.image = UIImage(named: ImageName.refresh_kiss)
        case .error(let message):
            updateViewVisibility(imageHidden: false, messageHidden: false, retryHidden: false)
            messageLabel.text = message
            imageView.image = UIImage(named: ImageName.refresh_kiss)
        case .networkError(let message, let error):
            updateViewVisibility(imageHidden: false, messageHidden: false, retryHidden: false)
            messageLabel.text = message
            imageView.image = UIImage(named: ImageName.refresh_kiss)
        case .noNetwork(let message):
            updateViewVisibility(imageHidden: false, messageHidden: false, retryHidden: false)
            messageLabel.text = message
            imageView.image = UIImage(named: ImageName.refresh_kiss)
        case .custom(image: let image, message: let message, retry: let retry):
            updateViewVisibility(imageHidden: (image == nil), messageHidden: (message == nil), retryHidden: (retry == nil))
            imageView.image = image
            messageLabel.text = message
            retryButton.setTitle(retry, for: .normal)
        }
    }
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.text2
        label.textAlignment = .center
        label.text = "正在加载..."
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: ImageName.refresh_kiss)
        return imageView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = AppColor.primary50
        button.setTitle("点击重试", for: .normal)
        button.addTarget(self, action: #selector(clickRetryButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.primary8
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    @objc private func clickRetryButton() {
        retryAction?()
    }
    
    private func setupView() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY).offset(-120 * kScale)
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 250, height: 16))
        }
        
        self.addSubview(retryButton)
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(25)
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 120, height: 30))
        }
        
    }
}
