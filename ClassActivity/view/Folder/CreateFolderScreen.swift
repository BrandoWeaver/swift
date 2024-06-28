import UIKit
import SnapKit

class CreateFolderScreen: UIViewController {

    weak var delegate: FolderViewDelegate?
    var updateName:String?
    private let folderNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Fonler\(updateName)")
        view.backgroundColor = .white
        if let folderName = updateName {
            folderNameTextField.text = folderName // Pre-fill text field with current folder name for editing
              }
        // Create a navigation bar
        let navigationBar = UINavigationBar()
        navigationBar.isTranslucent = false // Ensure no translucency for solid background
        navigationBar.barTintColor = .white // Set solid background color
        view.addSubview(navigationBar)
        
        // SnapKit constraints for navigation bar
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44) // Adjust height as needed
        }
        
        // Create navigation item with title
        let navigationItem = UINavigationItem(title: "Create Folder")
        
        // Add left button item (back button with custom label)
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Note Folder", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Custom view for left bar button item
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        // Assign navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Add Folder Name label
        let folderNameLabel = UILabel()
        folderNameLabel.text = "Folder Name:"
        view.addSubview(folderNameLabel)
        
        // SnapKit constraints for folder name label
        folderNameLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        // Add TextField for folder name
        view.addSubview(folderNameTextField)
        
        // SnapKit constraints for folder name text field
        folderNameTextField.snp.makeConstraints { make in
            make.top.equalTo(folderNameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // Add Save button
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.backgroundColor = .blue
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        // SnapKit constraints for save button
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(folderNameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
//    @objc func saveButtonTapped() {
//        
//        guard let folderName = folderNameTextField.text, !folderName.isEmpty else {
//            showAlertDialog(title: "Folder Name Can't Be Empty", message: "Please give name to your folder")
//            return
//        }
//        delegate?.didUpdateFolder(oldName: folderName, newName: folderNameTextField.text ?? "")
//        delegate?.didCreateFolder(name: folderName)
//        showAlertDialog(title: "Success", message: "Create folder successfully!"){
//            self.backButtonTapped()
//        }
//        print("foldername \(folderName)")
//    }
    @objc func saveButtonTapped() {
            guard let folderName = folderNameTextField.text, !folderName.isEmpty else {
                showAlertDialog(title: "Folder Name Can't Be Empty", message: "Please give name to your folder")
                return
            }

            if let oldName = updateName {
                delegate?.didUpdateFolder(oldName: oldName, newName: folderName)
            } else {
                delegate?.didCreateFolder(name: folderName)
            }

            showAlertDialog(title: "Success", message: "Folder created/updated successfully!") {
                self.backButtonTapped()
            }
        }
    private func showAlertDialog(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.isEditing = false
            completion?() // Invoke completion handler if provided
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
