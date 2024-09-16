
import Foundation
import UIKit


public protocol RootShowable: AnyObject {
    func showAsRoot()
}

extension RootShowable where Self: UIViewController {
    
    public func showAsRoot() {
        guard let window = window else {
            return
        }
        
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
}

extension UIViewController: RootShowable {
    
    public var window: UIWindow? {
        var appWindow = view.window
        if appWindow == nil {
            if UIApplication.shared.windows.count > 0 {
                appWindow = UIApplication.shared.windows[0]
            }
        }
        return appWindow
    }

}



