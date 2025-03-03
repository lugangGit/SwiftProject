//
//  AppFont.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/7.
//

import UIKit

let kFontNameFZZHUNYSK = "FZZHUNYSK--GBK1-0-YS"

/// 字体风格
enum FontStyle {
    case normal
    case italic
}

class AppTextStyle {
    
    /// 字体颜色（默认黑色）
    var textColor: UIColor
    /// 字体大小（默认 14）
    var fontSize: CGFloat
    /// 字体粗细（默认 regular）
    var fontWeight: UIFont.Weight
    /// 字体家族
    var fontFamily: String?
    /// 字体风格
    var fontStyle: FontStyle?
    /// 字符间距
    var letterSpacing: CGFloat?
    /// 行间距
    var lineSpacing: CGFloat?

    /// 计算 `UIFont`
    var font: UIFont {
        if let fontFamily = fontFamily, let customFont = UIFont(name: fontFamily, size: fontSize) {
            return customFont
        } else {
            return UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        }
    }

    /// **初始化**
    init(
        textColor: UIColor = AppColor.text1,
        fontSize: CGFloat = 14,
        fontWeight: UIFont.Weight = .regular,
        fontFamily: String? = nil,
        fontStyle: FontStyle? = nil,
        letterSpacing: CGFloat? = nil,
        lineSpacing: CGFloat? = nil
    ) {
        self.textColor = textColor
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.fontFamily = fontFamily
        self.fontStyle = fontStyle
        self.letterSpacing = letterSpacing
        self.lineSpacing = lineSpacing
    }
    
    /// 从 JSON 转换成 `AppTextStyle`
    static func from(json: Any?) -> AppTextStyle {
        guard let jsonDict = json as? [String: Any] else {
            if let jsonKey = json as? String {
                return textStyles[jsonKey] ?? subtitle1
            }
            return subtitle1
        }

        return AppTextStyle(
            textColor: AppColor.fromJson(json: jsonDict["color"] ?? "text1"),
            fontSize: (jsonDict["fontSize"] as? NSNumber)?.doubleValue ?? 14,
            fontWeight: (jsonDict["fontWeight"] as? String)?.toFontWeight() ?? .regular,
            fontFamily: jsonDict["fontFamily"] as? String,
            fontStyle: (jsonDict["fontStyle"] as? String)?.toFontStyle(),
            letterSpacing: CGFloat((jsonDict["letterSpacing"] as? NSNumber)?.doubleValue ?? 0),
            lineSpacing: CGFloat((jsonDict["lineSpacing"] as? NSNumber)?.doubleValue ?? 0)
        )
    }

    /// 初始化 JSON 配置
    static func initJson(json: [String: Any]) {
        headline1 = AppTextStyle.from(json: json["headline1"])
    }
    
    /// 一级标题
    static var headline1 = AppTextStyle.from(json: defaultConfig["headline1"]!)
    
    /// 副标题1
    static var subtitle1 = AppTextStyle.from(json: defaultConfig["subtitle1"]!)
    
    /// 内容标题1
    static var bodyText1 = AppTextStyle.from(json: defaultConfig["bodyText1"]!)
    
    /// 描述
    static var caption = AppTextStyle.from(json: defaultConfig["caption"]!)
    
    /// 线
    static var overline = AppTextStyle.from(json: defaultConfig["overline"]!)
    
    /// 字体8
    static var title8 = AppTextStyle.from(json: defaultConfig["title8"]!)
    
    /// 字体9
    static var title9 = AppTextStyle.from(json: defaultConfig["title9"]!)
    
    /// 字体10
    static var title10 = AppTextStyle.from(json: defaultConfig["title10"]!)
    
    /// 字体11
    static var title11 = AppTextStyle.from(json: defaultConfig["title11"]!)
    
    /// 字体12
    static var title12 = AppTextStyle.from(json: defaultConfig["title12"]!)
    
    /// 字体13
    static var title13 = AppTextStyle.from(json: defaultConfig["title13"]!)
    
    /// 字体14
    static var title14 = AppTextStyle.from(json: defaultConfig["title14"]!)
    
    /// 字体15
    static var title15 = AppTextStyle.from(json: defaultConfig["title15"]!)
    
    /// 字体20
    static var title20 = AppTextStyle.from(json: defaultConfig["title20"]!)
    
    /// 字体23
    static var title23 = AppTextStyle.from(json: defaultConfig["title23"]!)
    
    /// 默认配置
    static let defaultConfig: [String: [String: Any]] = [
        "headline1": [
            "color": "text1",
            "fontSize": 22.5,
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "subtitle1": [
            "color": "text1",
            "fontSize": 17,
            "lineSpacing": 5.0,
            "fontWeight": "regular",
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "bodyText1": [
            "color": "text1",
            "fontSize": 15,
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "caption": [
            "color": "text4",
            "fontSize": 12,
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "overline": [
            "color": "text1",
            "fontSize": 10,
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "title8": [
            "fontSize": 8,
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "title9": [
            "fontSize": 9,
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "title10": [
            "fontSize": 10,
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "title12": [
            "color": "text4",
            "fontSize": 12,
            "lineSpacing": 5.0,
            "fontWeight": "regular",
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "title15": [
            "color": "text4",
            "fontSize": 15,
            "lineSpacing": 5.0,
            "fontWeight": "regular",
            "fontFamily": kFontNameFZZHUNYSK
        ],
        "title20": [
            "fontSize": 20,
            "fontFamily": kFontNameFZZHUNYSK,
            "fontWeight": "bold"
        ],
        "title23": [
            "color": "text1",
            "fontSize": 23,
            "lineSpacing": 5.0,
            "fontWeight": "regular",
            "fontFamily": kFontNameFZZHUNYSK
        ]
    ]
    
    static let textStyles = [
        "headline1":headline1,
        "subtitle1":subtitle1,
        "bodyText1":bodyText1,
        "caption":caption,
        "overline":overline,
        "title8":title8,
        "title9":title9,
        "title10":title10,
        "title11":title11,
        "title12":title12,
        "title13":title13,
        "title14":title14,
        "title15":title15,
        "title20":title20,
        "title23":title23
    ]
}
