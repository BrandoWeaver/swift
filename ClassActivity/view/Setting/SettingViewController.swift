import UIKit
import SnapKit

class SettingView: UIView {
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: SettingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        updateUsernameAndButtonTitle() // Update username label and button title on initialization
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
        updateUsernameAndButtonTitle() // Update username label and button title on initialization
    }
    
    private func setupView() {
        backgroundColor = .green
        
        // Add subviews
        addSubview(usernameLabel)
        addSubview(logoutButton)
    }
    
    private func setupConstraints() {
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(logoutButton.snp.top).offset(-20) // Adjust vertical spacing as needed
        }
        
        logoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    private func updateUsernameAndButtonTitle() {
        // Check if username exists in Keychain
        if let username = KeychainManager().get(forKey: "username") {
            usernameLabel.text = username
            logoutButton.setTitle("Logout", for: .normal)
        } else {
            usernameLabel.text = "Login required"
            logoutButton.setTitle("Login", for: .normal)
        }
    }
    
    @objc private func logoutButtonTapped() {
        if KeychainManager().get(forKey: "username") != nil {
            // User is logged in, perform logout
            delegate?.logout()
        } else {
            // User is not logged in, perform login action
            delegate?.login()
        }
    }
}

protocol SettingViewDelegate: AnyObject {
    func logout()
    func login()
}
