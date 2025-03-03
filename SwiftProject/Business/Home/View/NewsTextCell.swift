//
//  NewsTextCell.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/12.
//

import UIKit

class NewsTextCell: BaseTableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "标题"
        label.font = AppTextStyle.bodyText1.font
        label.textColor = AppTextStyle.bodyText1.textColor
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func makeUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(kGlobalMarinLeft)
            make.right.equalTo(-kGlobalMarinRight)
            make.top.equalTo(10)
        }
        
        makeLine()
    }
    
    override func bind(to viewModel: BaseCellModel<Any>) {
        super.bind(to: viewModel)
        guard let cellModel = viewModel as? NewsTextCellModel else { return }
        guard let article = cellModel.data as? Article else { return }
        titleLabel.text = article.name ?? article.title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
