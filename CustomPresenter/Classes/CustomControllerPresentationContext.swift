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

public protocol CustomControllerPresentationContext {
    var backgroundViewForPresentation: UIView? { get set }
    var backgroundAlpha: CGFloat { get }
    var duration: TimeInterval { get }
    var animationSpringDumping: CGFloat? { get }
    var animationInitialSpringVelocity: CGFloat? { get }
    var animationDriver: CustomControllerPresentationAnimationDriver? { get }
    func controllerFrame(for containerView: UIView) -> CGRect
}

public protocol CustomControllerPresentationAnimationDriver {
    func preparePresentation(from: UIViewController, to: UIViewController, containerView: UIView)
    func animatePresentation(from: UIViewController, to: UIViewController, containerView: UIView)

    func prepareDismiss(from: UIViewController, to: UIViewController, containerView: UIView)
    func animateDismiss(from: UIViewController, to: UIViewController, containerView: UIView)
}

public extension CustomControllerPresentationContext {
    public var backgroundViewForPresentation: UIView? {
        get {
            return nil
        }
        set {}
    }
    public var backgroundAlpha: CGFloat {
        return 0.0
    }
    public var duration: TimeInterval {
        return 1.0
    }
    public var animationSpringDumping: CGFloat? {
        return 1.0
    }
    public var animationInitialSpringVelocity: CGFloat? {
        return 0.0
    }
    public func controllerFrame(for containerView: UIView) -> CGRect {
        return containerView.bounds
    }
    public var animationDriver: CustomControllerPresentationAnimationDriver? {
        return nil
    }
}
