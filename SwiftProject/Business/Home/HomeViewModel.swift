//
//  HomeViewModel.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/15.
//

import UIKit
import SwiftyJSON

class HomeViewModel: ListViewModel<BaseCellModel<Any>> {
    var columnList: [Column]?
    var bannerList: [Article]?
    var articleList: [Article]?
    var recommendList: [Recommend]?
    
    var title: String
    init(title: String? = "") {
        self.title = title ?? ""
    }
}

extension HomeViewModel {
    func transform(parentId: Int, completion:@escaping CompletionHandler) {
        NetWorkRequest(API.getColumns(parentId: parentId)) { responseModel in
            guard let jsonData = responseModel.data as? JSON else {
                completion(false, ResponseModel(networkState: NetworkState.error()))
                return
            }
            
            do {
                let columns = jsonData["columns"]
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = Column.keyDecodingStrategy()
                let columnList = try decoder.decode([Column].self, from: columns.rawData())
                let articleList = try decoder.decode([Article].self, from: columns.rawData())
                let cellModels = articleList.map { NewsTextCellModel($0) }
                self.list?.append(contentsOf: cellModels)
                
                completion(true, nil)
            } catch {
                completion(false, ResponseModel(networkState: NetworkState.error()))
            }
        } failureCallback: { responseModel in
            completion(false, responseModel)
        }
    }
}

struct Article: Codable {
    var title: String?
    var name: String?
    var content: String?
    var actualStartAt: Int? = 0
    var categoryId: Int? = 0
    var chatId: Int? = 0
    var coverLarge: String?
    var coverMiddle: String?
    var coverSmall: String?
}


struct Recommend {
    var title: String?
    var content: String?
    var actualStartAt: Int = 0
    var categoryId: Int = 0
    var chatId: Int = 0
    var coverLarge: String?
    var coverMiddle: String?
    var coverSmall: String?
}


