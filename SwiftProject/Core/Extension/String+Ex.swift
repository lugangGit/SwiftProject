//
//  StringEx.swift
//  founder_news
//
//  Created by zcb on 2020/5/25.
//  Copyright © 2020 Founder. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension String {
    /// 字符串为空
    var isNullOrEmpty : Bool {
        if (isEmpty) {
            return true;
        }
        if self == "" {
            return true
        }
        if self == "(null)" {
            return true
        }
        if self == "null" {
            return true
        }
        return false
    }
    
    //字符串不为空
    var isNotEmpty: Bool {
        return !isNullOrEmpty
    }
    
    var url: URL? {
        if self.isNullOrEmpty {
            return nil
        }
        return URL(string: self) ?? nil
    }
    
    // 截取到任意位置
    func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    
    // 从任意位置开始截取
    func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    
    //从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    
    //使用下标截取到任意位置
    subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    
    //使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    
    //其他类型转字符串
    static func convert(object:Any?) -> String {
        return "\(object ?? "")"
    }
    
    func toDouble() -> Double {
        return Double("\(self)") ?? 0
    }
    
    func toInt() -> Int {
        return Int("\(self)") ?? 0
    }
    
    //转UIEdgeInsets
    func toPadding() -> UIEdgeInsets{
        let edgs = self.split(separator: ",")
        guard edgs.count == 4 else {
            return UIEdgeInsets.zero
        }
        return UIEdgeInsets(top: CGFloat((edgs[0] as NSString).floatValue), left: CGFloat((edgs[3] as NSString).floatValue), bottom: CGFloat((edgs[2] as NSString).floatValue), right: CGFloat((edgs[1] as NSString).floatValue))
    }
    
    //字体加粗
    func toFontWeight() -> UIFont.Weight {
        if self == "bold" {
            return .bold
        } else if self == "regular" {
            return .regular
        }
        return .regular
    }
    
    //字体倾斜
    func toFontStyle() -> FontStyle {
        if self == "italic" {
            return FontStyle.italic
        }
        return FontStyle.normal
    }
    
    //字符串转类
    func toClass() -> AnyClass? {
        // 1、获swift中的命名空间名
        var name = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String
        // 2、如果包名中有'-'横线这样的字符，在拿到包名后，还需要把包名的'-'转换成'_'下横线
        name = name?.replacingOccurrences(of: "-", with: "_")
        // 3、拼接命名空间和类名，”包名.类名“
        let fullClassName = name! + "." + self
        // 通过NSClassFromString获取到最终的类
        let anyClass: AnyClass? = NSClassFromString(fullClassName)
        // 本类type
        return anyClass
    }
    
    //原生md5
    var md5: String {
        guard let data = data(using: .utf8) else {
            return self
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
#if swift(>=5.0)
        
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        
#else
        
        _ = data.withUnsafeBytes { bytes in
            return CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        
#endif
        
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    //字符串转image对象
    var toImage: UIImage? {
        return UIImage(named: self)
    }
    
    //大写字符串转小写
    func toLowerCase() -> String {
        changeLowerOrUpper(lower: true)
    }
    
    //小写字符串转大写
    func toUppercase() -> String {
        changeLowerOrUpper(lower: false)
    }
    
    private func changeLowerOrUpper(lower: Bool) -> String {
        var toString = String()
        for code in self.unicodeScalars {
            let jude = lower ? code.value >= 65 && code.value <= 96 : code.value >= 97 && code.value <= 122
            if jude {
                let value = lower ? code.value + 32 : code.value - 32
                let ch: Character = Character(UnicodeScalar(value)!)
                toString.append(ch)
            } else {
                let ch: Character = Character(code)
                toString.append(ch)
            }
        }
        return toString
    }
    
    var isUrl: Bool {
        return lowercased().starts(with: "http") || lowercased().starts(with: "rtmp")
    }
    
    var isMp3: Bool {
        return lowercased().hasSuffix(".mp3") && isUrl
    }
    
    var isMp4: Bool {
        return lowercased().hasSuffix(".mp4") && isUrl
    }
    
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        Data(self.utf8)
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.current, value: "", comment: "")
    }
    
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, tableName: nil, bundle: Bundle.current, value: "", comment: ""), arguments: arguments)
    }
    
    func formatDateDifference() -> String {
        // 使用 DateFormatter 将日期字符串转换为 Date 对象
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"  // 原始日期格式

        // 将字符串转换为 Date
        if let date = inputFormatter.date(from: self) {
            let calendar = Calendar.current
            let now = Date()

            // 计算时间差
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
            
            // 如果小于一分钟，显示“刚刚”
            if let second = components.second, second < 60 {
                return "刚刚"
            }
            
            // 如果小于一小时，显示“多少分钟前”
            if let minute = components.minute, minute < 60 {
                return "\(minute)分钟前"
            }
            
            // 当天显示“几小时前”
            if let hour = components.hour, hour < 24 {
                return "\(hour)小时前"
            }
            
            // 当月显示“几天前”
            if let day = components.day, day < 30 {
                return "\(day)天前"
            }
            
            // 大于一个月显示“几月几日”
            if let month = components.month, month < 12 {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "M月d日"
                return outputFormatter.string(from: date)
            }
            
            // 大于一年显示“几年几月几日”
            if let year = components.year, year >= 1 {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy年M月d日"
                return outputFormatter.string(from: date)
            }
        }
        
        return ""
    }
    
}

