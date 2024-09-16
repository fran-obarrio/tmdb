
import Foundation
import UIKit
import Lottie

enum LottieAnimations: String {
    case popCornIntro = "popCornIntro"
    case lottieMorty = "lottieMorty"
}

class LottieAnimationsManager {
    
    static let shared = LottieAnimationsManager()
    
    var animationView: LOTAnimationView!
    var animationCompletion: LOTAnimationCompletionBlock?
    var animationStartWithFrame: NSNumber = 0.0
    let mainLoaderSize: CGFloat = 250.0
    
    struct Constants {
        static let ProgressCompleteAnimation: CGFloat = 1.0
        static let InitialFrame: Int = 1
    }
    
    init() {
        animationView = LOTAnimationView()
    }
    
    var isPlaying: Bool {
        return animationView.isAnimationPlaying
    }
    
    func setup(view: UIView,
               animation: LottieAnimations,
               startWithFrame: Int = Constants.InitialFrame,
               loop: Bool = false,
               isMainLoader: Bool = false,
               backgroundColor: UIColor = .clear,
               contentMode: UIView.ContentMode = .scaleAspectFill,
               completion: (() -> Void)? = nil
    ) {
        animationView = LOTAnimationView(name: animation.rawValue)
        animationView.backgroundColor = isMainLoader ? UIColor.clear : backgroundColor
        animationStartWithFrame = NSNumber(value: startWithFrame)
        animationView.loopAnimation = loop
        animationView.contentMode = contentMode
        
        if isMainLoader {
            animationView.frame = CGRect(x: (view.frame.width / 2) - (mainLoaderSize / 2), y: (view.frame.height / 2) - (mainLoaderSize / 2), width: mainLoaderSize, height: mainLoaderSize)
        } else {
            animationView.frame.size = view.frame.size
        }
        if let animationCompletionBlock = completion {
            animationCompletion = { (complete: Bool) in
                if complete {
                    animationCompletionBlock()
                }
            }
        }
        
        DispatchQueue.main.async {
            if isMainLoader {
                let backgroundView = UIView(frame: CGRect(x: view.frame.minX, y: view.frame.minY - view.frame.minY, width: view.frame.width, height: view.frame.height))
                backgroundView.backgroundColor = backgroundColor
                backgroundView.tag = 100
                backgroundView.addSubview(self.animationView)
                view.addSubview(backgroundView)
            } else {
                view.addSubview(self.animationView)
            }
        }
    }
    
    func play() {
        animationView.setProgressWithFrame(animationStartWithFrame)
        animationView.play(toProgress: Constants.ProgressCompleteAnimation, withCompletion: animationCompletion)
    }
    
    func stop() {
        animationView.stop()
    }
    
    func pause() {
        animationView.pause()
    }
    
    func removeAnimationView(from backgroundView: UIView? = nil) {
        DispatchQueue.main.async {
            self.animationView.removeFromSuperview()
            if let viewWithTag = backgroundView?.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    static func removeAnimationViewFromView(_ view: UIView) {
        if let animationView = view.subviews.last as? LOTAnimationView {
            animationView.removeFromSuperview()
        }
    }
}

