//
//  ScriptMessagePresenter.swift
//  STPostWebViewDemo
//
//  Created by Suta on 2018/8/28.
//  Copyright © 2018年 Suta. All rights reserved.
//

import Foundation
import WebKit

@objc protocol ScriptMessagePresenterDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
    
}

// MARK: -

class ScriptMessagePresenter: NSObject, WKScriptMessageHandler {
    
    weak var delegate: ScriptMessagePresenterDelegate?
    
    override private init() {
        super.init()
    }
    
    convenience init(delegate: ScriptMessagePresenterDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
    
}
