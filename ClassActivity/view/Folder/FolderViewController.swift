import UIKit
import SnapKit

class FolderView: UIView, UISearchBarDelegate, UICollectionViewDelegate {
   
    weak var delegate: FolderViewDelegate?
    
    private let navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "Note Folder")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navItem.rightBarButtonItem = addButton
        navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth / 4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: "FolderCell")
        return collectionView
    }()
    
  var folderData: [(name: String, itemCount: Int)] = [("Folder 1", 5), ("Folder 2", 10), ("Folder 3", 3), ("Folder 4", 7),
                                                                ("Folder 5", 2), ("Folder 6", 8), ("Folder 7", 4), ("Folder 8", 6)] // Example data
    
    private var filteredFolderData: [(name: String, itemCount: Int)] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .green
        
        addSubview(navigationBar)
        addSubview(searchBar)
        addSubview(collectionView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
        
        // Initially, show all folders
        filteredFolderData = folderData
    }
    
    @objc private func addButtonTapped() {
        delegate?.didTapAddButton()
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredFolderData = folderData // Show all folders if search text is empty
        } else {
            filteredFolderData = folderData.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let folder = filteredFolderData[indexPath.item]
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.showConfirmationMenu(folderName: folder.name, indexPath: indexPath)
        }
        
        let updateAction = UIAction(title: "Update", image: UIImage(systemName: "pencil")) { _ in
            self.showUpdateForm(for: folder.name)
        }
        
        let menu = UIMenu(title: "", children: [updateAction, deleteAction])
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return menu
        }
    }
    
//    private func showUpdateForm(for folderName: String) {
//        let createFolderVC = CreateFolderScreen()
//        createFolderVC.updateName = folderName // Pass folder name to allow editing
//        delegate?.didTapAddButton() // Assuming this method handles navigation
//    }
    private func showUpdateForm(for folderName: String) {
        guard let viewController = delegate as? UIViewController else {
            return
        }

        let createFolderVC = CreateFolderScreen()
        createFolderVC.delegate = delegate
        createFolderVC.updateName = folderName // Pass folder name to allow editing

        viewController.navigationController?.pushViewController(createFolderVC, animated: true)
    }
    
    private func showConfirmationMenu(folderName: String, indexPath: IndexPath) {
        let yesAction = UIAction(title: "Yes", image: UIImage(systemName: "checkmark"), attributes: .destructive) { _ in
            self.confirmDeleteFolder(folderName: folderName, indexPath: indexPath)
        }
        
        let noAction = UIAction(title: "No", image: UIImage(systemName: "xmark")) { _ in
            // No action needed, just dismiss the menu
        }
        
        let confirmMenu = UIMenu(title: "Are you sure you want to delete this folder?", children: [yesAction, noAction])
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.delegate?.presentAlert(self.createConfirmationAlert(folderName: folderName, indexPath: indexPath))
        }))
        
        // Present the alert with the confirmMenu as the source
        delegate?.presentAlert(alert)
    }
    
    private func confirmDeleteFolder(folderName: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Folder", message: "Are you sure you want to delete '\(folderName)'?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.folderData.remove(at: indexPath.item)
            self.filteredFolderData.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        }))
        // Ensure that the delegate handles presenting the alert
        delegate?.presentAlert(alert)
    }
    
    private func createConfirmationAlert(folderName: String, indexPath: IndexPath) -> UIAlertController {
        let alert = UIAlertController(title: "Delete Folder", message: "Are you sure you want to delete '\(folderName)'?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.folderData.remove(at: indexPath.item)
            self.filteredFolderData.remove(at: indexPath.item)
            self.collectionView.deleteItems(at: [indexPath])
        }))
        return alert
    }
}

extension FolderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFolderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as! FolderCollectionViewCell
        let folder = filteredFolderData[indexPath.item]
        cell.configure(name: folder.name, itemCount: folder.itemCount)
        return cell
    }
}

protocol FolderViewDelegate: AnyObject {
    func didTapAddButton()
    func didCreateFolder(name: String)
    func presentAlert(_ alert: UIAlertController)
    func didUpdateFolder(oldName: String, newName: String)
}

class FolderCollectionViewCell: UICollectionViewCell {
    private let folderIconView = FolderIconView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(folderIconView)
        folderIconView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(name: String, itemCount: Int) {
        folderIconView.configure(name: name, itemCount: itemCount)
    }
}

class FolderIconView: UIView {
    private let folderIconImageView = UIImageView()
    private let folderNameLabel = UILabel()
    private let itemCountLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Configure icon image view
        folderIconImageView.contentMode = .scaleAspectFit
        addSubview(folderIconImageView)
        folderIconImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.height.equalTo(110) // Adjust the size as needed
        }
        
        // Configure labels
        folderNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        folderNameLabel.textColor = .black
        folderNameLabel.textAlignment = .center
        addSubview(folderNameLabel)
        folderNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(2)
        }
        
        itemCountLabel.font = UIFont.systemFont(ofSize: 10)
        itemCountLabel.textColor = .gray
        itemCountLabel.textAlignment = .center
        addSubview(itemCountLabel)
        itemCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(25)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configure(name: String, itemCount: Int) {
        folderIconImageView.image = UIImage(systemName: "folder.fill")
        folderIconImageView.tintColor = .yellow
        folderNameLabel.text = name
        itemCountLabel.text = "\(itemCount) items"
    }
}
