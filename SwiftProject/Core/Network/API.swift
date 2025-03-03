//
//  API.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/17.
//

import Foundation
import Moya
import UIKit

enum API {
    case getColumns(parentId: Int)
    case getArticlesNew(columnId: Int, lastFileId: String, page: Int, typeScreen: Int, subColId: Int, isOldApi: Bool = false)
    case updateAPi(parameters:[String:Any])
    case register(email:String, password:String)
    case uploadHeadImage(parameters: [String:Any], imageDate:Data)
    case easyRequset
    case login(phone: String)
    case uploadVideo(uploadUrl: String, token: String, fileType: String, version: String, videoPath: String)
}

extension API: TargetType {
    var baseURL: URL {
        switch self {
        case .login:
            return URL.init(string: AppConfig.shared.baseUrl)!
        case .uploadVideo(let uploadUrl, _, _, _, _):
            return URL.init(string: uploadUrl)!
        default:
            return URL.init(string: AppConfig.shared.baseUrl)!
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(let phone):
            let programParams = "devid,siteid,phone"
            let deviceId = DeviceUtil.current.deviceId
            let random = String(Int(arc4random_uniform(999999999)))
            let timestamp = Date.jk.milliStamp
            let version = "1.0.0"
            let token = ""
            let secret = "devid=\(deviceId)&random=\(random)&timestamp=\(timestamp)&token=\(token)&version=\(version)";
            let md5Secret = secret.md5;
            let programSign = "devid=\(deviceId)&siteid=11&phone=\(phone)&secret=\(md5Secret)"
            let md5ProgramSign = programSign.md5
            let dict = ["program-params" : programParams,
                        "devid" : deviceId,
                        "random" : random,
                        "timestamp" : timestamp,
                        "token" : token,
                        "version" : version,
                        "program-sign" : md5ProgramSign,
                ]
            return dict
        case .uploadVideo:
            return ["Content-type" : "multipart/form-data; charset=utf-8"]
        default:
//            let dict = [
//                "Content-type": "application/json",
//                "devid" : kDeviceId,
//                "systemName" : "iOS\(kSystemName)",
//                "version" : "iOS\(kAppVersion)"
//            ]
            //return ["Content-type": "application/json"]
            return ["Content-type": "application/json;charset=utf-8"]
        }
    }
            
    var path: String {
        var path = ""
        switch self {
        case .updateAPi:
            path = "/updateAPi"
            break
        case .register(email: _, password: _):
            path = "/register"
            break
        case .uploadHeadImage(parameters: _, imageDate: _):
            path = "/uploadHeadImage"
            break
        case .easyRequset:
            path = "/easyRequset"
            break
        case .getColumns(parentId: _):
            path = "/getColumns"
            break
        case .getArticlesNew:
            path = "/getArticlesNew"
            break
        case .login(phone: _):
            path = "/api/loginByPhone"
            break
        case .uploadVideo(uploadUrl: _, token: _, fileType: _, version: _, videoPath: _):
            path = "/api/video/v1/upload"
            break
        }
    
        return path
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .uploadVideo:
            return .post
        default:
            return .get
        }
    }
    
    var task: Task {
        if let parameters = getParameters() {
            switch self {
            case .easyRequset:
                return .requestData((parameters["data"] as! String).data(using:.utf8)!)
            case .uploadVideo:
                return .uploadCompositeMultipart(getMultipartFormData(), urlParameters: parameters)
            default:
                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            }
        } else {
            return .requestPlain
        }
    }
    
    fileprivate func getParameters() -> [String: Any]? {
        var params: [String: Any] = [:]
        // 基础参数
        params.updateValue("ios\(kAppVersion)", forKey: "appVersion")
        params.updateValue("2", forKey: "curVersions")
        params.updateValue(AppConfig.shared.appId, forKey: "appID")
        params.updateValue(1, forKey: "siteId")
        params.updateValue(0.0, forKey: "longitude")
        params.updateValue(0.0, forKey: "latitude")
        params.updateValue(0, forKey: "posionColumnID")
        params.updateValue("", forKey: "location")
        params.updateValue(kDeviceId, forKey: "device")
        params.updateValue("ios\(kSystemVersion)", forKey: "deviceInfo")

        switch self {
        case .getColumns(let parentId):
            params.updateValue(NSNumber(value: parentId), forKey: "parentColumnId")
        case .getArticlesNew(let columnId, let lastFileId, let page, let typeScreen, let subColId, _):
            params.updateValue(columnId, forKey: "columnId")
            params.updateValue(lastFileId, forKey: "lastFileId")
            params.updateValue(page, forKey: "page")
            params.updateValue(typeScreen, forKey: "typeScreen")
            params.updateValue(subColId, forKey: "subColId")
            params.updateValue(1, forKey: "adv")
        case .login(let phone):
            params.updateValue(phone, forKey: "phone")
            params.updateValue(DeviceUtil.current.deviceId, forKey: "devid")
            break
        case .uploadVideo( _, let token, let fileType, let version, _):
            params.updateValue(token, forKey: "uploadToken")
            params.updateValue(fileType, forKey: "fileType")
            params.updateValue(version, forKey: "version")
            break
        default:
            break
        }
        return params
    }
    
    fileprivate func getMultipartFormData() -> [MultipartFormData] {
        switch self {
        case .uploadVideo(_, _, _, _, let videoPath):
            var formData = [MultipartFormData]()
            if videoPath.isNotEmpty {
                let url = URL(fileURLWithPath: videoPath)
                let fileName = String(Int(arc4random_uniform(999))) + "video.mp4"
                formData.append(MultipartFormData(provider: .file(url), name: "file", fileName: fileName, mimeType:"video/mp4"))
            }
            return formData
        default :
            return [MultipartFormData]()
        }
    }
}


