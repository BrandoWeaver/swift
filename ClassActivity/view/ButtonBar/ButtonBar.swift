import UIKit
import SnapKit

class ButtonBar {
    
    static func createInView(_ view: UIView, parentViewController: ViewController) -> UIView {
        let bottomBar = UIView()
        bottomBar.backgroundColor = .gray
        view.addSubview(bottomBar)
        
        bottomBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let buttonsData = [
            ("folder.fill", "Folder", #selector(parentViewController.showFolderView)),
            ("gearshape.fill", "Setting", #selector(parentViewController.showSettingView)),
//            ("lock.fill", "Login", #selector(parentViewController.showLoginView)),
        ]
        
        var buttons: [UIButton] = []
        
        for (iconName, title, action) in buttonsData {
            let button = UIButton()
            var config = UIButton.Configuration.tinted()
            
            config.title = title
            config.image = UIImage(systemName: iconName)
            config.imagePadding = 5
            config.imagePlacement = .top
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .clear
            
            button.configuration = config
            bottomBar.addSubview(button)
            buttons.append(button)
            
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalToSuperview().dividedBy(buttonsData.count)
                if buttons.count == 1 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(buttons[buttons.count - 2].snp.trailing)
                }
            }
            
            // Add action for button tap
            button.addTarget(parentViewController, action: action, for: .touchUpInside)
        }
        
        return bottomBar
    }
}
