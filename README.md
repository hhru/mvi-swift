# MVISwift
[![Build Status](https://github.com/hhru/mvi-swift/workflows/CI/badge.svg?branch=main)](https://github.com/hhru/mvi-swift/actions)
[![Cocoapods](https://img.shields.io/cocoapods/v/mvi-swift.svg?style=flat)](http://cocoapods.org/pods/mvi-swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/cocoapods/p/mvi-swift.svg?style=flat)](https://developer.apple.com/discover/)
[![Xcode](https://img.shields.io/badge/Xcode-11-blue.svg)](https://developer.apple.com/xcode)
[![Swift](https://img.shields.io/badge/Swift-5.1-orange.svg)](https://swift.org)
[![License](https://img.shields.io/github/license/hhru/mvi-swift.svg)](https://opensource.org/licenses/MIT)

MVISwift is a modern, Swift-based MVI framework with Combine


## Contents
- [Requirements](#requirements)
- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
- [Usage](#usage)
    - [Quick Start](#quick-start)
    - [Example App](#example-app)
- [Articles](#articles)
- [Communication](#communication)
- [License](#license)


## Requirements
- iOS 13.0+ / tvOS 13.0+
- Xcode 11+
- Swift 5.1+


## Installation
### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
``` bash
$ gem install cocoapods
```

To integrate MVISwift into your Xcode project using [CocoaPods](http://cocoapods.org), specify it in your `Podfile`:
``` ruby
platform :ios, '13.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'MVISwift', '~> 1.0.0-alpha.1'
end
```

Finally run the following command:
``` bash
$ pod install
```

### Carthage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. You can install Carthage with Homebrew using the following command:
``` sh
$ brew update
$ brew install carthage
```

To integrate MVISwift into your Xcode project using Carthage, specify it in your `Cartfile`:
``` ogdl
github "hhru/mvi-swift" ~> 1.0.0-alpha.1
```

Finally run `carthage update` to build the framework and drag the built `MVISwift.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To integrate MVISwift into your Xcode project using Swift Package Manager,
add the following as a dependency to your `Package.swift`:
``` swift
.package(url: "https://github.com/hhru/mvi-swift.git", from: "1.0.0-alpha.1")
```
Then specify `"MVISwift"` as a dependency of the Target in which you wish to use MVISwift.

Here's an example `Package.swift`:
``` swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "MyPackage",
    products: [
        .library(name: "MyPackage", targets: ["MyPackage"])
    ],
    dependencies: [
        .package(url: "https://github.com/hhru/mvi-swift.git", from: "1.0.0-alpha.1")
    ],
    targets: [
        .target(name: "MyPackage", dependencies: ["MVISwift"])
    ]
)
```


## Usage

[API Documentation](http://tech.hh.ru/mvi-swift/)

### Quick Start


``` swift
// TODO: -
```

### Example App
[Example app](Example) is a simple iOS and tvOS app that demonstrates how MVISwift works in practice.
It's also a good place to start playing with the framework.

To install it, run these commands in a terminal:

``` sh
$ git clone https://github.com/hhru/mvi-swift.git
$ cd /Example
$ pod install
$ open MVISwiftExample.xcworkspace
```


## Communication
- If you need help, open an issue.
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.

📬 You can also write to us in telegram, we will help you: https://t.me/hh_tech


## License
MVISwift is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
