//
//    Copyright © 2018 Aleksander Zubala. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

import Foundation
import UIKit

public class CustomControllerDismissAnimator: NSObject {
    public var presentationContext: CustomControllerPresentationContext?

    public init(presentationContext: CustomControllerPresentationContext) {
        self.presentationContext = presentationContext
    }
}

extension CustomControllerDismissAnimator: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationContext?.duration ?? 1.0
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView

        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
              let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        if let animationDriver = presentationContext?.animationDriver {
            animationDriver.prepareDismiss(from: fromViewController, to: toViewController, containerView: containerView)
        } else {
            fromView.frame = initialControllerFrame(for: containerView)
        }
        let animations = { [weak self] in
            guard let strongSelf = self else { return }
            if let animationDriver = strongSelf.presentationContext?.animationDriver {
                animationDriver.animateDismiss(from: fromViewController, to: toViewController, containerView: containerView)
            } else {
                fromView.frame = strongSelf.finalControllerFrame(for: containerView)
            }
            strongSelf.presentationContext?.backgroundViewForPresentation?.alpha = 0
        }
        let completion: (Bool) -> Void = { [weak self] finished in
            transitionContext.completeTransition(true)
            self?.removeBackgroundView()
        }
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: presentationContext?.animationSpringDumping ?? 1.0,
                       initialSpringVelocity: presentationContext?.animationInitialSpringVelocity ?? 0.0,
                       animations: animations,
                       completion: completion)
    }
}

extension CustomControllerDismissAnimator {

    private func removeBackgroundView() {
        presentationContext?.backgroundViewForPresentation?.removeFromSuperview()
        presentationContext?.backgroundViewForPresentation = nil
    }

    private func finalControllerFrame(for containerView: UIView) -> CGRect {
        var rect =  initialControllerFrame(for: containerView)
        rect.origin.y = containerView.bounds.maxY
        return rect
    }

    private func initialControllerFrame(for containerView: UIView) -> CGRect {
        guard let context = self.presentationContext else {
            return containerView.bounds
        }
        return context.controllerFrame(for: containerView)
    }
}



