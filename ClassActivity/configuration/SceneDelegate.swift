import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            window = UIWindow(windowScene: windowScene)
            
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")

            if isLoggedIn {
                // User is logged in, show the main screen
                let mainViewController = ViewController() // Replace with your main view controller
                window?.rootViewController = UINavigationController(rootViewController: mainViewController)
            } else {
                // User is not logged in, show the login screen
                let loginViewController = MainViewController() // Replace with your login view controller
                window?.rootViewController = UINavigationController(rootViewController: loginViewController)
            }

            window?.makeKeyAndVisible()
        }
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    func sceneWillResignActive(_ scene: UIScene) {
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

