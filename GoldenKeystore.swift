//
//  GoldenKeystore.swift
//  GoldenKeystore
//
//  Created by Tran Viet on 8/10/18.
//  Copyright © 2018 Skylab. All rights reserved.
//

import Foundation

public func generateMnemonic(strength:NSInteger = 128) -> String {
    return Mnemonic.generateRandom(strength: strength).value
}

public func from(mnemonic:String, passphrase:String = "") -> String {
    return Mnemonic.fromMnemonic(mnemonic, passphrase: passphrase).value
}

public func mnemonicIsValid(_ mnemonic:String) -> Bool {
    return Mnemonic.isValid(mnemonic)
}

public func createHDKeyPair(mnemonic:String, passphrase:String = "", path:String = PopularPath.ETH.rawValue, index:Int) -> HDKeyPair? {
    let mnemonic = Mnemonic.fromMnemonic(mnemonic, passphrase: passphrase)
    guard let kd = mnemonic.keyDerivation(path: path) else { return nil }
    
    let keyPair = kd.derivePath(from: mnemonic.seed).key(at: index)
    return keyPair
}

public func createHDKeyPairs(mnemonic:String, passphrase:String = "", path:String = PopularPath.ETH.rawValue, from:Int, to:Int) -> [HDKeyPair]? {
    let mnemonic = Mnemonic.fromMnemonic(mnemonic, passphrase: passphrase)
    guard let kd = mnemonic.keyDerivation(path: path)?.derivePath(from: mnemonic.seed) else { return nil }
    
    var keyPairs = [HDKeyPair]()
    
    for i in from...to {
        guard let key = kd.key(at: i) else { continue }
        keyPairs.append(key)
    }
    
    return keyPairs
}
