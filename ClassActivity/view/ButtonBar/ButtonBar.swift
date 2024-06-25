import UIKit  // Import UIKit framework for iOS UI components

import SnapKit  // Import SnapKit for concise Auto Layout DSL

class ButtonBar {
    
    static func createInView(_ view: UIView) -> UIView {
        // Create the bottom bar view
        let bottomBar = UIView()  // Instantiate a new UIView for the bottom bar
        bottomBar.backgroundColor = .gray  // Set the background color of the bottom bar to gray
        view.addSubview(bottomBar)  // Add the bottom bar as a subview to the provided view
        
        // Set up bottom bar constraints using SnapKit
        bottomBar.snp.makeConstraints { make in  // Use SnapKit to set up Auto Layout constraints for bottomBar
            make.leading.trailing.bottom.equalToSuperview()  // Pin bottomBar to the leading, trailing, and bottom edges of its superview (view)
            make.height.equalTo(80)  // Set the height of bottomBar to 80 points
        }
        
        // Create buttons with system icons
        let buttonsData = [  // Define an array of tuples containing icon names and corresponding titles
            ("folder.fill", "Folder"),  // Tuple for the Folder button with "folder.fill" icon
            ("gearshape.fill", "Setting"),  // Tuple for the Setting button with "gearshape.fill" icon
        ]
        
        var buttons: [UIButton] = []  // Initialize an empty array to hold UIButton instances
        
        for (iconName, title) in buttonsData {  // Iterate through buttonsData array using tuples (iconName, title)
            let button = UIButton()  // Create a new UIButton instance
            var config = UIButton.Configuration.tinted()  // Create a tinted UIButton configuration
            
            config.title = title  // Set the title of the button configuration
            config.image = UIImage(systemName: iconName)  // Set the image (system icon) of the button configuration
            config.imagePadding = 5  // Set padding between the image and title in the button configuration
            config.imagePlacement = .top  // Set the placement of the image (above the title) in the button configuration
            config.baseForegroundColor = .white  // Set the foreground color (tint) of the button configuration
            config.baseBackgroundColor = .clear  // Set the background color of the button configuration
            
            button.configuration = config  // Apply the button configuration to the UIButton instance
            bottomBar.addSubview(button)  // Add the button to the bottom bar (UIView)
            buttons.append(button)  // Append the button to the buttons array
        }
        
        // Distribute buttons evenly
        for (index, button) in buttons.enumerated() {  // Iterate through the buttons array with index and UIButton instance
            button.snp.makeConstraints { make in  // Use SnapKit to define Auto Layout constraints for each button
                make.centerY.equalToSuperview()  // Center each button vertically within the bottom bar
                make.width.equalToSuperview().dividedBy(buttons.count)  // Set the width of each button to be a fraction of the bottom bar's width, distributing them evenly
                if index == 0 {
                    make.leading.equalToSuperview()  // For the first button, align its leading edge with the leading edge of the bottom bar
                } else {
                    make.leading.equalTo(buttons[index - 1].snp.trailing)  // For subsequent buttons, align the leading edge with the trailing edge of the previous button
                }
            }
        }
        
        return bottomBar  // Return the created bottomBar view
    }
}
