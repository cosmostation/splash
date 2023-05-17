//
//  SceneDelegate.swift
//  SplashWallet
//
//  Created by yongjoo jung on 2022/12/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Since this function isn't exclusively called to handle URLs we're not going to prematurely return if no URL is present.
        if let url = connectionOptions.urlContexts.first?.url {
            handleURL(url: url, fetching: true)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let tvc = topViewController() {
            if tvc.isKind(of: PincodeVC.self) == true {
                NotificationCenter.default.post(name: Notification.Name("AppForeGround"), object: nil, userInfo: nil)
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        if let tvc = topViewController() {
            if tvc.isKind(of: PincodeVC.self) == false && BaseData.instance.isRequiredUnlock()  {
                let pinVC = PincodeVC(nibName: "PincodeVC", bundle: nil)
                pinVC.request = .appLock
                pinVC.resultDelegate = self
                pinVC.modalPresentationStyle = .fullScreen
                tvc.present(pinVC, animated: false, completion: nil)
            }
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        handleURL(url: url)
    }
    
    func handleURL(url: URL, fetching: Bool = false) {
        if (url.scheme == "splashwallet") {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let query = components.queryItems,
               let item = query.first(where: { item in
                item.name == "url"
            })?.value {
                let action = {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000), execute: {
                        let dappVC = DappVC(nibName: "DappVC", bundle: nil)
                        dappVC.dappURL = item
                        dappVC.hidesBottomBarWhenPushed = true
                        self.topViewController()?.navigationController?.pushViewController(dappVC, animated: true)
                    })
                }
                var topVC = topViewController()
                if (topVC is PincodeVC || fetching) {
                    DataManager.shared.openDappVCAction = action
                } else {
                    action()
                }
            }
        }
    }
    
    func topViewController(base: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController
            { return topViewController(base: selected) }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension SceneDelegate: PincodeDelegate {
    func pincodeResponse(_ request: PincodeRequest, _ result: PincodeResult) {
        if result == .success {
            DataManager.shared.openDappVCAction?()
            DataManager.shared.openDappVCAction = nil
        }
    }
}
