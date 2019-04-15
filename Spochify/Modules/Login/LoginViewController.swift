//
//  ViewController.swift
//  Spochify
//
//  Created by Alberto on 05/04/2019.
//  Copyright © 2019 com.github.albertopeam. All rights reserved.
//

import UIKit
import WebKit
import RxSwift

class LoginViewController: UIViewController, WKNavigationDelegate, BindableType {
    
    typealias ViewModelType = LoginViewModel
    var viewModel: LoginViewModel!
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: "LoginViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindViewModel() {
        viewModel.login
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (request) in
                self.webview.load(request)
            })
        .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        decisionHandler(.allow)
        viewModel.parseTokenAction
            .execute(url)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

}

