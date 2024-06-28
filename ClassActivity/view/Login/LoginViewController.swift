import UIKit
import SnapKit

class LoginScreenView: UIView {
    weak var delegate: LoginViewDelegate?

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.crop.circle.fill") 
        return imageView
    }()

    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupActions()
    }
    
    private func setupView() {
        backgroundColor = .white

        addSubview(logoImageView)
        addSubview(loginLabel)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)

        let safeArea = self.safeAreaLayoutGuide

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(40)
            make.centerX.equalTo(safeArea)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }

        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.centerX.equalTo(safeArea)
        }

        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(20)
            make.leading.equalTo(safeArea).offset(20)
            make.trailing.equalTo(safeArea).offset(-20)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(usernameTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.leading.trailing.height.equalTo(usernameTextField)
        }

        self.snp.makeConstraints { make in
            make.centerY.equalTo(safeArea).priority(.medium)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }

    @objc private func loginButtonTapped() {
        delegate?.login()
    }
}

protocol LoginViewDelegate: AnyObject {
    func login()
}
