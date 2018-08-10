//
//  HDNode.swift
//  GoldenKeystore
//
//  Created by Tran Viet on 7/19/18.
//  Copyright © 2018 Skylab. All rights reserved.
//

import Foundation
import TrezorCrypto

final class KeyDerivation: NSObject {
    static let highestBit:UInt32 = 0x80000000
    
    typealias KeyIndexPath = (value: UInt32, hardened: Bool)
    private var indexes = [KeyIndexPath]()
    private var currentChildNode:HDNode?
    
    let path:String
    
    private func getKeyIndexPath(value: Int, hardened: Bool) -> KeyIndexPath {
        let val = hardened ? UInt32(value) | KeyDerivation.highestBit : UInt32(value)
        return KeyIndexPath(val, hardened)
    }
    
    init?(path: String) {
        self.path = path.replacingOccurrences(of: "/index", with: "")
        super.init()
        
        let components = self.path.split(separator: "/")
        for component in components {
            if component == "m" {
                continue
            }
            if component.hasSuffix("'") {
                guard let value = Int(component.dropLast()) else { return nil }
                indexes.append(getKeyIndexPath(value: value, hardened: true))
            } else {
                guard let value = Int(component) else { return nil }
                indexes.append(getKeyIndexPath(value: value, hardened: false))
            }
        }
    }
    
    @objc public func derivePath(from seed:Data) -> KeyDerivation {
        var node = HDNode()
        _ = seed.withUnsafeBytes { dataPtr in
            hdnode_from_seed(dataPtr, Int32(seed.count), "secp256k1", &node)
        }
        
        for index in indexes {
            hdnode_private_ckd(&node, index.value)
        }
        
        self.currentChildNode = node
        return self
    }
    
    func key(at index:Int) -> HDKeyPair? {
        guard var node = self.currentChildNode else { return nil }
        hdnode_private_ckd(&node, UInt32(index))
        return HDKeyPair(node: node)
    }
}
