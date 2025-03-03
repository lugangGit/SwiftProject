//
//  NetworkManager.swift
//  SwiftProject
//
//  Created by 梓源 on 2025/1/17.
//

import Alamofire
import Foundation
import Moya
import SwiftyJSON

private var requestTimeOut: Double = 20
private let dataKey = "data"
private let messageKey = "message"
private let codeKey = "status"
private let failureCode: Int = -100000
typealias RequestCallback = ((ResponseModel) -> Void)

private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    /// 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task

    /*
     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
     */
//    let additionalParameters = ["token":"888888"]
//    let defaultEncoding = URLEncoding.default
//    switch target.task {
//        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
//    case .requestPlain:
//        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
//    case .requestParameters(var parameters, let encoding):
//        additionalParameters.forEach { parameters[$0.key] = $0.value }
//        task = .requestParameters(parameters: parameters, encoding: encoding)
//    default:
//        break
//    }
    /*
     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     */

    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    
    requestTimeOut = 20
    // 针对于某个具体的业务模块来做接口配置
    if let apiTarget = target as? MultiTarget,
       let target = apiTarget.target as? API {
        switch target {
        case .easyRequset:
            return endpoint
        case .register:
            requestTimeOut = 5
            return endpoint
        default:
            return endpoint
        }
    }
    
    return endpoint
}

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        #if DEBUG
        print("🚀 REQUEST: \(request.url?.absoluteString ?? "")")
        print("📝 METHOD: \(request.httpMethod ?? "")")
        if let headers = request.allHTTPHeaderFields {
            print("🚅 HEADERS: \(headers)")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("📦 BODY: \(bodyString)")
        }
        #endif
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in
    // targetType 是当前请求的基本信息
    switch changeType {
    case .began:
        print("开始请求网络 \(changeType)")
    case .ended:
        print("结束 \(changeType)")
    }
}

/// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
fileprivate let Provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

@available(iOS 13.0, *)
@discardableResult
func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true, progress: ProgressBlock? = .none) async -> ResponseModel {
    await withCheckedContinuation({ continuation in
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, progress: progress) { responseModel in
            continuation.resume(returning: responseModel)
        } failureCallback: { responseModel in
            continuation.resume(returning: responseModel)
        }
    })
}

@discardableResult
func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true, progress: ProgressBlock? = .none, successCallback: @escaping RequestCallback, failureCallback: RequestCallback? = nil) -> Cancellable? {
    
    if !NetworkMonitor.shared.isConnected {
        handleError(code: failureCode, message: "网络开小差！", networkState: NetworkState.noNetwork(), needShowFailAlert: needShowFailAlert, failure: failureCallback)
        return nil
    }
    
    return Provider.request(MultiTarget(target), progress: progress) { result in
        switch result {
        case let .success(response):
            handleSuccessResponse(response, needShowFailAlert: needShowFailAlert, success: successCallback, failure: failureCallback)
        case let .failure(error as NSError):
            handleError(code: failureCode, message: "服务异常", networkState: NetworkState.networkError(error: error), needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
    }
}

/// 预判断后台返回的数据有效性 如通过Code码来确定数据完整性等  根据具体的业务情况来判断  有需要自己可以打开注释
/// - Parameters:
///   - response: 后台返回的数据
///   - showFailAlet: 是否显示失败的弹框
///   - failure: 失败的回调
/// - Returns: 数据是否有效
private func validateResponse(response: [String: JSON]?, needShowFailAlert: Bool, failure: RequestCallback?) -> Bool {
    /**
    var errorMessage: String = ""
    if response != nil {
        if !response!.keys.contains(codeKey) {
            errorMessage = "返回值不匹配：缺少状态码"
        } else if response![codeKey]!.int == 500 {
            errorMessage = "服务器开小差了"
        }
    } else {
        errorMessage = "服务器数据开小差了"
    }

    if errorMessage.count > 0 {
        var code: Int = 999
        if let codeNum = response?[codeKey]?.int {
            code = codeNum
        }
        if let msg = response?[messageKey]?.stringValue {
            errorMessage = msg
        }
        errorHandler(code: code, message: errorMessage, showFailAlet: showFailAlet, failure: failure)
        return false
    }
     */

    return true
}

private func handleSuccessResponse(
    _ response: Response,
    needShowFailAlert: Bool,
    success: @escaping RequestCallback,
    failure: RequestCallback?
) {
    do {
        let jsonData = try JSON(data: response.data)
        print("🎈 RESPONSE：\n \(jsonData)")
        
        // 校验响应结果
        if !validateResponse(response: jsonData.dictionary, needShowFailAlert: needShowFailAlert, failure: failure) { return }
        
        var respModel = ResponseModel()
        respModel.status = jsonData[codeKey].int ?? failureCode
        respModel.message = jsonData[messageKey].stringValue
        
        if respModel.success {
            respModel.data = jsonData[dataKey]
            success(respModel)
        } else {
            handleError(code: respModel.status, message: respModel.message, networkState: NetworkState.error(), needShowFailAlert: needShowFailAlert, failure: failure)
        }
    } catch {
        handleError(
            code: failureCode,
            message: String(data: response.data, encoding: .utf8) ?? "数据出错",
            networkState: NetworkState.error(),
            needShowFailAlert: needShowFailAlert,
            failure: failure
        )
    }
}

private func handleError(
    code: Int,
    message: String,
    networkState: NetworkState = NetworkState.error(),
    needShowFailAlert: Bool,
    failure: RequestCallback?
) {
    var model = ResponseModel()
    model.status = code
    model.message = message
    model.networkState = networkState
    if needShowFailAlert {
        ToastManager.show(type: .error(message: message))
    }
    failure?(model)
}


struct ResponseModel {
    /// 0成功；1失败
    var status: Int = 1
    /// 返回信息 success 等
    var message: String = ""
    /// 待处理数据data
    var data: Any?
    
    /// PlaceholderType
    var networkState: NetworkState?
    
    /// 请求是否成功
    var success: Bool {
        status == 0
    }
    
    init(status: Int? = 1, message: String? = "", data: Any? = nil, networkState: NetworkState? = nil) {
        self.status = status ?? 1
        self.message = message ?? ""
        self.data = data
        self.networkState = networkState
    }
}

