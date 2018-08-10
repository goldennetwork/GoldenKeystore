//
//  ECKeyPair.swift
//  GoldenKeystore
//
//  Created by Tran Viet on 7/19/18.
//  Copyright © 2018 Skylab. All rights reserved.
//

import Foundation
import TrezorCrypto

public final class HDKeyPair {
    var node: HDNode
    
    init(node: HDNode) {
        self.node = node
    }
    
    public var privateKeyHex:String {
        return self.privateKey.hex
    }
    
    public var publicKeyHex:String {
        return self.publicKey.hex
    }
    
    public var privateKey: Data {
        return Data(bytes: withUnsafeBytes(of: &node.private_key) { ptr in
            return ptr.map({ $0 })
        })
    }
    
    public var publicKey: Data {
        var key = Data(repeating: 0, count: 65)
        privateKey.withUnsafeBytes { ptr in
            key.withUnsafeMutableBytes { keyPtr in
                ecdsa_get_public_key65(node.curve.pointee.params, ptr, keyPtr)
            }
        }
        return key
    }
}
