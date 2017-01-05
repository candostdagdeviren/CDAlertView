![CDAlertView: Highly customizable alert popup](https://cloud.githubusercontent.com/assets/1971963/20237496/34d3081c-a8d4-11e6-8907-80b4c248dce0.png)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
<a href="https://cocoapods.org/pods/CDAlertView"><img src="https://img.shields.io/badge/pod-0.3.1-blue.svg" alt="CocoaPods compatible" /></a>
[![CI Status](http://img.shields.io/travis/candostdagdeviren/CDAlertView.svg?style=flat)](https://travis-ci.org/candostdagdeviren/CDAlertView/)
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-4BC51D.svg?style=flat" alt="Swift 3 compatible" /></a>
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://raw.githubusercontent.com/candostdagdeviren/CDAlertView/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>

CDAlertView is highly customizable alert popup written in Swift 3. Usage is similar to `UIAlertController`.

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

CDAlertView types:

```swift
public enum CDAlertViewType {
    case error, warning, success, notification, alarm, custom(image:UIImage)
}
```

## Initialization

### Advanced Alert Initialization
To use it with your custom icon, initialize without type (or with .empty) and set your icon and background color:

```swift
let alert = CDAlertView(title: "Awesome Title", message: "Well explained message!", type: .custom(image: UIImage(named:"YourAwesomeImage")))
alert.circleFillColor = UIColor.yourAmazingColor
```

### List of Available CDAlertView Options

`titleTextColor: UIColor` -> Sets title's text color

`messageTextColor: UIColor` -> Sets message's text color

`titleFont: UIFont` -> Sets title's font

`messageFont: UIFont` -> Sets message's font

`isHeaderIconFilled: Bool` -> Chooses filled icons instead of outline ones. Default is `false`.

`alertBackgroundColor: UIColor` -> Sets popup's background color.

`popupWidth: CGFloat` -> Width of the popup view

`hasShadow: Bool` -> Apply shadows around the popup. Defualt is `true`.

`circleFillColor: UIColor` -> Sets background color of header icon. (Color of circle area)

`isActionButtonsVertical: Bool` -> Alignes action buttons vertical. Default is `false`. Maximum number of horizontal buttons is 3.

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

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

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

* Xcode 8
* iOS 9.0+

## Author

Candost Dagdeviren, candostdagdeviren@gmail.com

### Icons

Thanks to [Icons8](https://icons8.com/) for beautiful icons.

## License

CDAlertView is available under the MIT license. See the LICENSE file for more info.
