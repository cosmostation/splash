//
//  MainTabDapps.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2023/01/07.
//

import UIKit
import WebKit

class MainTabDapps: BaseVC {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let dappUrl = "https://dapps.splash.im"
        if let url = URL(string: dappUrl) {
            webView.load(URLRequest(url: url))
        }
    }
    
    func initWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.allowsLinkPreview = false
        webView.scrollView.bounces = false
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    records.forEach { record in
                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                    }
                }
        if let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String {
            webView.evaluateJavaScript("navigator.userAgent") { (result, error) in
                let originUserAgent = result as! String
                self.webView.customUserAgent = "Splash/APP/DappTab/iOS/\(version) \(originUserAgent)"
            }
        }
    }
}

extension MainTabDapps: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if (url.host == "dapps.splash.im") {
                decisionHandler(.allow)
            } else if (url.scheme == "splashwallet" && (url.host == "internaldapp" || url.host == "dapp")){
                let components = URLComponents(
                    url: url,
                    resolvingAgainstBaseURL: false
                )!
                if let query = components.queryItems, let item = query.first(where: { item in
                    item.name == "url"
                })?.value {
                    let dappVC = DappVC(nibName: "DappVC", bundle: nil)
                    dappVC.dappURL = item
                    dappVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(dappVC, animated: true)
                }
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = Theme.getThemes()[BaseData.instance.getTheme()].themeStyle
        let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.overrideUserInterfaceStyle = Theme.getThemes()[BaseData.instance.getTheme()].themeStyle
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
