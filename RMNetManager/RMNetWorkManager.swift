//
//  RMNetWorkManager.swift
//  RMNetWorkManager
//
//  Created by RM on 2018/11/28.
//  Copyright © 2018 __RM__. All rights reserved.
//

import UIKit

import Alamofire

class RMSessionManager {
    
    public static let `default`:Alamofire.SessionManager = {
        return Alamofire.SessionManager.default
    }()
    public static var config: URLSessionConfiguration? {
        
        willSet {
            guard let conf = newValue else { return }
            customSession = Alamofire.SessionManager(configuration: conf)
        }
    }
    public static var customSession: Alamofire.SessionManager?
    deinit {
        debugPrint("RM SessionManger log deinit>>>", #function)
    }
}
class RMNetWorkManager: NSObject {
    
    public static let shared = RMNetWorkManager()
    
    typealias RMResponseBlock = (_ response: RMResponseData) -> Void
    
    /// the net status.
    public var netStatus:NetworkReachabilityManager.NetworkReachabilityStatus = .unknown

    @discardableResult
    public func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> Alamofire.DataRequest
    {
//        return Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
        return __request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    // MARK: - Data POST Request
    
    /// Creates a `Data POST Request` to retrieve the contents of the specified `url`, `method`, `parameters`, `encoding`
    /// and `headers`.
    ///
    /// - parameter url:        The URL.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter encoding:   The parameter encoding. `URLEncoding.default` by default.
    /// - parameter headers:    The HTTP headers. `nil` by default.
    /// - parameter complete:  The request result.
    public func post(url: URL, paramaters: Parameters?, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, complete: @escaping RMResponseBlock) {
        
        debugPrint("RM URL >>>", url.absoluteString)
        __request(url, method: HTTPMethod.post, parameters: paramaters, encoding: encoding, headers: headers).validate().responseJSON { [weak self](response) in
            self?.__handleResponseData(response: response, complete: complete)
        }
    }
    ///
    private func __request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> Alamofire.DataRequest {
           guard let custom = RMSessionManager.customSession else {
            return RMSessionManager.default.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            }
            return custom.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    private func __handleResponseData(response: DataResponse<Any>, complete: @escaping RMResponseBlock) {
        if #available(iOS 10, *) {
            debugPrint("RM response metrics>>>", response.metrics ?? "")
        } else {
            debugPrint("RM response timeline>>>",response.timeline)
        }
        var result = RMResponseData()
        debugPrint("RM response result>>>",response.result)
        result.response = response.result
        switch response.result {
        case let .success(value):
            debugPrint("RM response success>>>",value)
            if let dict = value as? [String : Any] {
                result.data = dict
            } else {
                result.error = NSError(domain: RMError.responseTransError.rawValue, code: 9090, userInfo: nil)
                result.code = 9090
            }
        case let .failure(error):
            debugPrint("RM response failure >>>",(error as NSError))
            result.error = error
        }
        complete(result)
    }
    public func post(url: URL, paramaters: Parameters?, complete: @escaping RMResponseBlock) {
        self.post(url: url, paramaters: paramaters, encoding: URLEncoding.default, headers: nil, complete: complete)
    }
    public func get(url: URL, complete: @escaping RMResponseBlock) {
        __request(url).validate().responseJSON { [weak self](response) in
            self?.__handleResponseData(response: response, complete: complete)
        }
    }
    public func upload(
        _ data: Data,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil) {
        Alamofire.upload(data, to: url).uploadProgress { (Progress) in
            
        }
//        Alamofire.upload(<#T##stream: InputStream##InputStream#>, to: <#T##URLConvertible#>)
//        Alamofire.upload(multipartFormData: { (<#MultipartFormData#>) in
//            <#code#>
//        }, to: <#T##URLConvertible#>) { (SessionManager.MultipartFormDataEncodingResult) in
//            <#code#>
//        }
    }
    @discardableResult
    public func upload(
        _ data: Data,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil)
        -> UploadRequest
    {
//        return SessionManager.default.upload(data, to: url, method: method, headers: headers)
            return __upload(data, to: url, method: method, headers: headers)
    }
    private func __upload(
        _ data: Data,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil)
        -> UploadRequest {
            guard let custom = RMSessionManager.customSession else {
                return RMSessionManager.default.upload(data, to: url, method: method, headers: headers)
            }
            return custom.upload(data, to: url, method: method, headers: headers)
    }
    /*
    private func handleResponse(response:DataResponse<Any>, handle: RMResponseBlock) {
        switch response.result {
        case let .success(value):
            debugPrint("RM response >>>",value)
            handleResponseValue(value: value, handle: handle)
        case let .failure(error):
            debugPrint("RM response error>>>",error)
            handleError(res: response, handle: handle)
        }
    }
    */
    /*
    private func handleResponseValue(value:Any, handle: RMResponseBlock) {
       
        let json = JSON(value)
        if let data = json.dictionaryObject {
            if data["code"] is NSNull {
                var tmp = [String:Any]()
                tmp["code"] = "99999"
                tmp["msg"] = "系统异常"
                handleSuccessCode(dict:tmp, handle: handle)
            } else {
                if (data["code"] as! String) == "000" {
                    let response = RMResponseData()
                    response.code = data["code"] as? String
                    response.response = json
                    let s = data["data"] as! String
                    response.data = JSON(parseJSON: s).dictionaryObject
                    handle(response)
                } else {
                    handleSuccessCode(dict: data, handle: handle)
                }
            }
           
        } else {
            var tmp = [String:Any]()
            tmp["code"] = "99999"
            tmp["msg"] = "系统异常"
            handleSuccessCode(dict:tmp, handle: handle)
        }
    }
    */
    /*
    private func handleSuccessCode(dict:[String:Any],handle: RMResponseBlock) {
        let response = RMResponseData()
        response.code = (dict["code"] ?? "99999") as? String
        var tmp = ""
        if dict["msg"] is NSNull {
            tmp = "系统异常"
        } else {
            tmp = (dict["msg"] ?? "") as! String
        }
        response.msg = tmp.count > 50 ? "系统异常" : tmp
        response.error = NSError(domain: response.msg!, code: Int(response.code!)!, userInfo: nil)
        if response.code == "4020"  {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RMNotificationName.invalidToken.rawValue), object: nil)
        } else if response.code == "4014" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RMNotificationName.needAutoLogin.rawValue), object: nil)
        }
        handle(response)
    }
    */
    /*
    private func handleError(res:DataResponse<Any>, handle:RMResponseBlock)  {
        let response = RMResponseData()
        response.error = res.result.error
        response.response = res.result.value
        let errorInfo = res.result.error! as NSError
        response.code = String(errorInfo.code)
        if errorInfo.code == -1009 {
            response.msg = "无网络连接"
        } else if errorInfo.code == -1001 {
            response.msg = "请求超时"
        } else if errorInfo.code == -1005 {
            response.msg = "网络连接丢失(服务器忙)"
        } else if errorInfo.code == -1004 {
            response.msg = "服务器丢失"// 服务器没有启动
        } else if self.netStatus == .unknown || self.netStatus == .notReachable {
            response.msg = "网络异常,请检查网络是否连接！"
            response.code = "9998"
        } else {
            response.msg = "系统异常"
            response.code = "99999"
        }
       
        handle(response)
    }
    */
    /// default init() start to do it.
    private func startListeNetworkReachabilityStatus() {
        let netManager: NetworkReachabilityManager? = NetworkReachabilityManager()
        netManager?.listener = { [weak self] status in
            self?.netStatus = status
            debugPrint(status)
        }
        netManager?.startListening()
        
    }
    private override init() {
        super.init()
        self.startListeNetworkReachabilityStatus()
    }
    deinit {
        print("RM >>>deinit-net")
    }
}
