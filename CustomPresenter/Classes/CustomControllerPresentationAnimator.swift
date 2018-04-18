//
// Copyright (c) 2018 Aleksander Zubala. All rights reserved.
//

import Foundation
import UIKit

class CustomControllerPresentationAnimator: NSObject {
    var presentationContext: CustomControllerPresentationContext?
    init(presentationContext: CustomControllerPresentationContext) {
        self.presentationContext = presentationContext
    }
}

extension CustomControllerPresentationAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presentationContext?.duration ?? 1.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
            toView.setupRoundedCorners()
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

    fileprivate func addBackgroundView(to containerView: UIView) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.frame = containerView.bounds
        backgroundView.alpha = 0
        containerView.addSubview(backgroundView)
        presentationContext?.backgroundViewForPresentation = backgroundView
    }

    fileprivate func finalControllerFrame(for containerView: UIView) -> CGRect {
        guard let context = self.presentationContext else {
            return containerView.bounds
        }
        return context.controllerFrame(for: containerView)
    }

    fileprivate func initialControllerFrame(for containerView: UIView) -> CGRect {
        var rect =  finalControllerFrame(for: containerView)
        rect.origin.y = containerView.bounds.maxY
        return rect
    }
}
