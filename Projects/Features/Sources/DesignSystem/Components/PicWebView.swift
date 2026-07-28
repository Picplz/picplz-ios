//
//  PicWebView.swift
//  Features
//
//  Created by giwan jo on 7/21/26.
//

import SwiftUI
import WebKit

struct PicWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
}

#Preview {
    PicWebView(url: URL(string: "https://www.naver.com")!)
}
