# GoldenKeystore
A Swift library for generating keypairs from BIP32 and BIP39

## Features

- [x] Generate mnemonic (12/18/24 words)
- [x] Check mnemonic if it is valid
- [x] Generate Hierarchical Deterministic Key

## Installation
#### CocoaPods
> CocoaPods 1.3+ is required

In your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'GoldenKeystore'
end
```

Run `pod install` from your terminal to install the library.

## Usage

In your Swift file:

```swift
import GoldenKeystore

GoldenKeystore.generateMnemonic() // generate randomly 12 words
GoldenKeystore.generateMnemonic(strength: 256) // generate randomly 24 words

GoldenKeystore.mnemonicIsValid("YOUR_MNEMONIC") // true | false

// Default path: m/44'/60'/0'/0/index
let key = GoldenKeystore.createHDKeyPair(mnemonic: "YOU_MNEMONIC", index: 0)
key.publicKeyHex // 0x0123456
key.privateKeyHex // 0x0123456abc

// For custom path and passphrase
GoldenKeystore.createHDKeyPair(
  mnemonic: "YOU_MNEMONIC",
  passphrase: "YOU_PASSPHRASE",
  path: "m/44'/1'/0'/0/index",
  index: 0
) // Bitcoin HDKey

// Generate many keys in one call
let keys = GoldenKeystore.createHDKeyPairs(
  mnemonic: "YOU_MNEMONIC",
  passphrase: "YOU_PASSPHRASE",
  path: "m/44'/60'/0'/0/index",
  from: 0,
  to: 50
)
```

## License

GoldenKeystore is released under the MIT license.