//
//  MenuCell.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/13.
//

import UIKit

class MenuCell: UICollectionViewCell {
    static let reuseIdentifier = "MenuCell"
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["作品", "收藏"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            segmentedControl.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
