//
//  WebViewController.swift
//  DanceDeets
//
//  Created by LambertMike on 2015/11/10.
//  Copyright © 2015年 david.xiang. All rights reserved.
//

import Foundation
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var url: NSURL?
    var initialLoadUrl: NSURL?

    func configure(withUrl startUrl: NSURL, andTitle startTitle: String) {
        url = startUrl
        title = startTitle
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if url != nil {
            // Append &webview=1 to our URLs
            let modUrl = NSURLComponents(string: url!.absoluteString)!
            if modUrl.queryItems == nil {
                modUrl.queryItems = []
            }
            modUrl.queryItems!.append(NSURLQueryItem(name: "webview", value: "1"))
            if let newUrl = modUrl.URL {
                print(newUrl)
                initialLoadUrl = newUrl
                webView.loadRequest(NSURLRequest(URL: newUrl))
            }
        }
        // TODO: set up a navigation controller, that lets us go back?
    }


    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        let isFrame = navigationAction.request.URL?.absoluteString != navigationAction.request.mainDocumentURL?.absoluteString
        if isFrame {
            decisionHandler(WKNavigationActionPolicy.Allow)
            return
        }

        if let destUrl = navigationAction.request.URL {
            if destUrl.host == "www.dancedeets.com" || destUrl == initialLoadUrl {
                decisionHandler(WKNavigationActionPolicy.Allow)
                return
            }
            UIApplication.sharedApplication().openURL(destUrl);
            decisionHandler(WKNavigationActionPolicy.Cancel)
        }
    }
}
