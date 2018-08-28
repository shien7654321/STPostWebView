//
//  STPostWebView.swift
//  STPostWebView
//
//  Created by Suta on 2018/8/24.
//  Copyright © 2018年 Suta. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class STPostWebView: WKWebView, STPostWebViewScriptMessagePresenterDelegate {
    
    private var posted = false
    private var postUserScript: WKUserScript?
    private var shouldSaveBackForwardListItem = false
    private var postedBackForwardListItems = Set<WKBackForwardListItem>()
    override public var canGoBack: Bool {
        get {
            if super.canGoBack {
                var can = false
                for item in backForwardList.backList {
                    if postedBackForwardListItems.contains(item) {
                        continue
                    }
                    can = true
                    break
                }
                return can
            } else {
                return super.canGoBack
            }
        }
    }
    
    // MARK: -
    
    convenience public init(frame: CGRect) {
        self.init(frame: frame, configuration: WKWebViewConfiguration())
    }
    
    override public init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        configurePost()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configurePost()
    }
    
    @discardableResult override public func load(_ request: URLRequest) -> WKNavigation? {
        guard let httpMethod = request.httpMethod?.uppercased(), httpMethod == "POST" else {
            return super.load(request)
        }
        guard let httpBody = request.httpBody, httpBody.count > 0 else {
            return super.load(request)
        }
        guard let urlString = request.url?.absoluteString else {
            return super.load(request)
        }
        guard let httpBodyString = String(data: httpBody, encoding: .utf8), httpBodyString.count > 0 else {
            return super.load(request)
        }
        posted = false
        let jsObjectString = httpBodyJSObjectString(httpBodyString: httpBodyString)
        let postScript = "STPostWebViewPost({path: '\(urlString)', params: \(jsObjectString)});"
        postUserScript = WKUserScript(source: postScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(postUserScript!)
        return super.load(request)
    }
    
    override public func goBack() -> WKNavigation? {
        if canGoBack {
            var targetItem: WKBackForwardListItem?
            for item in backForwardList.backList.reversed() {
                if !postedBackForwardListItems.contains(item) {
                    targetItem = item
                    break
                }
            }
            if let item = targetItem {
                return go(to: item)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    override public func goForward() -> WKNavigation? {
        if canGoForward {
            var targetItem: WKBackForwardListItem?
            for item in backForwardList.forwardList {
                if !postedBackForwardListItems.contains(item) {
                    targetItem = item
                    break
                }
            }
            if let item = targetItem {
                return go(to: item)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    // MARK: - Private
    
    private func configurePost() {
        let scriptMessagePresenter = STPostWebViewScriptMessagePresenter(delegate: self)
        let startScript = """
var STPostWebViewGetPosted = function () {

};

STPostWebViewGetPosted.prototype.callback = function (callback) {
    STPostWebViewGetPostedCallback = callback;
    return this;
};

STPostWebViewGetPosted.prototype.postMessage = function () {
    window.webkit.messageHandlers.STPostWebViewGetPosted.postMessage({});
};

var STPostWebViewGetPostedCallback = function () {

};

var STPostWebViewSetPosted = function () {

};

STPostWebViewSetPosted.prototype.callback = function (callback) {
    STPostWebViewSetPostedCallback = callback;
    return this;
};

STPostWebViewSetPosted.prototype.postMessage = function (args) {
    window.webkit.messageHandlers.STPostWebViewSetPosted.postMessage(args);
};

var STPostWebViewSetPostedCallback = function () {

};

function STPostWebViewPost(args) {
    var getPosted = new STPostWebViewGetPosted();
    getPosted.callback(function (result) {
        var posted = result.posted;
        if (!posted) {
            var setPosted = new STPostWebViewSetPosted();
            setPosted.callback(function () {
                var method = "post";
                var path = args["path"];
                var params = args["params"];
                var form = document.createElement("form");
                form.setAttribute("method", method);
                form.setAttribute("action", path);
                for (var key in params) {
                    if (params.hasOwnProperty(key)) {
                        var hiddenField = document.createElement("input");
                        hiddenField.setAttribute("type", "hidden");
                        hiddenField.setAttribute("name", key);
                        hiddenField.setAttribute("value", params[key]);
                        form.appendChild(hiddenField);
                    }
                }
                document.body.appendChild(form);
                form.submit();
            }).postMessage({
                posted: true
            });
        }
    }).postMessage();
}
"""
        let startUserScript = WKUserScript(source: startScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        let endUserScript = WKUserScript(source: "window.webkit.messageHandlers.STPostWebViewDidFinishNavigation.postMessage({});", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(startUserScript)
        configuration.userContentController.addUserScript(endUserScript)
        configuration.userContentController.add(scriptMessagePresenter, name: "STPostWebViewGetPosted")
        configuration.userContentController.add(scriptMessagePresenter, name: "STPostWebViewSetPosted")
        configuration.userContentController.add(scriptMessagePresenter, name: "STPostWebViewDidFinishNavigation")
    }
    
    private func httpBodyJSObjectString(httpBodyString: String) -> String {
        let subParameterStringArray = httpBodyString.components(separatedBy: "&")
        var jsObjectString = "{"
        for subParameterString in subParameterStringArray {
            if jsObjectString.count > 1 {
                jsObjectString += ", "
            }
            if let range = subParameterString.range(of: "=") {
                let key = String(subParameterString[..<range.lowerBound])
                let value = String(subParameterString[range.upperBound...])
                jsObjectString.append("\(key): '\(value)'")
            } else {
                jsObjectString.append("\(subParameterString): ''")
            }
        }
        jsObjectString.append("}")
        return jsObjectString
    }
    
    private func removePostUserScript() {
        guard let thePostUserScript = postUserScript else {
            return
        }
        var userScripts = configuration.userContentController.userScripts
        guard let index = userScripts.index(of: thePostUserScript) else {
            postUserScript = nil
            return
        }
        userScripts.remove(at: index)
        configuration.userContentController.removeAllUserScripts()
        for userScript in userScripts {
            configuration.userContentController.addUserScript(userScript)
        }
        postUserScript = nil
    }
    
    private func removeUnusedPostedBackForwardListItem() {
        var unusedPostedBackForwardListItems = Set<WKBackForwardListItem>()
        for item in postedBackForwardListItems {
            var use = false
            for backListItem in backForwardList.backList {
                if backListItem.isEqual(item) {
                    use = true
                    break
                }
            }
            if !use {
                for forwardListItem in backForwardList.forwardList {
                    if forwardListItem.isEqual(item) {
                        use = true
                        break
                    }
                }
            }
            if !use {
                unusedPostedBackForwardListItems.insert(item)
            }
        }
        for item in unusedPostedBackForwardListItems {
            postedBackForwardListItems.remove(item)
        }
    }
    
    // MARK: - STPostWebViewScriptMessagePresenterDelegate
    
    fileprivate func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "STPostWebViewGetPosted":
            let js = "STPostWebViewGetPostedCallback({posted: \(posted ? "true" : "false")})"
            evaluateJavaScript(js, completionHandler: nil)
        case "STPostWebViewSetPosted":
            if let result = message.body as? [String: Bool] {
                if let newPosted = result["posted"] {
                    posted = newPosted
                    let js = "STPostWebViewSetPostedCallback()"
                    evaluateJavaScript(js, completionHandler: nil)
                    shouldSaveBackForwardListItem = true
                }
            }
        case "STPostWebViewDidFinishNavigation":
            if posted {
                removePostUserScript()
            }
            if shouldSaveBackForwardListItem {
                shouldSaveBackForwardListItem = false
                if let item = backForwardList.backList.last, !postedBackForwardListItems.contains(item) {
                    postedBackForwardListItems.insert(item)
                }
            }
            removeUnusedPostedBackForwardListItem()
        default:
            break
        }
    }
    
}

// MARK: -

@objc fileprivate protocol STPostWebViewScriptMessagePresenterDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    
}

// MARK: -

fileprivate class STPostWebViewScriptMessagePresenter: NSObject, WKScriptMessageHandler {
    
    weak var delegate: STPostWebViewScriptMessagePresenterDelegate?
    
    override private init() {
        super.init()
    }
    
    convenience init(delegate: STPostWebViewScriptMessagePresenterDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
    
}
