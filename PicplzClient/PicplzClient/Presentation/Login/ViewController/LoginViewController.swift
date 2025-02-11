//
//  LoginViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import WebKit
import OSLog

final class LoginViewController: UIViewController {
    private var webView = WKWebView()
    
    var viewModel: LoginViewModelProtocol!
    var authProvider: AuthProvider = .kakao
    private var log = Logger.of("LoginViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        webView.navigationDelegate = self
        let initialUrl = URL(string: "http://3.36.183.87:8080/api/v1\(authProvider.getAuthEntrypointPath())")!
        log.debug("set initialUrl: \(initialUrl)")
        webView.load(URLRequest(url: initialUrl))
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url,
           url.host == "localhost" {
            log.debug("localhost - \(url)")
            viewModel.loginFinished(resultUrl: url)
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
}
