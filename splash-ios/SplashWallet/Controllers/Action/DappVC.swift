import UIKit
import SwiftKeychainWrapper
import Alamofire
import WebKit
import SwiftyJSON
import BigInt
import Combine
import SuiSwift
import web3swift

class DappVC: BaseVC {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlLabel: UILabel!
    
    var dappURL: String?
    
    private var publishers = [AnyCancellable]()
    
    override func viewDidLoad() {
        initWebView()
        if let dappUrl = dappURL, let url = URL(string: dappUrl) {
            navigationItem.title = url.host
            webView.load(URLRequest(url: url))
            urlLabel.text = url.host
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func initWebView() {
        if let file = Bundle.main.path(forResource: "injectScript", ofType: "js"), let script = try? String(contentsOfFile: file) {
            let userScript = WKUserScript(source: script,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: false)
            webView.configuration.userContentController.addUserScript(userScript)
            webView.configuration.userContentController.add(self, name: "station")
        }
        webView.configuration.allowsInlineMediaPlayback = true
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        webView.uiDelegate = self
        webView.allowsLinkPreview = false
    }
    

}

extension DappVC: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "station") {
            let requestJson = JSON(parseJSON: message.body as? String ?? "")
            let messageId = requestJson["messageId"].intValue
            let messageJSON = requestJson["message"]
            let method = messageJSON["method"].stringValue
            if (method == "get-account-request") {
                let data: [String: String] = ["address":DataManager.shared.account!.baseAddress!.address!,
                                                "publicKey": DataManager.shared.account!.publicKey!.toHexString()]
                appToWebResult(messageJSON, JSON(data), messageId)
            } else if (method == "get-chain") {
                let data: [String: String] = ["chain":cChainConfig.chainDpName.lowercased()]
                appToWebResult(messageJSON, JSON(data), messageId)
            } else if (method == "execute-transaction-request") {
                signAfterAction(title: "sui:signAndExecuteTransactionBlock", messageId: messageId, params: messageJSON["params"]) { hexTxBytes in
                    let txBytes = Data(hex: hexTxBytes)
                    let intentMessage = Data([0, 0, 0]) + txBytes
                    let mnemonic = DataManager.shared.account!.mnemonic!
                    let signature = SuiClient.shared.sign(mnemonic, intentMessage)
                    SuiClient.shared.executeTransaction(txBytes, signature.signedData, signature.pubKey, ["showEffects": true, "showInput":true]) { res, err in
                        self.appToWebResult(messageJSON, res!, messageId)
                    }
                }
            } else if (method == "sign-transaction-request") {
                signAfterAction(title: "sui:signTransactionBlock", messageId: messageId, params: messageJSON["params"]) { hexTxBytes in
                    let txBytes = Data(hex: hexTxBytes)
                    let intentMessage = Data([0, 0, 0]) + txBytes
                    let mnemonic = DataManager.shared.account!.mnemonic!
                    let signature = SuiClient.shared.sign(mnemonic, intentMessage)
                    let signatureBytes = Data([0]) + signature.signedData + signature.pubKey
                    let data: [String: String] = ["signature": signatureBytes.base64EncodedString(),
                                                    "transactionBlockBytes": txBytes.base64EncodedString()]
                    self.appToWebResult(messageJSON, JSON(data), messageId)
                }
            } else {
                appToWebError("Unsupported request", messageId)
            }
        }
    }
    
    private func signAfterAction(title: String, messageId: Int, params: JSON, action:  @escaping (_ hexTxBytes: String)-> ()) {
        let alertController = UIAlertController(title: "sui:signTransactionBlock", message: params.rawString(), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { _ in
            self.appToWebError("Cancel", messageId)
        }
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
            self.onShowWait()
            var txBlock = ""
            if (title == "sui:signTransactionBlock") {
                txBlock = params["transaction"].stringValue
            } else {
                txBlock = params["data"].stringValue
            }
            AF.request("https://us-central1-splash-wallet-60bd6.cloudfunctions.net/buildSuiTransactionBlock",
                       method: .post,
                       parameters: ["rpc": DataManager.shared.account?.chainConfig?.rpcEndPoint, "txBlock":txBlock, "address":params["account"].stringValue],
                       encoder: JSONParameterEncoder.default).response { response in
                switch response.result {
                case .success(let value):
                    if let value = value, let hex = String(data: value, encoding: .utf8) {
                        action(hex)
                    } else {
                        self.appToWebError("TransactionBlock build error", messageId)
                    }
                case .failure:
                    self.appToWebError("TransactionBlock build error", messageId)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func appToWebResult(_ messageJson: JSON, _ data: JSON, _ messageId: Int) {
        var responseJson = JSON()
        responseJson["result"] = data
        var postMessageJson = JSON()
        postMessageJson["messageId"].intValue = messageId
        postMessageJson["isSplash"] = true
        postMessageJson["response"] = responseJson
        postMessageJson["message"] = messageJson
        webView.evaluateJavaScript("window.postMessage(\(postMessageJson.rawString() ?? ""));")
        onDismissWait()
    }
    
    private func appToWebError(_ error: String, _ messageId: Int) {
        var responseJson = JSON()
        responseJson["error"].stringValue = error
        var postMessageJson = JSON()
        postMessageJson["messageId"].intValue = messageId
        postMessageJson["isSplash"] = true
        postMessageJson["response"] = responseJson
        webView.evaluateJavaScript("window.postMessage(\(postMessageJson.rawString() ?? ""));")
        onDismissWait()
    }
    
    @IBAction func goForward() {
        if (webView.canGoForward) {
            webView.goForward()
        }
    }
    
    @IBAction func goBack() {
        if (webView.canGoBack) {
            webView.goBack()
        }
    }
    
    @IBAction func refresh() {
        webView.reload()
    }
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DappVC: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel) { _ in
            completionHandler()
        }
        alertController.addAction(cancelAction)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { _ in
            completionHandler(false)
        }
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default) { _ in
            completionHandler(true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
            self.present(alertController, animated: true, completion: nil)
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let host = webView.url?.host {
            self.urlLabel.text = host
        }
    }
}
