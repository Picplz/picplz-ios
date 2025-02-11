//
//  LoginViewController.swift
//  PicplzClient
//
//  Created by 임영택 on 2/7/25.
//

import UIKit
import WebKit
import OSLog
import Combine

final class LoginViewController: UIViewController {
    private var webView = WKWebView()
    
    var viewModel: LoginViewModelProtocol!
    var authProvider: AuthProvider = .kakao
    private var log = Logger.of("LoginViewController")
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
        
        webView.navigationDelegate = self
        viewModel.didSetAuthProvider(authProvider: authProvider)
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
    
    private func bind() {
        viewModel.authEntrypointUrlPublisher
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink { [weak self] url in
                self?.webView.load(URLRequest(url: url))
            }
            .store(in: &subscriptions)
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
