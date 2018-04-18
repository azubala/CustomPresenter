//
// Copyright (c) 2018 Aleksander Zubala. All rights reserved.
//

import Foundation
import UIKit

class CustomControllerDismissAnimator: NSObject {
    var presentationContext: CustomControllerPresentationContext?

    init(presentationContext: CustomControllerPresentationContext) {
        self.presentationContext = presentationContext
    }
}

extension CustomControllerDismissAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationContext?.duration ?? 1.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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

    fileprivate func removeBackgroundView() {
        presentationContext?.backgroundViewForPresentation?.removeFromSuperview()
        presentationContext?.backgroundViewForPresentation = nil
    }

    fileprivate func finalControllerFrame(for containerView: UIView) -> CGRect {
        var rect =  initialControllerFrame(for: containerView)
        rect.origin.y = containerView.bounds.maxY
        return rect
    }

    fileprivate func initialControllerFrame(for containerView: UIView) -> CGRect {
        guard let context = self.presentationContext else {
            return containerView.bounds
        }
        return context.controllerFrame(for: containerView)
    }
}



