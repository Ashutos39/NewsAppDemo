//
//  DetailsViewController.swift
//  NewsApiDemo
//
//  Created by Ashutos Sahoo on 26/11/22.
//

import UIKit
import WebKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var loadArticleWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var detailVM: DetailScreenViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func initialiseData(articleUrl: String) {
        detailVM = DetailScreenViewModel(articleUrl: articleUrl)
    }
    
}

extension DetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        print("Started to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        print("Finished loading")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        print(error.localizedDescription)
    }
}

private extension  DetailsViewController {
    func setUpUI() {
        guard let url = URL(string: detailVM?.articleUrl ?? "") else { return  }
        loadArticleWebView.load(URLRequest(url: url))
        loadArticleWebView.navigationDelegate = self
        loadArticleWebView.allowsBackForwardNavigationGestures = true
    }
}
