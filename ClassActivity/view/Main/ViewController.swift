import UIKit  // Import UIKit framework for iOS UI components

import SnapKit  // Import SnapKit for concise Auto Layout DSL

class ViewController: UIViewController {  // Define a view controller subclass
    
    override func viewDidLoad() {  // Called when the view controller's view is loaded into memory
        super.viewDidLoad()  // Call the superclass's implementation of viewDidLoad()
        view.backgroundColor = .white  // Set the background color of the view to white
        
        _ = ButtonBar.createInView(view)  // Call the static method createInView from ButtonBar class, passing the current view as parameter and ignoring the return value
    }
}
