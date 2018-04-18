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

public class CustomControllerPresentationAnimator: NSObject {
    public var presentationContext: CustomControllerPresentationContext?
    public init(presentationContext: CustomControllerPresentationContext) {
        self.presentationContext = presentationContext
    }
}

extension CustomControllerPresentationAnimator: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationContext?.duration ?? 1.0
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to),
              let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        addBackgroundView(to: containerView)
        containerView.addSubview(toView)

        if let animationDriver = presentationContext?.animationDriver {
            animationDriver.preparePresentation(from: fromViewController,
                                                to: toViewController,
                                                containerView: containerView)
        } else {
            toView.frame = initialControllerFrame(for: containerView) //TODO extract do default animator            
            toView.setNeedsLayout()
            toView.layoutIfNeeded()
        }

        let animations = { [weak self] in
            guard let strongSelf = self, let presentationContext = strongSelf.presentationContext else { return }
            if let animationDriver = presentationContext.animationDriver {
                animationDriver.animatePresentation(from: fromViewController,
                                                    to: toViewController,
                                                    containerView: containerView)
            } else {
                toView.frame = strongSelf.finalControllerFrame(for: containerView)
                presentationContext.backgroundViewForPresentation?.alpha = presentationContext.backgroundAlpha
            }
        }

        let completion: (Bool) -> Void = { finished in
            transitionContext.completeTransition(true)
        }
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: presentationContext?.animationSpringDumping ?? 1.0,
                       initialSpringVelocity: presentationContext?.animationInitialSpringVelocity ?? 0.0,
                       animations: animations,
                       completion: completion)
    }
}

extension CustomControllerPresentationAnimator {

    private func addBackgroundView(to containerView: UIView) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.frame = containerView.bounds
        backgroundView.alpha = 0
        containerView.addSubview(backgroundView)
        presentationContext?.backgroundViewForPresentation = backgroundView
    }

    private func finalControllerFrame(for containerView: UIView) -> CGRect {
        guard let context = self.presentationContext else {
            return containerView.bounds
        }
        return context.controllerFrame(for: containerView)
    }

    private func initialControllerFrame(for containerView: UIView) -> CGRect {
        var rect =  finalControllerFrame(for: containerView)
        rect.origin.y = containerView.bounds.maxY
        return rect
    }
}
