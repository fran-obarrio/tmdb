
import Foundation
import UIKit

public class BaseNavigationViewController: UINavigationController {
    var shouldIgnorePushingViewControllers: Bool = false
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.delegate !== self) {
            self.delegate = self
        }
        
        if (!self.shouldIgnorePushingViewControllers) {
            super.pushViewController(viewController, animated: animated)
            self.shouldIgnorePushingViewControllers = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.shouldIgnorePushingViewControllers = false
            }
        }
    }
}

extension BaseNavigationViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.shouldIgnorePushingViewControllers = false
    }
}

