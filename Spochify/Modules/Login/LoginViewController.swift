//
//  ViewController.swift
//  Spochify
//
//  Created by Alberto on 05/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let storage: Storage
    
    init(storage: Storage = Storage()) {
        self.storage = storage
        super.init(nibName: "LoginViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clientId = "b27608372edf492a85c3e4df2fe914fb"
        let responseType = "token"
        let scopes = "user-read-email"
        let redirectUri = "https://spochify.com/callback".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let state = "spochify"
        let url = URL(string: "https://accounts.spotify.com/authorize?client_id=\(clientId)&response_type=\(responseType)&redirect_uri=\(redirectUri)&state=\(state)&scope=\(scopes)")!
        let urlRequest = URLRequest(url: url)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.load(urlRequest)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        if url.host == "spochify.com" {
            decisionHandler(.cancel)
            if let fragment = url.fragment,
                let accessToken = fragment.components(separatedBy: "&")
                .filter({ $0.contains("access_token")})
                .map({ $0.replacingOccurrences(of: "access_token=", with: "") })
                .first {
                //TODO: usar Variable<Token> y compartirla entre el repo de browse y que sea el punto de partida, cuando se pushee el token hay que relanzar todo
                storage.accessToken = accessToken
                navigationController?.setViewControllers([HomeBuilder().build()], animated: true)
            } else {
                //TODO: error...
            }
        } else if url.host == "accounts.spotify.com" {
            decisionHandler(.allow)
        } else {
            //TODO: check if necessary
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

}

