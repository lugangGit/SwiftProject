//
//  TableViewManager.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/15.
//

import UIKit

class TableViewManager<T>: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    var data: [[T]] = []
    var cellConfigurator: ((UITableViewCell, IndexPath, T) -> Void)?
    var didSelectItem: ((IndexPath, T) -> Void)?

    // MARK: - Initializer
    init(data: [[T]] = [],
         cellConfigurator: ((UITableViewCell, IndexPath, T) -> Void)? = nil,
         didSelectItem: ((IndexPath, T) -> Void)? = nil) {
        self.data = data
        self.cellConfigurator = cellConfigurator
        self.didSelectItem = didSelectItem
    }

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        let item = data[indexPath.section][indexPath.row]
        cellConfigurator?(cell, indexPath, item)
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.section][indexPath.row]
        didSelectItem?(indexPath, item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
