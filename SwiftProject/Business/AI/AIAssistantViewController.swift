//
//  AIAssistantViewController.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/14.
//

import UIKit
import SnapKit

class AIAssistantViewController: UIViewController {
    
    private enum Constants {
        static let inputViewHeight: CGFloat = 50
        static let inputViewBottomPadding: CGFloat = 10
        static let sendButtonWidth: CGFloat = 60
        static let inputTextViewInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        return tableView
    }()
    
    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 18
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.textContainerInset = Constants.inputTextViewInsets
        return textView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("发送", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var thinkingIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var messages: [(isUser: Bool, text: String)] = []
    private var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "AI助理"
        
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(inputTextView)
        inputContainerView.addSubview(sendButton)
        view.addSubview(thinkingIndicatorView)
        
        inputContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.inputViewHeight + Constants.inputViewBottomPadding)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputContainerView.snp.top)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-Constants.inputViewBottomPadding)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.equalTo(inputTextView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(inputTextView)
            make.width.equalTo(Constants.sendButtonWidth)
        }
        
        thinkingIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(inputContainerView.snp.top).offset(-20)
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillShow),
                                             name: UIResponder.keyboardWillShowNotification,
                                             object: nil)
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(keyboardWillHide),
                                             name: UIResponder.keyboardWillHideNotification,
                                             object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            self.keyboardHeight = keyboardHeight
            
            UIView.animate(withDuration: 0.3) {
                self.inputContainerView.transform = CGAffineTransform(rotationAngle: -keyboardHeight)
                self.tableView.contentInset.bottom = keyboardHeight
                self.tableView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.transform = .identity
            self.tableView.contentInset.bottom = 0
            self.tableView.verticalScrollIndicatorInsets.bottom = 0
        }
        self.keyboardHeight = 0
    }
    
    @objc private func sendButtonTapped() {
        guard let text = inputTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        
        // 添加用户消息
        messages.append((isUser: true, text: text))
        tableView.reloadData()
        scrollToBottom(animated: true)
        
        // 清空输入框
        inputTextView.text = ""
        
        // 显示思考动画
        thinkingIndicatorView.startAnimating()
        
        // 创建AI响应消息
        let aiMessage = (isUser: false, text: "")
        messages.append(aiMessage)
        var currentText = ""
        var count = 0
        
        // 使用Timer每秒添加一段文本
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            count += 1
            currentText += "这是第\(count)秒生成的内容。AI正在思考并生成回复。这是一个模拟的渐进式文本生成过程，展示了AI响应的动态效果。每秒都会增加一些新的内容，让整个过程看起来更加自然和真实。用户可以看到AI正在实时思考和生成内容。"
            
            // 更新最后一条消息的内容
            self.messages[self.messages.count - 1].text = currentText
            self.tableView.reloadData()
            self.scrollToBottom(animated: true)
            
            if count >= 3 {
                timer.invalidate()
                self.thinkingIndicatorView.stopAnimating()
            }
        }
    }
    
    private var isUserScrolling = false
    private var shouldAutoScroll = true
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
        shouldAutoScroll = false
    }
    
    private var lastContentOffset1: CGFloat = 0

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isUserScrolling = false
        
        // 检查是否滚动到接近底部的位置
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        let buffer: CGFloat = 5 // 增加缓冲区域为可视区域的一半
        
        // 检测滚动方向
        let direction = offsetY - lastContentOffset1
        lastContentOffset1 = offsetY
        
        // 向上滑动时停止自动滚动
        if direction < 0 {
            shouldAutoScroll = false
            return
        }
        
        // 向下滑动且接近底部时启用自动滚动
        if direction > 0 && offsetY + scrollViewHeight >= contentHeight - buffer {
            shouldAutoScroll = true
            // 如果接近底部，立即触发一次滚动
            if !messages.isEmpty {
                scrollToBottom(animated: true)
            }
        }
    }
    
    private var lastContentOffset: CGFloat = 0
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 检测滚动方向
        let currentOffset = scrollView.contentOffset.y
        let direction = currentOffset - lastContentOffset
        lastContentOffset = currentOffset
        
        // 计算距离底部的距离
        let offsetFromBottom = scrollView.contentSize.height - (currentOffset + scrollView.frame.height)
        
        // 向上滑动时停止自动滚动
        if direction < 0 {
            shouldAutoScroll = false
        }
        // 当用户滚动到接近底部时启用自动滚动，增加判断条件确保内容完整显示
        else if offsetFromBottom <= 20 && direction > 0 {
            shouldAutoScroll = true
            // 立即触发一次滚动以确保显示最新内容
            if !messages.isEmpty {
                scrollToBottom(animated: true)
            }
        }
    }
    
    private func scrollToBottom(animated: Bool) {
        guard !messages.isEmpty && shouldAutoScroll else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  self.messages.count > 0,
                  let lastSection = self.tableView.numberOfSections > 0 ? self.tableView.numberOfSections - 1 : nil,
                  let lastRow = self.tableView.numberOfRows(inSection: lastSection) > 0 ? self.tableView.numberOfRows(inSection: lastSection) - 1 : nil else {
                return
            }
            
            let lastIndex = IndexPath(row: lastRow, section: lastSection)
            
            self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)

        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension AIAssistantViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        // 配置消息气泡
        let bubbleView = UIView()
        bubbleView.layer.cornerRadius = 16
        bubbleView.backgroundColor = message.isUser ? .systemBlue : .systemGray6
        
        let messageLabel = UILabel()
        messageLabel.text = message.text
        messageLabel.numberOfLines = 0
        messageLabel.textColor = message.isUser ? .white : .label
        messageLabel.font = .systemFont(ofSize: 16)
        
        cell.contentView.addSubview(bubbleView)
        cell.contentView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.lessThanOrEqualTo(cell.contentView.snp.width).multipliedBy(0.75)
            if message.isUser {
                make.trailing.equalToSuperview().offset(-28)
            } else {
                make.leading.equalToSuperview().offset(28)
            }
        }
        
        bubbleView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel).offset(-8)
            make.bottom.equalTo(messageLabel).offset(8)
            make.leading.equalTo(messageLabel).offset(-12)
            make.trailing.equalTo(messageLabel).offset(12)
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        return cell
    }
}
