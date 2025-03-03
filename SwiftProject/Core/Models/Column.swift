//
//  Column.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/7.
//

import Foundation

struct Column: Codable {
    var topPicPad: String?
    var discussClosed: Int?
    var appTypePad: String?
    var synXCX, showOriginalCol, showCardPad, appShow: Int?
    var name: String?
    var autoLogin, topCount: Int?
    var briefIntroduction: String?
    var showPadTags, appFixed: Int?
    var columnStyle, tipoffSelects: String?
    var showStylePad, playbackStyle, isArchive, childCount: Int?
    var showReadCount: Int?
    var timeAxisIconPad: String?
    var iconBigType: Int?
    var columnClassID: String?
    var hasEXTField, showStyle: Int?
    var cardURL: String?
    var onlyShowPad, showTipoffEntry, isScreen, listDisplayStyle: Int?
    var isIncomPad: Int?
    var topBGColor, columnType: String?
    var displayAsTimeline, catStyle, nameAsIcon, appNormal: Int?
    var tipoffShows, keyword: String?
    var sharedClosed, showPubTime, showCard: Int?
    var accessSettingName, accessSetting, topPic, topBGPic: String?
    var orderID, firstShow, isdelete, showPubTimePad: Int?
    var colShareClosed, showMoreTipPad: Int?
    var phoneIcon: String?
    var miniProgramsID, columnClass: String?
    var showDiscussCountPad, showDiscussCount, aggID, columnLevel: Int?
    var topCountPad, rssCount: Int?
    var timeAxisColorPad: String?
    var isParentColumn: Bool?
    var permission, columnID: Int?
    var description, casNames: String?
    var bgColor4Carousel: Int?
    var iconPad, wechatPath: String?
    var isForbidden: Bool?
    var id: Int?
    var cardURLPad: String?
    var showColumnPad, greyStyle, showSource: Int?
    var createTime: String?
    var showPraiseCount, showPraiseCountPad: Int?
    var columnName, linkURL: String?
    var level, scanModel: Int?
    var padIcon: String?
    var showReadCountPad, outDisplay: Int?
    
    enum CodingKeys: String, CodingKey {
        case topPicPad, discussClosed, appTypePad, synXCX, showOriginalCol, showCardPad, appShow, name, autoLogin, topCount
        case briefIntroduction
        case showPadTags = "ShowPadTags"
        case appFixed, columnStyle, tipoffSelects, showStylePad, playbackStyle, isArchive, childCount, showReadCount, timeAxisIconPad, iconBigType, columnClassID
        case hasEXTField = "hasExtField"
        case showStyle
        case cardURL = "cardUrl"
        case onlyShowPad, showTipoffEntry, isScreen, listDisplayStyle, isIncomPad, topBGColor, columnType, displayAsTimeline, catStyle, nameAsIcon, appNormal, tipoffShows, keyword, sharedClosed, showPubTime, showCard, accessSettingName, accessSetting, topPic, topBGPic
        case orderID = "orderId"
        case firstShow, isdelete, showPubTimePad, colShareClosed, showMoreTipPad, phoneIcon, miniProgramsID, columnClass, showDiscussCountPad, showDiscussCount
        case aggID = "aggId"
        case columnLevel, topCountPad, rssCount, timeAxisColorPad, isParentColumn, permission, columnID, description, casNames, bgColor4Carousel, iconPad, wechatPath, isForbidden, id
        case cardURLPad = "cardUrlPad"
        case showColumnPad, greyStyle, showSource, createTime, showPraiseCount, showPraiseCountPad, columnName
        case linkURL = "linkUrl"
        case level, scanModel, padIcon, showReadCountPad, outDisplay
    }
    
    static func keyDecodingStrategy() -> JSONDecoder.KeyDecodingStrategy {
          return .custom { codingKeys in
              let key = codingKeys.last!.stringValue
              switch key {
              case "columnID", "columnId", "id":
                  return CodingKeys.id
              default:
                  return CodingKeys(stringValue: key) ?? codingKeys.last!
              }
          }
      }
    
}

extension Column {
    var columnname: String? {
        return columnName
    }
}
