//
//  Data+.swift
//  GoldenKeystore
//
//  Created by Tran Viet on 7/20/18.
//  Copyright © 2018 Skylab. All rights reserved.
//

import Foundation

extension Data {
    var hex: String {
        return self.map { b in String(format: "%02x", b) }.joined()
    }
}
