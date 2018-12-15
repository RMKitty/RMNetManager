//
//  RMResponseData.swift
//  RMNetManager
//
//  Created by R_M_ on 2018/12/15.
//  Copyright © 2018 R丶M. All rights reserved.
//

import Foundation

struct RMResponseData {
    /// original response data
    var response: Any?
    /// default nil. that is a error if not nil.
    var error: Error? = nil
    /// default 520.
    var code: Int16 = 520
    
    var msg: String?
    /// response data
    var data: [String:Any]?
}
