//
//  ViewController.swift
//  STPostWebViewDemo
//
//  Created by Suta on 2018/8/28.
//  Copyright © 2018年 Suta. All rights reserved.
//

import UIKit
import WebKit
import STPostWebView

class ViewController: UIViewController, ScriptMessagePresenterDelegate {
    
    /// Please set the host of the pages folder, the pages folder is in the project directory, for example: "http://localhost:80"
    let host = ""
    var webView: STPostWebView!
    
    // MARK: -

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        precondition(host.count > 0, "Please set the host of the pages folder, the pages folder is in the project directory")
        
        clearCache()
        
        let scriptMessagePresenter = ScriptMessagePresenter(delegate: self)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.userContentController.add(scriptMessagePresenter, name: "ToPageB")
        configuration.userContentController.add(scriptMessagePresenter, name: "ToPageC")
        configuration.userContentController.add(scriptMessagePresenter, name: "BackToPageA")
        webView = STPostWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        loadPageA()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Private
    
    func clearCache() {
        if #available(iOS 9.0, *) {
            WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0)) {
                
            }
        } else {
            if var path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
                path += "/Cookies"
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {
                    print("Clear webView cookies failed: \(error)")
                }
            }
            URLCache.shared.removeAllCachedResponses()
            URLCache.shared.memoryCapacity = 0
            URLCache.shared.diskCapacity = 0
        }
    }
    
    func localURLString(path: String) -> String {
        return Bundle.main.bundlePath + "/pages/" + path
    }
    
    func loadPageA() {
        let path = "/pagea.php"
        var urlString = host + path
        let getParameterString = "key1=value1&key2=value2"
        urlString += "?" + getParameterString
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let postParameterString = "key3=value3&key4=value4"
        request.httpBody = postParameterString.data(using: .utf8)
        webView.load(request)
    }
    
    func loadPageB() {
        let path = "/pageb.php"
        var urlString = host + path
        let getParameterString = "key5=value5&key6=value6"
        urlString += "?" + getParameterString
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let postParameterString = "key7=value7&key8=value8"
        request.httpBody = postParameterString.data(using: .utf8)
        webView.load(request)
    }
    
    func loadPageC() {
        let path = "/pagec.php"
        var urlString = host + path
        let getParameterString = "key9=value9&key10=value10"
        urlString += "?" + getParameterString
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        let postParameterString = "key11=value11&key12=value12"
        request.httpBody = postParameterString.data(using: .utf8)
        webView.load(request)
    }
    
    // MARK: - ScriptMessagePresenterDelegate
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "ToPageB":
            loadPageB()
        case "ToPageC":
            loadPageC()
        case "BackToPageA":
            let _ = webView.goBack()
        default:
            break
        }
    }

}
