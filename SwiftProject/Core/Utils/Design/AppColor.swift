//
//  color.swift
//  Xiangyu
//
//  Created by zcb on 2022/1/18.
//

import Foundation
import UIKit

class AppColor {
    static func fromJson(json: Any?) -> UIColor {
        if json is [String: Any] {
            let tmpJson = json as! [String: Any]
            return dynamicColor(lightColor: tmpJson["light"] as! String, darkColor: tmpJson["dark"] as! String)
        } else if json is String {
            return colors[json as! String] ?? dynamicColor(lightColor: "#ffffff", darkColor: "#ffffff")
        } else {
            return dynamicColor(lightColor: "#ffffff", darkColor: "#ffffff")
        }
    }

    static func initJson(json: [String: Any]) {
        primary = AppColor.fromJson(json: json["primary"])
    }
    
    /// 动态颜色
    static func dynamicColor(lightColor: String, darkColor: String) -> UIColor {
        if #available(iOS 13, *) {
            let color = UIColor { traitCollection in
                if ThemeManager.shared.currentThemeType == .normal {
                    return UIColor.hexStringColor(hexString: lightColor)
                } else if ThemeManager.shared.currentThemeType == .dark {
                    return UIColor.hexStringColor(hexString: darkColor)
                } else {
                    if traitCollection.userInterfaceStyle == .dark {
                        return UIColor.hexStringColor(hexString: darkColor)
                    } else {
                        return UIColor.hexStringColor(hexString: lightColor)
                    }
                }
            }
            return color
        } else {
            return UIColor.hexStringColor(hexString: lightColor)
        }
    }
    
    /// 动态颜色
    static func dynamicColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            let color = UIColor { traitCollection in
                if ThemeManager.shared.currentThemeType == .normal {
                    return lightColor
                } else if ThemeManager.shared.currentThemeType == .dark {
                    return darkColor
                } else {
                    if traitCollection.userInterfaceStyle == .dark {
                        return darkColor
                    } else {
                        return lightColor
                    }
                }
            }
            return color
        } else {
            return lightColor
        }
    }
    
    /// 主题色 9,108,245 蓝色 -> 9,108,245 蓝色
    static var primary = dynamicColor(lightColor: "#096CF5", darkColor: "#096CF5")
    static var primary50 = dynamicColor(lightColor: primary.withAlphaComponent(0.5), darkColor: primary.withAlphaComponent(0.5))
    static var primary8 = dynamicColor(lightColor: primary.withAlphaComponent(0.08), darkColor: primary.withAlphaComponent(0.08))
    /// 背景色 ffffff 255,255,255 白色 -> 29,29,30
    static var background = dynamicColor(lightColor: "#ffffff", darkColor: "#1d1d1e")
    static var background50 = dynamicColor(lightColor: "#ffffff", darkColor: "#1d1d1e").withAlphaComponent(0.5)
    /// Material组件的背景色,如文本框背景色 246,246,246 -> 43,43,45
    static var canvas = dynamicColor(lightColor: "#F6F6F6", darkColor: "#2b2b2d")
    /// 边框颜色 221,221,221 -> 44,44,46
    //static var border = dynamicColor(lightColor: "#dddddd", darkColor: "#2c2c2e")
    static var border = dynamicColor(lightColor: UIColor.hexStringColor(hexString: "#dddddd"), darkColor: UIColor.hexStringColor(hexString: "#2c2c2e"))
    /// 分割线 239,239,239 -> 59,59,60
    static var divider = dynamicColor(lightColor: "#efefef", darkColor: "#3b3b3c")
    /// 默认皆是黑色状态 59,59,60->59,59,60
    static var divider_dark = dynamicColor(lightColor: "#3b3b3c", darkColor: "#3b3b3c")
    /// 一级文字颜色：导航栏标题、新闻列表标题、详情页标题和正文 000000 黑 -> ffffff 白
    static var text1 = dynamicColor(lightColor: "#000000", darkColor: "#ffffff")
    /// 二级文字颜色：摘要、部分按钮、详细介绍文字 51,51,51
    static var text2 = dynamicColor(lightColor: "#333333", darkColor: "#ffffff")
    /// 三级文字颜色：摘要、部分按钮、详细介绍文字 102,102,102 -> 136,136,136
    static var text3 = dynamicColor(lightColor: "#666666", darkColor: "#888888")
    /// 四级文字颜色：时间显示、副标题、未点赞文字 153,153,153 - > 170,170,170
    static var text4 = dynamicColor(lightColor: "#999999", darkColor: "#aaaaaa")
    /// 五级文字颜色： 204,204,204 - > 204,204,204
    static var text5 = dynamicColor(lightColor: "#cccccc", darkColor: "#cccccc")
    /// 辅助色：轮播图、标签、组图详情 白色 255,255,255 -> 白色 255,255,255
    static var sub = dynamicColor(lightColor: "#ffffff", darkColor: "#ffffff")
    /// 不可用状态颜色 211,211,211  -> 221,221,221
    static var disable = dynamicColor(lightColor: "#d3d3d3", darkColor: "#dddddd")
    /// 204,204,204
    static var hint = dynamicColor(lightColor: "#cccccc", darkColor: "#cccccc")
    /// 封面图背景色 236,236,236 -> 236,236,236
    static var placeholder = dynamicColor(lightColor: "#ececec", darkColor: "#ececec")
    /// 图标的默认颜色 51,51,51 -> 221,221,221
    static var icon = dynamicColor(lightColor: "#333333", darkColor: "#dddddd")
    /// 221,221,221 -> 225,225,225
    static var pageControlColor = dynamicColor(lightColor: "#dddddd", darkColor: "#ffffff")
    /// 置顶颜色 227,36,22 红色 194,27,0 深红
    static var topColor = dynamicColor(lightColor: "#E32416", darkColor: "#c21b00")
    /// 专题背景颜色 249, 250, 255, 1 -> 43,43,45
    static var specialColor = dynamicColor(lightColor: "#F9FAFF", darkColor: "#2b2b2d")
    /// 时间、删除小图标 153,153,153 -> 153,153,153
    static var greyIcon = dynamicColor(lightColor: "#999999", darkColor: "#999999")
    
    static let colors = [
        "primary": primary,
        "background": background,
        "canvas": canvas,
        "border": border,
        "divider": divider,
        "divider_dark": divider_dark,
        "text1": text1,
        "text2": text2,
        "text3": text3,
        "text4": text4,
        "text5": text5,
        "sub": sub,
        "disable": disable,
        "hint": hint,
        "placeholder": placeholder,
        "icon": icon,
        "greyIcon": greyIcon,
        "pageControlColor": pageControlColor,
        "topColor": topColor,
        "specialColor": specialColor,
    ]
}
