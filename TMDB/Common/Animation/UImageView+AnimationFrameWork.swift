

import UIKit

enum animPosition {
    case left
    case right
}

enum animVelocity {
    case slow
    case normal
    case fast
    case superFast
}

typealias CompletionBlock = (() -> ())

extension UIImage {
    
    func animateByColumnsMovie(cols: Int,  container: UIImageView, velocity: animVelocity, position: animPosition) {
        
        var images = self.matrix(1, cols)
        
        container.clearSubviews()
        
        let containerView = UIView(frame:  CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height))
        containerView.clipsToBounds = true
        container.addSubview(containerView)
        
        var initX: CGFloat = 0.0
        var count: CGFloat = 0.0
        if position == .right {
            images.reverse()
            initX =   container.frame.width - (container.frame.width / CGFloat(cols))
        }
        
        for i in images {
            let imageView = UIImageView(image: i)
            imageView.frame = CGRect(x: CGFloat(initX), y: 0, width: container.frame.width / CGFloat(cols), height: container.frame.height)
            imageView.alpha = 0
            
            containerView.addSubview(imageView)
            
            imageView.animate(withType: [AnimationType.movie(width: CGFloat(-container.frame.width / CGFloat(cols)))], delay: Double(count)  * 0.035, duration: getVelocity(vel: velocity))
            
            if position == .right {
                initX -= container.frame.width / CGFloat(cols)
            } else {
                initX += container.frame.width / CGFloat(cols)
            }
            count += 1.0
            
            
        }
        
    }

    func matrix(_ rows: Int, _ columns: Int) -> [UIImage] {
        let y = (size.height / CGFloat(rows)).rounded()
        let x = (size.width / CGFloat(columns)).rounded()
        var images: [UIImage] = []
        images.reserveCapacity(rows * columns)
        guard let cgImage = cgImage else { return [] }
        (0..<rows).forEach { row in
            (0..<columns).forEach { column in
                var width = Int(x)
                var height = Int(y)
                if row == rows-1 && size.height.truncatingRemainder(dividingBy: CGFloat(rows)) != 0 {
                    height = Int(size.height - size.height / CGFloat(rows) * (CGFloat(rows)-1))
                }
                if column == columns-1 && size.width.truncatingRemainder(dividingBy: CGFloat(columns)) != 0 {
                    width = Int(size.width - (size.width / CGFloat(columns) * (CGFloat(columns)-1)))
                }
                if let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: column * Int(x), y:  row * Int(x)), size: CGSize(width: width, height: height))) {
                    images.append(UIImage(cgImage: image, scale: scale, orientation: imageOrientation))
                }
            }
        }
        return images
    }
    
    func getVelocity(vel: animVelocity) -> Double {
        var velocity: Double =  0.4
        switch vel {
        case .slow:
            velocity = 0.4
        case .normal:
            velocity = 0.2
        case .fast:
            velocity = 0.15
        case .superFast:
            velocity = 0.1
            
        }
        
        return velocity
        
    }
    
    
    func getDelay(vel: animVelocity) -> Double {
        var velocity: Double =  0.4
        switch vel {
        case .slow:
            velocity = 0.3
        case .normal:
            velocity = 0.2
        case .fast:
            velocity = 0.15
        case .superFast:
            velocity = 0.1
            
        }
        
        return velocity
        
    }
    
}

extension UIView {
    func clearSubviews()
    {
        for subview in self.subviews {
            subview.removeFromSuperview();
        }
    }
}

enum AnimationType {
    case movie(width: CGFloat)

    var initialTransform: CGAffineTransform {
        switch self {
        case .movie(width: let width):
            let transform = CGAffineTransform(scaleX: 0.1, y: 1)
            transform.concatenating(CGAffineTransform(translationX: width, y: 0))
            return transform
        }
        
        
    }
    
}

extension UIView {
    
    func animate(withType: [AnimationType], reversed: Bool = false, initialAlpha: CGFloat = 0.0, finalAlpha: CGFloat = 1.0, delay: Double = 0.0, duration: TimeInterval = AnimationConfiguration.duration, backToOriginalForm: Bool = false, completion: CompletionBlock? = nil) {
        
        let transformFrom = transform
        var transformTo = transform
        
        withType.forEach { (viewTransform) in
            transformTo = transformTo.concatenating(viewTransform.initialTransform)
        }
        
        if reversed == false {
            transform = transformTo
        }
        
        alpha = initialAlpha
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: duration, delay: delay, options: [.curveLinear, .curveEaseInOut], animations: { [weak self] in
                self?.transform = reversed == true ? transformTo : transformFrom
                self?.alpha = finalAlpha
            }, completion: { (_) in
                completion?()
                if backToOriginalForm == true {
                    UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveLinear, .curveEaseInOut], animations: { [weak self] in
                        self?.transform = .identity
                    }, completion: nil)
                }
            })
        }
    }

    
    
    func animateFrame(initX: CGFloat, initY: CGFloat = 0.0, width: CGFloat, height: CGFloat, duration: Double, delay: Double = 0.0) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.alpha = 1
                strongSelf.frame = CGRect(x: initX, y: initY, width: width, height: height)
                }, completion: nil)
        }
        
    }
    
    
    func animateAll(withType: [AnimationType], interval: Double = AnimationConfiguration.interval) {
        for(index, value) in subviews.enumerated() {
            let delay = Double(index) * interval
            value.animate(withType: withType, delay: delay)
        }
    }

    func restoreAllViewToIdentity() {
        for(_, value) in subviews.enumerated() {
            value.transform = CGAffineTransform.identity
        }
    }
    
}

class AnimationConfiguration {
    
    static var offset: CGFloat = 30.0
    static var duration: Double = 0.15
    static var interval: Double = 0.035
    static var maxZoomScale: Double = 2.0
    static var maxRotationAngle: CGFloat = .pi / 4
    
}

