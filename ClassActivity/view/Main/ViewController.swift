import UIKit

class ViewController: UIViewController, LoginViewDelegate {
    
    var contentView: UIView!  // This will hold the current content view
    var folderView: FolderView?
    var settingView: SettingView?
    var loginView: LoginScreenView?
    var bottomBar: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        // Create bottom bar with buttons
        let bottomBar = ButtonBar.createInView(view, parentViewController: self)
        
        // Create initial content view (placeholder)
        contentView = UIView()
        contentView.backgroundColor = .white  // Initial background color
        
        // Add content view to main view
        view.addSubview(contentView)
        
        // Setup constraints for content view
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
        // Show initial content (FolderView) when view loads
        showFolderView()
        
    }
    
    // Method to switch content views based on type
    private func showContentView(type: ContentViewType) {
        // Remove current content view
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Determine which view to show based on type
        switch type {
        case .folder:
            if folderView == nil {
                folderView = FolderView()
                folderView!.delegate = self
            }
            contentView.addSubview(folderView!)
            folderView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .setting:
            if settingView == nil {
                settingView = SettingView()
                settingView!.delegate = self
            }
            contentView.addSubview(settingView!)
            settingView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
        case .login:
            if loginView == nil {
                loginView = LoginScreenView()
                loginView!.delegate = self
            }
            contentView.addSubview(loginView!)
            loginView!.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    // Show Folder view
    @objc func showFolderView() {
        showContentView(type: .folder)
    }
    
    // Show Setting view
    @objc func showSettingView() {
        showContentView(type: .setting)
    }
    
    // Show Login view
    @objc func showLoginView() {
        showContentView(type: .login)
    }
}

extension ViewController: SettingViewDelegate,FolderViewDelegate {
    func didUpdateFolder(oldName: String, newName: String) {
           
        }
    
    func presentAlert(_ alert: UIAlertController) {
            present(alert, animated: true, completion: nil)
        }
    
    func didCreateFolder(name: String) {
       print("crete folder")
    }
    
    func logout() {
        // Handle logout action here (navigate to login view)
        print("Logout button tapped")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "username")
        KeychainManager().delete(forKey: "username")
       
        let viewController = MainViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
    
    func login() {
        let viewController = MainViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
//    func didTapAddButton() {
//            print("hahah")
//            let createFolderController = CreateFolderScreen()
//        navigationController?.pushViewController(createFolderController, animated: true)
//        }
    func didTapAddButton() {
        let createFolderController = CreateFolderScreen()
        createFolderController.delegate = self  // Ensure delegate is set for callbacks
        navigationController?.pushViewController(createFolderController, animated: true)
    }

}


// Define enum for content view types
enum ContentViewType {
    case folder
    case setting
    case login
    
}
