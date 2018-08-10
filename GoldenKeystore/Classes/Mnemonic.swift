//
//  Mnemonic.swift
//  GoldenKeystore
//
//  Created by Tran Viet on 7/19/18.
//  Copyright © 2018 Skylab. All rights reserved.
//

import Foundation
import TrezorCrypto

final class Mnemonic {
    let value:String
    let seed:Data
    
    init(value: String, seed:Data) {
        self.value = value
        self.seed = seed
    }
    
    var masterNode:HDNode {
        var node = HDNode()
        _ = seed.withUnsafeBytes { dataPtr in
            hdnode_from_seed(dataPtr, Int32(seed.count), "secp256k1", &node)
        }
        
        return node
    }
    
    func keyDerivation(path:String) -> KeyDerivation? {
        if let _ = PopularPath(rawValue: path) {
            return KeyDerivation(path: path)
        }
        return nil
    }
    
    static func generateRandom(strength: Int) -> Mnemonic {
        let rawString = mnemonic_generate(Int32(strength))!
        let value = String(cString: rawString)
        
        let seed = Mnemonic.deriveSeed(mnemonic: value, passphrase: "")
        return Mnemonic(value: value, seed: seed)
    }
    
    static func isValid(_ string: String) -> Bool {
        return mnemonic_check(string) != 0
    }
    
    static func fromDataSeed(from data: Data) -> Mnemonic {
        let rawString = data.withUnsafeBytes { dataPtr in
            mnemonic_from_data(dataPtr, Int32(data.count))!
        }
        
        return Mnemonic(value: String(cString: rawString), seed: data)
    }
    
    static func fromMnemonic(_ mnemonic: String, passphrase: String) -> Mnemonic {
        let seed = deriveSeed(mnemonic: mnemonic, passphrase: passphrase)
        return Mnemonic(value: mnemonic, seed: seed)
    }
    
    static func deriveSeed(mnemonic: String, passphrase: String) -> Data {
        var seed = Data(repeating: 0, count: 512 / 8)
        seed.withUnsafeMutableBytes { seedPtr in
            mnemonic_to_seed(mnemonic, passphrase, seedPtr, nil)
        }
        return seed
    }
}
