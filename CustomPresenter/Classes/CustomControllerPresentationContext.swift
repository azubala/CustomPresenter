//
// Copyright (c) 2018 Aleksander Zubala. All rights reserved.
//

import Foundation
import UIKit

protocol CustomControllerPresentationContext {
    var backgroundViewForPresentation: UIView? { get set }
    var backgroundAlpha: CGFloat { get }
    var duration: TimeInterval { get }
    var animationSpringDumping: CGFloat? { get }
    var animationInitialSpringVelocity: CGFloat? { get }
    var animationDriver: CustomControllerPresentationAnimationDriver? { get }
    func controllerFrame(for containerView: UIView) -> CGRect
}

protocol CustomControllerPresentationAnimationDriver {
    func preparePresentation(from: UIViewController, to: UIViewController, containerView: UIView)
    func animatePresentation(from: UIViewController, to: UIViewController, containerView: UIView)

    func prepareDismiss(from: UIViewController, to: UIViewController, containerView: UIView)
    func animateDismiss(from: UIViewController, to: UIViewController, containerView: UIView)
}

extension CustomControllerPresentationContext {
    var backgroundViewForPresentation: UIView? {
        get {
            return nil
        }
        set {}
    }
    var backgroundAlpha: CGFloat {
        return 0.0
    }
    var duration: TimeInterval {
        return 1.0
    }
    var animationSpringDumping: CGFloat? {
        return 1.0
    }
    var animationInitialSpringVelocity: CGFloat? {
        return 0.0
    }
    func controllerFrame(for containerView: UIView) -> CGRect {
        return containerView.bounds
    }
    var animationDriver: CustomControllerPresentationAnimationDriver? {
        return nil
    }
}
