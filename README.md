# STPostWebView

[![Version](https://img.shields.io/cocoapods/v/STPostWebView.svg?style=flat)](http://cocoapods.org/pods/STPostWebView)
[![License](https://img.shields.io/cocoapods/l/STPostWebView.svg?style=flat)](http://cocoapods.org/pods/STPostWebView)
[![Platform](https://img.shields.io/cocoapods/p/STPostWebView.svg?style=flat)](http://cocoapods.org/pods/STPostWebView)

## A subclass of WKWebView that supports requested by POST

STPostWebView is a subclass of WKWebView that supports requested by POST.

![STPostWebViewPreview01](https://github.com/shien7654321/STPostWebView/raw/master/Preview/STPostWebViewPreview01.gif)

## Requirements

- iOS 8.0 or later
- ARC
- Swift 4.2

## Installation

STPostWebView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'STPostWebView'
```

## Usage

### Import headers in your source files

In the source files where you need to use the library, import the header file:

```swift
import STPostWebView
```

### Initialize STPostWebView

STPostWebView is a subclass of WKWebView. You can initialize it like WKWebView:

```swift
STPostWebView(frame: frame, configuration: configuration)
```

### Load POST request

```swift
var urlString = "http://xxxx:xxxx/xxxx"
let getParameterString = "key1=value1&key2=value2"
urlString += "?" + getParameterString
var request = URLRequest(url: URL(string: urlString)!)
request.httpMethod = "POST"
let postParameterString = "key3=value3&key4=value4"
request.httpBody = postParameterString.data(using: .utf8)
webView.load(request)
```

### Run Example

In the Example directory there is a pages folder with some web files. Because PHP is used to write these web files, you need to configure the PHP environment on your computer. Then use the pages folder to start a server. 

Finally, set the host of this server in the Example project, for example:

```swift
// ViewController.swift

let host = "http://localhost:80"
```

## Author

Suta, shien7654321@163.com

## License

[MIT]: http://www.opensource.org/licenses/mit-license.php
[MIT license][MIT].
