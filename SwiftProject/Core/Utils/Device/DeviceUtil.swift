//
//  DeviceUtil.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/2/24.
//

import UIKit
import SystemConfiguration
import CoreTelephony
import LocalAuthentication
import Metal

/// 设备信息管理类
public class DeviceUtil {
    // MARK: - 单例
    public static let current = DeviceUtil()
    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    // MARK: - 设备标识
    /// 设备唯一标识（UUID）
    public var deviceId: String {
        return identifier
    }

    public var identifier: String {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        return ""
    }
    
    
    // MARK: - 设备基本信息
    /// 设备名称（用户设置的名称）
    public var name: String {
        return UIDevice.current.name
    }
    
    /// 设备型号标识（如：iPhone14,2）
    public var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    /// 设备型号名称（如：iPhone 14 Pro）
    public var modelName: String {
        return DeviceUtilList.deviceNamesByCode[modelIdentifier] ?? "Unknown Device"
    }
    
    // MARK: - 系统信息
    /// 系统名称（如：iOS）
    public var systemName: String {
        return UIDevice.current.systemName
    }
    
    /// 系统版本（如：16.0）
    public var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// App版本号
    public var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// App构建版本号
    public var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    /// 设备语言
    public var language: String {
        return Locale.current.language.languageCode?.identifier ?? ""
    }
    
    /// 设备地区
    public var region: String {
        return Locale.current.region?.identifier ?? ""
    }
    
    // MARK: - 设备能力
    /// 是否是iPad
    public var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 是否支持Face ID
    public var hasFaceID: Bool {
        return UIDevice.current.isFaceIDCapable
    }
    
    /// 是否支持Touch ID
    public var hasTouchID: Bool {
        return UIDevice.current.isTouchIDCapable
    }
    
    // MARK: - 硬件信息
    /// 设备总存储空间（GB）
    public var totalDiskSpace: Double {
        guard let space = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemSize] as? Int64 else {
            return 0
        }
        return Double(space) / 1024 / 1024 / 1024
    }
    
    /// 设备可用存储空间（GB）
    public var freeDiskSpace: Double {
        guard let space = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemFreeSize] as? Int64 else {
            return 0
        }
        return Double(space) / 1024 / 1024 / 1024
    }
    
    /// 设备总内存（GB）
    public var totalMemory: Double {
        return Double(ProcessInfo.processInfo.physicalMemory) / 1024 / 1024 / 1024
    }
    
    /// 当前可用内存（GB）
    public var freeMemory: Double {
        var pagesize: vm_size_t = 0
        var pagecount: mach_port_t = 0
        
        host_page_size(mach_host_self(), &pagesize)
        let hostPort: mach_port_t = mach_host_self()
        var vmStats = vm_statistics64()
        var count: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &vmStats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                host_statistics64(hostPort, HOST_VM_INFO64, $0, &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            let freeSize = Double(vmStats.free_count) * Double(pagesize)
            return freeSize / 1024 / 1024 / 1024
        }
        
        return 0
    }
    
    /// GPU信息
    public var gpuName: String {
        if let device = MTLCreateSystemDefaultDevice() {
            return device.name
        }
        return "Unknown"
    }
    
    /// 电池电量
    public var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    /// 电池状态
    public var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    // MARK: - 网络信息
    /// 获取当前网络类型
    public var networkType: String {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let reachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) as SCNetworkReachability? else {
            return "unknown"
        }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if isReachable {
            if isWWAN {
                let networkInfo = CTTelephonyNetworkInfo()
                if let carrier = networkInfo.serviceCurrentRadioAccessTechnology {
                    for (_, value) in carrier {
                        switch value {
                        case CTRadioAccessTechnologyLTE: return "4G"
                        case CTRadioAccessTechnologyNR,
                             CTRadioAccessTechnologyNRNSA: return "5G"
                        default: return "3G"
                        }
                    }
                }
                return "Cellular"
            } else {
                return "WiFi"
            }
        }
        
        return "No Connection"
    }
    
    // MARK: - 屏幕信息
    /// 屏幕尺寸
    public var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    /// 屏幕分辨率
    public var screenResolution: String {
        let scale = UIScreen.main.scale
        let width = UIScreen.main.bounds.width * scale
        let height = UIScreen.main.bounds.height * scale
        return "\(Int(width))x\(Int(height))"
    }
    
    /// 是否是刘海屏
    public var hasNotch: Bool {
        guard #available(iOS 11.0, *) else { return false }
        return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 > 20
    }
    
    // MARK: - 实用方法
    /// 获取完整的设备信息字典
    public func getDeviceInfo() -> [String: Any] {
        return [
            "identifier": identifier,
            "name": name,
            "modelIdentifier": modelIdentifier,
            "modelName": modelName,
            "systemName": systemName,
            "systemVersion": systemVersion,
            "appVersion": appVersion,
            "buildNumber": buildNumber,
            "language": language,
            "region": region,
            "isPad": isPad,
            "hasFaceID": hasFaceID,
            "hasTouchID": hasTouchID,
            "totalDiskSpace": totalDiskSpace,
            "freeDiskSpace": freeDiskSpace,
            "totalMemory": totalMemory,
            "freeMemory": freeMemory,
            "gpuName": gpuName,
            "batteryLevel": batteryLevel,
            "batteryState": batteryState,
            "networkType": networkType,
            "screenSize": screenSize,
            "screenResolution": screenResolution,
            "hasNotch": hasNotch
        ]
    }
}

// MARK: - 设备型号枚举
public enum DeviceModel: String, CaseIterable {
    // MARK: - iPhone 系列
    case iPhone4 = "iPhone3,1"
    case iPhone4GSMRevA = "iPhone3,2"
    case iPhone4CDMA = "iPhone3,3"
    case iPhone4S = "iPhone4,1"
    case iPhone5GSM = "iPhone5,1"
    case iPhone5Global = "iPhone5,2"
    case iPhone5cGSM = "iPhone5,3"
    case iPhone5cGlobal = "iPhone5,4"
    case iPhone5sGSM = "iPhone6,1"
    case iPhone5sGlobal = "iPhone6,2"
    case iPhone6Plus = "iPhone7,1"
    case iPhone6 = "iPhone7,2"
    case iPhone6s = "iPhone8,1"
    case iPhone6sPlus = "iPhone8,2"
    case iPhoneSE1 = "iPhone8,4"
    case iPhone7 = "iPhone9,1"
    case iPhone7Plus = "iPhone9,2"
    case iPhone7GSM = "iPhone9,3"
    case iPhone7PlusGSM = "iPhone9,4"
    case iPhone8 = "iPhone10,1"
    case iPhone8Plus = "iPhone10,2"
    case iPhoneXGlobal = "iPhone10,3"
    case iPhone8GSM = "iPhone10,4"
    case iPhone8PlusGSM = "iPhone10,5"
    case iPhoneXGSM = "iPhone10,6"
    case iPhoneXS = "iPhone11,2"
    case iPhoneXSMax = "iPhone11,4"
    case iPhoneXSMaxGlobal = "iPhone11,6"
    case iPhoneXR = "iPhone11,8"
    case iPhone11 = "iPhone12,1"
    case iPhone11Pro = "iPhone12,3"
    case iPhone11ProMax = "iPhone12,5"
    case iPhoneSE2 = "iPhone12,8"
    case iPhone12Mini = "iPhone13,1"
    case iPhone12 = "iPhone13,2"
    case iPhone12Pro = "iPhone13,3"
    case iPhone12ProMax = "iPhone13,4"
    case iPhone13Pro = "iPhone14,2"
    case iPhone13ProMax = "iPhone14,3"
    case iPhone13Mini = "iPhone14,4"
    case iPhone13 = "iPhone14,5"
    case iPhoneSE3 = "iPhone14,6"
    case iPhone14 = "iPhone14,7"
    case iPhone14Plus = "iPhone14,8"
    case iPhone14Pro = "iPhone15,2"
    case iPhone14ProMax = "iPhone15,3"
    case iPhone15 = "iPhone15,4"
    case iPhone15Plus = "iPhone15,5"
    case iPhone15Pro = "iPhone16,1"
    case iPhone15ProMax = "iPhone16,2"
    case iPhone16 = "iPhone17,3"
    case iPhone16Plus = "iPhone17,4"
    case iPhone16Pro = "iPhone17,1"
    case iPhone16ProMax = "iPhone17,2"
    case iPhone16e = "iPhone17,5"
    
    // MARK: - iPad 系列
    case iPad = "iPad1,1"
    case iPad2WiFi = "iPad2,1"
    case iPad2GSM = "iPad2,2"
    case iPad2CDMA = "iPad2,3"
    case iPad2WiFiRevA = "iPad2,4"
    case iPad3WiFi = "iPad3,1"
    case iPad3CDMA = "iPad3,2"
    case iPad3GSM = "iPad3,3"
    case iPad4WiFi = "iPad3,4"
    case iPad4GSM = "iPad3,5"
    case iPad4CDMA = "iPad3,6"
    case iPadAirWiFi = "iPad4,1"
    case iPadAirCellular = "iPad4,2"
    case iPadAirChina = "iPad4,3"
    case iPadAir2WiFi = "iPad5,3"
    case iPadAir2Cellular = "iPad5,4"
    case iPadAir3WiFi = "iPad11,3"
    case iPadAir3Cellular = "iPad11,4"
    case iPadAir4WiFi = "iPad13,1"
    case iPadAir4Cellular = "iPad13,2"
    case iPadAir5WiFi = "iPad13,16"
    case iPadAir5Cellular = "iPad13,17"
    case iPadMiniWiFi = "iPad2,5"
    case iPadMiniGSM = "iPad2,6"
    case iPadMiniCDMA = "iPad2,7"
    case iPadMini2WiFi = "iPad4,4"
    case iPadMini2Cellular = "iPad4,5"
    case iPadMini2China = "iPad4,6"
    case iPadMini3WiFi = "iPad4,7"
    case iPadMini3Cellular = "iPad4,8"
    case iPadMini3China = "iPad4,9"
    case iPadMini4WiFi = "iPad5,1"
    case iPadMini4Cellular = "iPad5,2"
    case iPadMini5WiFi = "iPad11,1"
    case iPadMini5Cellular = "iPad11,2"
    case iPadMini6WiFi = "iPad14,1"
    case iPadMini6Cellular = "iPad14,2"
    case iPadPro97WiFi = "iPad6,3"
    case iPadPro97Cellular = "iPad6,4"
    case iPadPro129WiFi = "iPad6,7"
    case iPadPro129Cellular = "iPad6,8"
    case iPadPro129Gen2WiFi = "iPad7,1"
    case iPadPro129Gen2Cellular = "iPad7,2"
    case iPadPro105WiFi = "iPad7,3"
    case iPadPro105Cellular = "iPad7,4"
    case iPadPro11WiFi = "iPad8,1"
    case iPadPro11WiFi1TB = "iPad8,2"
    case iPadPro11Cellular = "iPad8,3"
    case iPadPro11Cellular1TB = "iPad8,4"
    case iPadPro129Gen3WiFi = "iPad8,5"
    case iPadPro129Gen3WiFi1TB = "iPad8,6"
    case iPadPro129Gen3Cellular = "iPad8,7"
    case iPadPro129Gen3Cellular1TB = "iPad8,8"
    case iPadPro11Gen2WiFi = "iPad8,9"
    case iPadPro11Gen2Cellular = "iPad8,10"
    case iPadPro129Gen4WiFi = "iPad8,11"
    case iPadPro129Gen4Cellular = "iPad8,12"
    case iPadPro11Gen3 = "iPad13,4"
    case iPadPro11Gen3_1 = "iPad13,5"
    case iPadPro129Gen5 = "iPad13,6"
    case iPadPro129Gen5_1 = "iPad13,7"
    case iPadPro129Gen5_2 = "iPad13,8"
    case iPadPro129Gen5_3 = "iPad13,9"
    case iPadPro11Gen3_2 = "iPad13,10"
    case iPadPro11Gen3_3 = "iPad13,11"
    case iPad5WiFi = "iPad6,11"
    case iPad5Cellular = "iPad6,12"
    case iPad6WiFi = "iPad7,5"
    case iPad6Cellular = "iPad7,6"
    case iPad7WiFi = "iPad7,11"
    case iPad7Cellular = "iPad7,12"
    case iPad8WiFi = "iPad11,6"
    case iPad8Cellular = "iPad11,7"
    case iPad9WiFi = "iPad12,1"
    case iPad9Cellular = "iPad12,2"
    case iPad10WiFi = "iPad13,18"
    case iPad10Cellular = "iPad13,19"
    
    var displayName: String {
        switch self {
        // iPhone 系列
        case .iPhone4: return "iPhone 4"
        case .iPhone4GSMRevA: return "iPhone 4 GSM Rev A"
        case .iPhone4CDMA: return "iPhone 4 CDMA"
        case .iPhone4S: return "iPhone 4S"
        case .iPhone5GSM: return "iPhone 5 GSM"
        case .iPhone5Global: return "iPhone 5 Global"
        case .iPhone5cGSM: return "iPhone 5c GSM"
        case .iPhone5cGlobal: return "iPhone 5c Global"
        case .iPhone5sGSM: return "iPhone 5s GSM"
        case .iPhone5sGlobal: return "iPhone 5s Global"
        case .iPhone6Plus: return "iPhone 6 Plus"
        case .iPhone6: return "iPhone 6"
        case .iPhone6s: return "iPhone 6s"
        case .iPhone6sPlus: return "iPhone 6s Plus"
        case .iPhoneSE1: return "iPhone SE (1st generation)"
        case .iPhone7: return "iPhone 7"
        case .iPhone7Plus: return "iPhone 7 Plus"
        case .iPhone7GSM: return "iPhone 7 GSM"
        case .iPhone7PlusGSM: return "iPhone 7 Plus GSM"
        case .iPhone8: return "iPhone 8"
        case .iPhone8Plus: return "iPhone 8 Plus"
        case .iPhoneXGlobal: return "iPhone X Global"
        case .iPhone8GSM: return "iPhone 8 GSM"
        case .iPhone8PlusGSM: return "iPhone 8 Plus GSM"
        case .iPhoneXGSM: return "iPhone X GSM"
        case .iPhoneXS: return "iPhone XS"
        case .iPhoneXSMax: return "iPhone XS Max"
        case .iPhoneXSMaxGlobal: return "iPhone XS Max Global"
        case .iPhoneXR: return "iPhone XR"
        case .iPhone11: return "iPhone 11"
        case .iPhone11Pro: return "iPhone 11 Pro"
        case .iPhone11ProMax: return "iPhone 11 Pro Max"
        case .iPhoneSE2: return "iPhone SE (2nd generation)"
        case .iPhone12Mini: return "iPhone 12 mini"
        case .iPhone12: return "iPhone 12"
        case .iPhone12Pro: return "iPhone 12 Pro"
        case .iPhone12ProMax: return "iPhone 12 Pro Max"
        case .iPhone13Pro: return "iPhone 13 Pro"
        case .iPhone13ProMax: return "iPhone 13 Pro Max"
        case .iPhone13Mini: return "iPhone 13 mini"
        case .iPhone13: return "iPhone 13"
        case .iPhoneSE3: return "iPhone SE (3rd generation)"
        case .iPhone14: return "iPhone 14"
        case .iPhone14Plus: return "iPhone 14 Plus"
        case .iPhone14Pro: return "iPhone 14 Pro"
        case .iPhone14ProMax: return "iPhone 14 Pro Max"
        case .iPhone15: return "iPhone 15"
        case .iPhone15Plus: return "iPhone 15 Plus"
        case .iPhone15Pro: return "iPhone 15 Pro"
        case .iPhone15ProMax: return "iPhone 15 Pro Max"
        case .iPhone16: return "iPhone 16"
        case .iPhone16Plus: return "iPhone 16 Plus"
        case .iPhone16Pro: return "iPhone 16 Pro"
        case .iPhone16ProMax: return "iPhone 16 Pro Max"
        case .iPhone16e: return "iPhone 16e"

        // iPad 系列
        case .iPad: return "iPad"
        case .iPad2WiFi: return "iPad 2 WiFi"
        case .iPad2GSM: return "iPad 2 GSM"
        case .iPad2CDMA: return "iPad 2 CDMA"
        case .iPad2WiFiRevA: return "iPad 2 WiFi Rev A"
        case .iPad3WiFi: return "iPad (3rd generation) WiFi"
        case .iPad3CDMA: return "iPad (3rd generation) CDMA"
        case .iPad3GSM: return "iPad (3rd generation) GSM"
        case .iPad4WiFi: return "iPad (4th generation) WiFi"
        case .iPad4GSM: return "iPad (4th generation) GSM"
        case .iPad4CDMA: return "iPad (4th generation) CDMA"
        case .iPadAirWiFi: return "iPad Air WiFi"
        case .iPadAirCellular: return "iPad Air Cellular"
        case .iPadAirChina: return "iPad Air China"
        case .iPadAir2WiFi: return "iPad Air 2 WiFi"
        case .iPadAir2Cellular: return "iPad Air 2 Cellular"
        case .iPadAir3WiFi: return "iPad Air (3rd generation) WiFi"
        case .iPadAir3Cellular: return "iPad Air (3rd generation) Cellular"
        case .iPadAir4WiFi: return "iPad Air (4th generation) WiFi"
        case .iPadAir4Cellular: return "iPad Air (4th generation) Cellular"
        case .iPadAir5WiFi: return "iPad Air (5th generation) WiFi"
        case .iPadAir5Cellular: return "iPad Air (5th generation) Cellular"
        case .iPadMiniWiFi: return "iPad mini WiFi"
        case .iPadMiniGSM: return "iPad mini GSM"
        case .iPadMiniCDMA: return "iPad mini CDMA"
        case .iPadMini2WiFi: return "iPad mini 2 WiFi"
        case .iPadMini2Cellular: return "iPad mini 2 Cellular"
        case .iPadMini2China: return "iPad mini 2 China"
        case .iPadMini3WiFi: return "iPad mini 3 WiFi"
        case .iPadMini3Cellular: return "iPad mini 3 Cellular"
        case .iPadMini3China: return "iPad mini 3 China"
        case .iPadMini4WiFi: return "iPad mini 4 WiFi"
        case .iPadMini4Cellular: return "iPad mini 4 Cellular"
        case .iPadMini5WiFi: return "iPad mini (5th generation) WiFi"
        case .iPadMini5Cellular: return "iPad mini (5th generation) Cellular"
        case .iPadMini6WiFi: return "iPad mini (6th generation) WiFi"
        case .iPadMini6Cellular: return "iPad mini (6th generation) Cellular"
        case .iPadPro97WiFi: return "iPad Pro (9.7-inch) WiFi"
        case .iPadPro97Cellular: return "iPad Pro (9.7-inch) Cellular"
        case .iPadPro129WiFi: return "iPad Pro (12.9-inch) WiFi"
        case .iPadPro129Cellular: return "iPad Pro (12.9-inch) Cellular"
        case .iPadPro129Gen2WiFi: return "iPad Pro (12.9-inch) (2nd generation) WiFi"
        case .iPadPro129Gen2Cellular: return "iPad Pro (12.9-inch) (2nd generation) Cellular"
        case .iPadPro105WiFi: return "iPad Pro (10.5-inch) WiFi"
        case .iPadPro105Cellular: return "iPad Pro (10.5-inch) Cellular"
        case .iPadPro11WiFi: return "iPad Pro (11-inch) WiFi"
        case .iPadPro11WiFi1TB: return "iPad Pro (11-inch) WiFi 1TB"
        case .iPadPro11Cellular: return "iPad Pro (11-inch) Cellular"
        case .iPadPro11Cellular1TB: return "iPad Pro (11-inch) Cellular 1TB"
        case .iPadPro129Gen3WiFi: return "iPad Pro (12.9-inch) (3rd generation) WiFi"
        case .iPadPro129Gen3WiFi1TB: return "iPad Pro (12.9-inch) (3rd generation) WiFi 1TB"
        case .iPadPro129Gen3Cellular: return "iPad Pro (12.9-inch) (3rd generation) Cellular"
        case .iPadPro129Gen3Cellular1TB: return "iPad Pro (12.9-inch) (3rd generation) Cellular 1TB"
        case .iPadPro11Gen2WiFi: return "iPad Pro (11-inch) (2nd generation) WiFi"
        case .iPadPro11Gen2Cellular: return "iPad Pro (11-inch) (2nd generation) Cellular"
        case .iPadPro129Gen4WiFi: return "iPad Pro (12.9-inch) (4th generation) WiFi"
        case .iPadPro129Gen4Cellular: return "iPad Pro (12.9-inch) (4th generation) Cellular"
        case .iPadPro11Gen3, .iPadPro11Gen3_1: return "iPad Pro (11-inch) (3rd generation)"
        case .iPadPro129Gen5, .iPadPro129Gen5_1, .iPadPro129Gen5_2, .iPadPro129Gen5_3: return "iPad Pro (12.9-inch) (5th generation)"
        case .iPadPro11Gen3_2, .iPadPro11Gen3_3: return "iPad Pro (11-inch) (3rd generation)"
        case .iPad5WiFi: return "iPad (5th generation) WiFi"
        case .iPad5Cellular: return "iPad (5th generation) Cellular"
        case .iPad6WiFi: return "iPad (6th generation) WiFi"
        case .iPad6Cellular: return "iPad (6th generation) Cellular"
        case .iPad7WiFi: return "iPad (7th generation) WiFi"
        case .iPad7Cellular: return "iPad (7th generation) Cellular"
        case .iPad8WiFi: return "iPad (8th generation) WiFi"
        case .iPad8Cellular: return "iPad (8th generation) Cellular"
        case .iPad9WiFi: return "iPad (9th generation) WiFi"
        case .iPad9Cellular: return "iPad (9th generation) Cellular"
        case .iPad10WiFi: return "iPad (10th generation) WiFi"
        case .iPad10Cellular: return "iPad (10th generation) Cellular"
        }
    }
}

// MARK: - DeviceUtilList
private struct DeviceUtilList {
    static let deviceNamesByCode: [String: String] = {
        var dict = [String: String]()
        for deviceModel in DeviceModel.allCases {
            dict[deviceModel.rawValue] = deviceModel.displayName
        }
        return dict
    }()
}

// MARK: - UIDevice 扩展
private extension UIDevice {
    var isFaceIDCapable: Bool {
        guard #available(iOS 11.0, *) else { return false }
        return UIDevice.current.hasCapability(.faceID)
    }
    
    var isTouchIDCapable: Bool {
        guard #available(iOS 11.0, *) else { return false }
        return UIDevice.current.hasCapability(.touchID)
    }
    
    func hasCapability(_ capability: UIDevice.Capability) -> Bool {
        var faceIDTest = false
        if #available(iOS 11.0, *) {
            faceIDTest = self.biometricType == .faceID
        }
        
        switch capability {
        case .faceID:
            return faceIDTest
        case .touchID:
            return self.biometricType == .touchID
        }
    }
    
    enum Capability {
        case faceID
        case touchID
    }
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                return .none
            }
        }
        
        return .touchID
    }
}
