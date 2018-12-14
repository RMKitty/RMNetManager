//
//  RMResponseData.swift
//  RMNetWorkManager
//
//  Created by RM  on 2018/11/28.
//  Copyright © 2018 __RM__. All rights reserved.
//

import UIKit

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
