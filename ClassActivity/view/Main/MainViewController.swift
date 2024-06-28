import UIKit
import SnapKit

class MainViewController: UIViewController {
    var loginView: LoginScreenView?
    var contentView: UIView!
    var isNavigating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        
        contentView = UIView()
        view.addSubview(contentView)
        
        // Set constraints for contentView to fully occupy the parent view
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if loginView == nil {
            loginView = LoginScreenView()
            loginView!.delegate = self
        }
        
        contentView.addSubview(loginView!)
        
        // Setup constraints for loginView
        loginView!.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MainViewController: LoginViewDelegate {
    func login() {
        guard !isNavigating else { return }
        isNavigating = true
        
        print("Login")
        let enteredUsername = loginView?.usernameTextField.text ?? ""
        let enteredPassword = loginView?.passwordTextField.text ?? ""
        
        if enteredUsername.isEmpty || enteredPassword.isEmpty {
            showAlertDialog(title: "Error", message: "Username and password can't be empty!")
            isNavigating = false
        } else if (enteredUsername.lowercased() == "aditi" || enteredUsername.lowercased() == "admin") && enteredPassword == "2024" {
            print("name: \(enteredUsername)")
            print("password: \(enteredPassword)")
            
            // Store login status and username in UserDefaults
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(enteredUsername, forKey: "username")
            print("UserDefaults after login:")
            print("isLoggedIn: \(UserDefaults.standard.bool(forKey: "isLoggedIn"))")
            print("username: \(UserDefaults.standard.string(forKey: "username") ?? "No username stored")")
            if let username = KeychainManager().get(forKey: "username") {
                print("Username stored in Keychain: \(username)")
            } else {
                print("No username found in Keychain")
            }
            
            KeychainManager().set(value: enteredUsername, forKey: "username")
         
            
            showAlertDialog(title: "Login Successfully", message: "Click ok to use the app.") {
                let viewController = ViewController()
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }

        } else {
            showAlertDialog(title: "Incorrect Password", message: "Invalid username or password. Please try again.")
            isNavigating = false
        }
    }
    
    private func showAlertDialog(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.isNavigating = false
            completion?() // Invoke completion handler if provided
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
