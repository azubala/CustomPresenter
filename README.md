# CustomPresenter

[![Version](https://img.shields.io/cocoapods/v/CustomPresenter.svg?style=flat)](http://cocoapods.org/pods/CustomPresenter)
[![License](https://img.shields.io/cocoapods/l/CustomPresenter.svg?style=flat)](http://cocoapods.org/pods/CustomPresenter)
[![Platform](https://img.shields.io/cocoapods/p/CustomPresenter.svg?style=flat)](http://cocoapods.org/pods/CustomPresenter)

## About

**CustomPresenter** is an implementation of `UIViewControllerAnimatedTransitioning` which is a set of methods for implementing the animations for a custom view controller transition (read more [here](https://developer.apple.com/documentation/uikit/uiviewcontrolleranimatedtransitioning#)). 

This library provides implementation for presentation (`CustomControllerPresentationAnimator`) and dismissal (`CustomControllerDismissAnimator`) of view controller. Transition can be customized using presentation context:

```swift
protocol CustomControllerPresentationContext {
    var backgroundViewForPresentation: UIView? { get set }
    var backgroundAlpha: CGFloat { get }
    var duration: TimeInterval { get }
    var animationSpringDumping: CGFloat? { get }
    var animationInitialSpringVelocity: CGFloat? { get }
    var animationDriver: CustomControllerPresentationAnimationDriver? { get }
    func controllerFrame(for containerView: UIView) -> CGRect
}
```

## Setup

To use **CustomPresenter** with your view controller you need to follow these 3 steps:

- set `modalPresentationStyle` to `.custom` for your view controller
- create implementation of `CustomControllerPresentationContext` that will describe transition (don't worry, all properties have default values provided by extension, so little effort is required).
- make sure that your view controller is becomes `transitioningDelegate` and implement delegate method:

```swift
extension MyViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomControllerPresentationAnimator(presentationContext: MyPresentationContext())
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomControllerDismissAnimator(presentationContext: MyPresentationContext())
    }
}
```

**IMPORTANT**

Please note that if you are presenting your view controller wrapped in `UINavigationController`, then you have to make sure that `modalPresentationStyle` is set to `.custom` on navigation controller and `transitioningDelegate` is set to your view controller that implements it as in example above.

## Requirements

iOS 8, Swift 4

## Installation

### Cocoapods

CustomPresenter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CustomPresenter'
```

### Carthage

Simply add to your `Cartfile`:

```
github "azubala/CustomPresenter"
```

## Author

[Aleksander Zubala](mailto:alek@zubala.com) | [**zubala.com**](http://zubala.com)

## License

**CustomPresenter** is available under the MIT license. See the LICENSE file for more info.
