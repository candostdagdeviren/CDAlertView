![CDAlertView: Highly customizable alert popup](https://cloud.githubusercontent.com/assets/1971963/20237496/34d3081c-a8d4-11e6-8907-80b4c248dce0.png)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapod](http://img.shields.io/cocoapods/v/CDAlertView.svg?style=flat)](http://cocoadocs.org/docsets/CDAlertView/)
[![CI Status](http://img.shields.io/travis/candostdagdeviren/CDAlertView.svg?style=flat)](https://travis-ci.org/candostdagdeviren/CDAlertView/)
[![Language](https://img.shields.io/badge/swift-4.0-orange.svg)](https://developer.apple.com/swift)
[![Platform](http://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://raw.githubusercontent.com/candostdagdeviren/CDAlertView/master/LICENSE)

CDAlertView is highly customizable alert popup written in Swift. Usage is similar to `UIAlertController`.

### Screenshots

![CDAlertView Types](https://cloud.githubusercontent.com/assets/1971963/20238308/4bc1516e-a8e8-11e6-8e8b-c1a088f5daa0.png)

### Animations

![1](https://github.com/candostdagdeviren/CDAlertView/blob/master/Screenshots/1.gif)
![2](https://github.com/candostdagdeviren/CDAlertView/blob/master/Screenshots/2.gif)
![3](https://github.com/candostdagdeviren/CDAlertView/blob/master/Screenshots/3.gif)

## Usage

Basic usage without any buttons:

```swift
CDAlertView(title: "Awesome Title", message: "Well explained message!", type: .notification).show()
```
**NOTE:** You can use it without buttons. Touch outside of the popup or move it will disappear it if there is no action button. If there is an action button, only pressing button will disappear it.

To add new buttons:
```swift
let alert = CDAlertView(title: "Awesome Title", message: "Are you in?!", type: .notification)
let doneAction = CDAlertViewAction(title: "Sure! 💪")
alert.add(action: doneAction)
let nevermindAction = CDAlertViewAction(title: "Nevermind 😑")
alert.add(action: nevermindAction)
alert.show()
```

To enable text field in popup:
```swift
alert.isTextFieldHidden = false
```

Custom view is also supported. If you want to use custom view, you are responsible for the height of custom view. Custom view is used in `UIStackView`.
```swift
let myCustomView = UIVIew(frame: myFrame)
// Don't forget to handle height of `myCustomView`
alert.customView = myCustomView
```

CDAlertView types:

```swift
public enum CDAlertViewType {
    case error, warning, success, notification, alarm, noImage, custom(image:UIImage)
}
```

## Initialization

### Advanced Alert Initialization
To use it with your custom icon, initialize without type (or with .empty) and set your icon and background color:

```swift
let alert = CDAlertView(title: "Awesome Title", message: "Well explained message!", type: .custom(image: UIImage(named:"YourAwesomeImage")))
alert.circleFillColor = UIColor.yourAmazingColor
```

### Hide Alert with your animation
```swift
let alert = CDAlertView(title: "Awesome Title", message: "Well explained message!", type: .success)
alert.hideAnimations = { (center, transform, alpha) in
    transform = CGAffineTransform(scaleX: 3, y: 3)
    alpha = 0
}
alert.hideAnimationDuration = 0.88
alert.show()
```

### Hide Alert with timer
```swift
let alert = CDAlertView(title: "Awesome Title", message: "Well explained message!", type: .success)
alert.autoHideTime = 4.5 // This will hide alert box after 4.5 seconds
```

### List of Available CDAlertView Options

`titleTextColor: UIColor` -> Sets title's text color

`messageTextColor: UIColor` -> Sets message's text color

`titleFont: UIFont` -> Sets title's font

`messageFont: UIFont` -> Sets message's font

`isHeaderIconFilled: Bool` -> Chooses filled icons instead of outline ones. Default is `false`.

`alertBackgroundColor: UIColor` -> Sets popup's background color.

`popupWidth: CGFloat` -> Width of the popup view

`hasRoundedCorners: Bool` -> Apply rounded corners to alert view. Default is `true`.

`hasShadow: Bool` -> Apply shadows around the popup. Defualt is `true`.

`circleFillColor: UIColor` -> Sets background color of header icon. (Color of circle area)

`isActionButtonsVertical: Bool` -> Alignes action buttons vertical. Default is `false`. Maximum number of horizontal buttons is 3.

`hideAnimationDuration: TimeInterval` -> Sets the animation duration of hide animation

`hideAnimations: CDAlertAnimationBlock` -> Sets the hiding animations depending on the `center`, `transform` and `alpha` values. You can create your animations by changing these values for alert popup.

If you enabled text field with setting `isTextFieldHidden` property to `false`, following properties will be available also:

`textFieldFont: UIFont` -> Font of textField's text

`textFieldIsSecureTextEntry: Bool` -> Sets the `isSecureTextEntry` property of `UITextField`

`textFieldReturnKeyType: UIReturnKeyType` -> Sets the `returnKeyType` property of `UITextField`

`textFieldTextAlignment: NSTextAlignment` -> Sets the `textAlignment` property of `UITextField`. Default is `.left`.

`textFieldPlaceholderText: String?` -> Sets the placeholder text for `UITextField`.

`textFieldAutocapitalizationType: UITextAutocapitalizationType` -> Sets the `autocapitalizationType` property of `UITextField`. Default is `.none`.

`textFieldBackgroundColor: UIColor` -> Sets `UITextField`'s background color.

`textFieldTintColor: UIColor` -> Sets `UITextField`'s tint color.

`textFieldText: String?` -> Sets & gets `UITextField`'s text.

`textFieldHeight: CGFloat` -> Sets the height of `UITextField`.

`textFieldDelegate: UITextViewDelegate?` -> Sets the delegate of `UITextField`. Default delegate is `CDAlertView`. If you overwrite this, you're responsible for resigning the `UITextField`.

`autoHideTime: TimeInterval?` -> Sets the time interval for dismiss time. Default is `nil`.

### Advanced action initialization:

`font`, `textColor`, `backgroundColor`, `handler` are all optional and has default parameter values. You can initilize with them or set them after initialization.

```swift
let action = CDAlertViewAction(title: "Action Title", font: UIFont.yourCustomFont, textColor: UIColor.yourTextColor, backgroundColor: UIColor.yourBackgroundColor, handler: { action in })
alertView.addAction(action)
```

**NOTE:** Aligning buttons vertical and horizontal is possible. But using more than 3 buttons in horizontal placement is not possible.

### List of CDAlertViewAction Options

`buttonTitle: String` -> Set's the action button title

`buttonTextColor: UIColor` -> Sets the action button title color. Default value is RGB(27,169,225).

`buttonFont: UIFont` -> Sets the action button title font. Default value is `UIFont.systemFont(ofSize: 17)`.

`buttonBackgroundColor: UIColor` -> Sets the background color of action button. If not set, it uses `alertBackgroundColor` of CDAlertView.

### List of available methods

`textFieldBecomeFirstResponder()` -> Calls the `becomeFirstResponder()` method of `textField` if  `alert.isTextFieldHidden` set to `true`. Otherwise, does nothing.

`textFieldResignFirstResponder()` -> Calls the `resignFirstResponder()` method of `textField` if  `alert.isTextFieldHidden` set to `true`. Otherwise, does nothing.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

**This library supports Swift 4. Use `0.6.1` or older versions for Swift 3.1 support.**

### Using [CocoaPods](http://cocoapods.org)

CDAlertView is available through CocoaPods. To install it, simply add the following line to your `Podfile`:

```ruby
pod "CDAlertView"
```

### Using [Carthage](https://github.com/Carthage/Carthage)

CDAlertView is available through Carthage. To install it, simply add the following line to your `Cartfile`:

```
github "candostdagdeviren/CDAlertView"
```

## Requirements

* Xcode 9
* Swift 4
* iOS 9.0+

### Icons

Thanks to [Icons8](https://icons8.com/) for beautiful icons.

## License

CDAlertView is available under the MIT license. See the LICENSE file for more info.
