//
//  RMNetWorkManager.swift
//  RMNetManager
//
//  Created by R_M_ on 2018/12/15.
//  Copyright © 2018 R丶M. All rights reserved.
//

import Foundation

import Alamofire

public class RMSessionManager {
    
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
    // TODO: upload
    public func upload(
        _ data: Data,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil) {
        Alamofire.upload(data, to: url).uploadProgress { (Progress) in
            
        }
    }
    @discardableResult
    private func upload(
        _ data: Data,
        to url: URLConvertible,
        method: HTTPMethod = .post,
        headers: HTTPHeaders? = nil)
        -> UploadRequest
    {
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
