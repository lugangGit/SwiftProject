//
//  BaseTableViewCell.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/11.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    /// 代理
    var indexPath: IndexPath?
    /// 基类代理
    weak var baseDelegate: BaseCellDelegate?
    /// 分割线
    lazy var lineView : UIView = {
        let line = UIView()
        line.backgroundColor = AppColor.divider
        contentView.addSubview(line)
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = AppColor.background
        contentView.backgroundColor = AppColor.background
        clipsToBounds = true
        contentView.clipsToBounds = true
        makeUI()
        handleEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeLine(leftMargin: CGFloat = 15, rightMargin: CGFloat = 15) {
        lineView.snp.remakeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
            make.left.equalTo(leftMargin)
            make.right.equalTo(-rightMargin)
        })
    }
    
    func makeSectionLine(lineHeight: CGFloat = 8) {
        lineView.snp.remakeConstraints ({ (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(lineHeight)
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeUI() { }
    
    func handleEvent() { }
    
    func bind(to viewModel: BaseCellModel<Any>) { }
    
}
