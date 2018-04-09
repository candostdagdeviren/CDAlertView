//
//  CDAlertView.swift
//  CDAlertView
//
//  Created by Candost Dagdeviren on 10/30/2016.
//  Copyright (c) 2016 Candost Dagdeviren. All rights reserved.
//

import Foundation

public enum CDAlertViewType {
    case error, warning, success, notification, alarm, noImage, custom(image: UIImage)
    
    // This is needed because we can't do a comparison of enums
    // if it has an associated value.
    func hasImage() -> Bool {
        switch self {
            case .noImage:
                return false
            default:
                return true
        }
    }
}

fileprivate protocol CDAlertViewActionDelegate: class {
    func didTap(action: CDAlertViewAction)
}

open class CDAlertViewAction: NSObject {
    public var buttonTitle: String?
    public var buttonTextColor: UIColor?
    public var buttonFont: UIFont?
    public var buttonBackgroundColor: UIColor?

    fileprivate weak var delegate: CDAlertViewActionDelegate?

    private var handlerBlock: ((CDAlertViewAction) -> Swift.Bool)?

    public convenience init(title: String?,
                            font: UIFont? = UIFont.systemFont(ofSize: 17),
                            textColor: UIColor? = UIColor(red: 27 / 255, green: 169 / 255, blue: 225 / 255, alpha: 1),
                            backgroundColor: UIColor? = nil,
                            handler: ((CDAlertViewAction) -> Swift.Bool)? = nil) {
        self.init()
        buttonTitle = title
        buttonTextColor = textColor
        buttonFont = font
        buttonBackgroundColor = backgroundColor
        handlerBlock = handler
    }

    @objc func didTap() {
        guard let handler = handlerBlock else {
            self.delegate?.didTap(action: self)
            return
        }
        if handler(self) == false {
            return
        }
        self.delegate?.didTap(action: self)
    }
}

open class CDAlertView: UIView {

    public var actionSeparatorColor: UIColor = UIColor(red: 50 / 255,
                                                       green: 51 / 255,
                                                       blue: 53 / 255,
                                                       alpha: 0.12)
    public var titleTextColor: UIColor = UIColor(red: 50 / 255,
                                                 green: 51 / 255,
                                                 blue: 53 / 255,
                                                 alpha: 1)

    public var messageTextColor: UIColor = UIColor(red: 50 / 255,
                                                   green: 51 / 255,
                                                   blue: 53 / 255,
                                                   alpha: 1)

    public var textFieldTextColor: UIColor = UIColor(red: 50 / 255,
                                                     green: 51 / 255,
                                                     blue: 53 / 255,
                                                     alpha: 1)

    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17) {
        didSet {
            titleLabel.font = titleFont
        }
    }

    public var messageFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            messageLabel.font = messageFont
        }
    }

    public var textFieldFont: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            textField.font = textFieldFont
        }
    }

    public var textFieldReturnKeyType: UIReturnKeyType = .default {
        didSet {
            textField.returnKeyType = textFieldReturnKeyType
        }
    }

    public var textFieldIsSecureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = textFieldIsSecureTextEntry
        }
    }

    public var textFieldTextAlignment: NSTextAlignment = .left {
        didSet {
            textField.textAlignment = textFieldTextAlignment
        }
    }

    public var textFieldPlaceholderText: String? = nil {
        didSet {
            textField.placeholder = textFieldPlaceholderText
        }
    }

    public var isTextFieldHidden: Bool = true {
        didSet {
            textField.isHidden = isTextFieldHidden

            if !isTextFieldHidden {
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
            }
        }
    }

    public var textFieldKeyboardType: UIKeyboardType = .`default` {
        didSet {
            textField.keyboardType = textFieldKeyboardType
        }
    }

    public var textFieldAutocapitalizationType: UITextAutocapitalizationType = .none {
        didSet {
            textField.autocapitalizationType = textFieldAutocapitalizationType
        }
    }

    public var textFieldAutocorrectionType: UITextAutocorrectionType = .default {
        didSet {
            textField.autocorrectionType = textFieldAutocorrectionType
        }
    }

    public var textFieldBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9) {
        didSet {
            textField.backgroundColor = textFieldBackgroundColor
        }
    }

    public var textFieldTintColor: UIColor = UIColor.white.withAlphaComponent(0.9) {
        didSet {
            textField.tintColor = textFieldTintColor
        }
    }

    public var textFieldText: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }

    public weak var textFieldDelegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = textFieldDelegate
        }
    }

    public var hasRoundCorners = true

    public var customView: UIView?

    public var hideAnimations: CDAlertAnimationBlock?

    public var hideAnimationDuration: TimeInterval = 0.5

    public var autoHideTime: TimeInterval? = nil
    
    public var textFieldHeight: CGFloat = 35.0

    public var isActionButtonsVertical: Bool = false

    public var hasShadow: Bool = true

    public var isHeaderIconFilled: Bool = false

    public var alertBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9)

    public var circleFillColor: UIColor? = nil

    public var popupWidth: CGFloat = 255.0

    public typealias CDAlertAnimationBlock = ((_ center: inout CGPoint, _ transform: inout CGAffineTransform, _ alpha: inout CGFloat) -> Void)?

    fileprivate var popupCenterYPositionBeforeKeyboard: CGFloat?

    fileprivate var popupView: UIView = UIView(frame: .zero)

    fileprivate var popupCenter: CGPoint {
        get {
            return popupView.center
        }
        set {
            popupView.center = newValue
        }
    }

    fileprivate var popupTransform: CGAffineTransform {
        get {
            return popupView.transform
        }
        set {
            popupView.transform = newValue
        }
    }

    fileprivate var popupAlpha: CGFloat {
        get {
            return popupView.alpha
        }
        set {
            popupView.alpha = newValue
        }
    }

    private struct CDAlertViewConstants {
        let headerHeight: CGFloat = 56
        let headerHeightWithoutCircle: CGFloat = 30
        let activeVelocity: CGFloat = 150
        let minVelocity: CGFloat = 300
        let separatorThickness: CGFloat = 1.0 / UIScreen.main.scale
    }

    private var buttonsHeight: CGFloat {
        get {
            return self.actions.count > 0 ? 44.0 : 0
        }
    }

    private var popupViewInitialFrame: CGRect!
    private let constants = CDAlertViewConstants()
    private var backgroundView: UIView = UIView(frame: .zero)
    private var coverView: UIView = UIView(frame: .zero)
    private var completionBlock: ((CDAlertView) -> Swift.Void)?
    private var contentStackView: UIStackView = UIStackView(frame: .zero)
    private var buttonContainer: UIStackView = UIStackView(frame: .zero)
    private var headerView: CDAlertHeaderView!
    private var buttonView: UIView = UIView(frame: .zero)
    private var titleLabel: UILabel = UILabel(frame: .zero)
    private var messageLabel: UILabel = UILabel(frame: .zero)
    private var textField: UITextField = UITextField(frame: .zero)
    private var type: CDAlertViewType!
    weak private var hideTimer: Timer!
    public var headerHeight: CGFloat = CDAlertViewConstants().headerHeight
    
    private lazy var actions: [CDAlertViewAction] = [CDAlertViewAction]()

    public convenience init(title: String?,
                            message: String?,
                            type: CDAlertViewType? = nil) {
        self.init(frame: .zero)

        self.type = type
        backgroundColor = UIColor(red: 50 / 255, green: 51 / 255, blue: 53 / 255, alpha: 0.4)
        if let t = title {
            titleLabel.text = t
        }

        if let m = message {
            messageLabel.text = m
        }

        self.type = type
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if hasShadow {
            popupView.layer.shadowColor = UIColor.black.cgColor
            popupView.layer.shadowOpacity = 0.2
            popupView.layer.shadowRadius = 4
            popupView.layer.shadowOffset = CGSize.zero
            popupView.layer.masksToBounds = false
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: popupView.bounds.size.height))
            path.addLine(to: CGPoint(x: 0, y: headerHeight))
            path.addLine(to: CGPoint(x: popupView.bounds.size.width,
                                     y: CGFloat(headerHeight - 5)))
            path.addLine(to: CGPoint(x: popupView.bounds.size.width,
                                     y: popupView.bounds.size.height))
            path.close()
            popupView.layer.shadowPath = path.cgPath
        }
    }

    public func show(_ completion: ((CDAlertView) -> Void)? = nil) {

        UIApplication.shared.keyWindow?.addSubview(self)
        cd_alignToParent(with: 0)
        addSubview(backgroundView)
        backgroundView.cd_alignToParent(with: 0)
        if !isActionButtonsVertical && actions.count > 3 {
            debugPrint("CDAlertView: You can't use more than 3 actions in horizontal mode. If you need more than 3 buttons, consider using vertical alignment for buttons. Setting vertical alignments for buttons is available via isActionButtonsVertical property of AlertView")
            actions.removeSubrange(3..<actions.count)
        }
        createViews()
        loadActionButtons()
        popupViewInitialFrame = popupView.frame

        completionBlock = completion
        
        if let autoHideTime = self.autoHideTime {
            hideTimer = Timer.scheduledTimer(timeInterval: autoHideTime, target: self, selector: #selector(self.hideTimeOut(_:)), userInfo: nil, repeats: false)
        }
    }

    @objc func hideTimeOut(_ timer:Timer) {
        
        self.hide(animations: self.hideAnimations, isPopupAnimated: true)
    }
    
    // Instead of defining default `nil` parameter for `hide(animations: CDAlertAnimationBlock?, isPopupAnimated:Bool)` method
    // we define this method for Objective-C compatibility.
    // CDAlertAnimationBlock is not supported in Objective-C
    public func hide(isPopupAnimated: Bool) {
        hide(animations: nil, isPopupAnimated: isPopupAnimated)
    }

    public func hide(animations: CDAlertAnimationBlock?,
                     isPopupAnimated: Bool) {
        
        self.hideTimer?.invalidate()
        self.hideTimer = nil
        
        if !isTextFieldHidden {
            textField.resignFirstResponder()
            NotificationCenter.default.removeObserver(self)
        }

        UIView.animate(withDuration: hideAnimationDuration,
                       animations: { [unowned self] in
            if isPopupAnimated {
                if let animations = animations {
                    animations?(&self.popupCenter, &self.popupTransform, &self.popupAlpha)
                } else {
                    var offScreenCenter = self.popupView.center
                    offScreenCenter.y += self.constants.minVelocity * 3
                    self.popupView.center = offScreenCenter
                    self.alpha = 0
                }
            }
        },
                       completion: { (finished) in
            self.removeFromSuperview()
            if let completion = self.completionBlock {
                completion(self)
            }
        })

    }

    public func add(action: CDAlertViewAction) {
        actions.append(action)
    }

    public func textFieldBecomeFirstResponder() {
        if !isTextFieldHidden {
            textField.becomeFirstResponder()
        }
    }

    public func textFieldResignFirstResponder() {
        if !isTextFieldHidden {
            textField.resignFirstResponder()
        }
    }

    open override func touchesEnded(_ touches: Set<UITouch>,
                                    with event: UIEvent?) {
        if actions.count == 0 {
            touches.forEach { (touch) in
                if touch.view == self.backgroundView {
                    self.hide(animations: self.hideAnimations, isPopupAnimated: true)
                }
            }
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        guard let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard let coverViewWindowCoordinates = coverView.superview?.convert(CGPoint(x: 0, y: coverView.frame.maxY), to: nil) else {
            return
        }
        if coverViewWindowCoordinates.y <= (keyboardSize.minY - keyboardSize.height) {
            return
        }
        popupCenterYPositionBeforeKeyboard = popupView.center.y
        let difference = coverViewWindowCoordinates.y - (keyboardSize.minY - keyboardSize.height)
        popupView.center.y -= difference
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let initialY = self.popupCenterYPositionBeforeKeyboard else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .allowAnimatedContent, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.popupView.center.y = initialY
        })
    }

    @objc func popupMoved(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: backgroundView)
        UIView.animate(withDuration: 0, animations: {
            self.popupView.center = location
        })
        switch recognizer.state {
        case .ended:
            let location = recognizer.location(in: backgroundView)
            let origin = CGPoint(x: backgroundView.center.x - popupViewInitialFrame.size.width / 2,
                                 y: backgroundView.center.y - popupViewInitialFrame.size.height / 2)
            let velocity = recognizer.velocity(in: backgroundView)
            if !CGRect(origin: origin,
                       size: popupViewInitialFrame.size).contains(location) ||
            (velocity.x > constants.activeVelocity || velocity.y > constants.activeVelocity) {
                UIView.animate(withDuration: 1, animations: {
                    self.popupView.center = self.calculatePopupViewOffScreenCenter(from: velocity)
                    self.hide(animations: self.hideAnimations, isPopupAnimated: false)
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.popupView.center = self.backgroundView.center
                })
            }
            break
        case .cancelled:
            UIView.animate(withDuration: 0, animations: {
                self.popupView.center = self.backgroundView.center
            })
            break
        default:
            break
        }
    }

    // MARK: Private

    private func calculatePopupViewOffScreenCenter(from velocity: CGPoint) -> CGPoint {
        var velocityX = velocity.x
        var velocityY = velocity.y
        var offScreenCenter = popupView.center

        velocityX = velocityX >= 0 ?
        (velocityX < constants.minVelocity ? 0 : velocityX):
            (velocityX > -constants.minVelocity ? 0 : velocityX)

        velocityY = velocityY >= 0 ?
        (velocityY < constants.minVelocity ? constants.minVelocity : velocityY):
            (velocityY > -constants.minVelocity ? -constants.minVelocity : velocityY)

        offScreenCenter.x += velocityX
        offScreenCenter.y += velocityY

        return offScreenCenter
    }



    private func roundBottomOfCoverView() {
        guard hasRoundCorners == true else {return}
        let roundCornersPath = UIBezierPath(roundedRect: CGRect(x: 0.0,
                                                                y: 0.0,
                                                                width: popupWidth,
                                                                height: coverView.frame.size.height),
                                            byRoundingCorners: [.bottomLeft, .bottomRight],
                                            cornerRadii: CGSize(width: 8.0,
                                                                height: 8.0))
        let roundLayer = CAShapeLayer()
        roundLayer.path = roundCornersPath.cgPath
        coverView.layer.mask = roundLayer
    }

    private func createViews() {
        popupView.backgroundColor = UIColor.clear
        backgroundView.addSubview(popupView)
        createHeaderView()
        createButtonContainer()
        createStackView()
        createTitleLabel()
        createMessageLabel()

        if let customView = customView {
            createCustomView(customView)
        }

        if !isTextFieldHidden {
            createTextField()
        }

        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.cd_centerHorizontally()
        popupView.cd_centerVertically()
        popupView.cd_setWidth(popupWidth)
        popupView.cd_setMaxHeight(430)
        popupView.sizeToFit()
        popupView.layoutIfNeeded()
        if actions.count == 0 {
            roundBottomOfCoverView()

            let gestureRecognizer = UIPanGestureRecognizer(target: self,
                                                           action: #selector(popupMoved(recognizer:)))
            popupView.addGestureRecognizer(gestureRecognizer)
        }
    }

    private func createHeaderView() {
        headerView = CDAlertHeaderView(type: type, isIconFilled: isHeaderIconFilled)
        headerView.backgroundColor = UIColor.clear
        headerView.hasRoundCorners = hasRoundCorners
        headerView.alertBackgroundColor = alertBackgroundColor
        if type.hasImage() == true {
            headerView.circleFillColor = circleFillColor
            headerView.hasShadow = hasShadow
        }
        else {
            headerView.hasShadow = false
            headerView.circleFillColor = .clear
            headerHeight = constants.headerHeightWithoutCircle
        }
        popupView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.cd_alignTopToParent(with: 0)
        headerView.cd_alignLeftToParent(with: 0)
        headerView.cd_alignRightToParent(with: 0)
        headerView.cd_setHeight(headerHeight)
    }

    private func createButtonContainer() {
        var height = buttonsHeight + constants.separatorThickness
        buttonView.backgroundColor = UIColor.clear
        buttonView.layer.masksToBounds = true
        if isActionButtonsVertical {
            height = (buttonsHeight + constants.separatorThickness) * CGFloat(actions.count)
        }
        let roundCornersPath = UIBezierPath(roundedRect: CGRect(x: 0.0,
                                                                y: 0.0,
                                                                width: popupWidth,
                                                                height: height),
                                            byRoundingCorners: [.bottomLeft, .bottomRight],
                                            cornerRadii: CGSize(width: 8.0, height: 8.0))
        if hasRoundCorners == true {
            let roundLayer = CAShapeLayer()
            roundLayer.path = roundCornersPath.cgPath
            buttonView.layer.mask = roundLayer
        }
        popupView.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.cd_alignBottomToParent(with: 0)
        buttonView.cd_alignLeftToParent(with: 0)
        buttonView.cd_alignRightToParent(with: 0)
        if actions.count == 0 {
            buttonView.cd_setHeight(0)
        } else {

            let backgroundColoredView = UIView(frame: .zero)
            backgroundColoredView.backgroundColor = actionSeparatorColor
            buttonView.addSubview(backgroundColoredView)
            backgroundColoredView.cd_alignToParent(with: 0)

            buttonContainer.spacing = constants.separatorThickness
            if isActionButtonsVertical {
                buttonContainer.axis = .vertical
            } else {
                buttonContainer.axis = .horizontal
            }
            buttonView.cd_setHeight(height)
            buttonContainer.translatesAutoresizingMaskIntoConstraints = false
            backgroundColoredView.addSubview(buttonContainer)
            buttonContainer.cd_alignTopToParent(with: constants.separatorThickness)
            buttonContainer.cd_alignBottomToParent(with: 0)
            buttonContainer.cd_alignLeftToParent(with: 0)
            buttonContainer.cd_alignRightToParent(with: 0)
        }
    }

    private func createStackView() {
        coverView.backgroundColor = alertBackgroundColor
        popupView.addSubview(coverView)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.cd_alignLeftToParent(with: 0)
        coverView.cd_alignRightToParent(with: 0)
        coverView.cd_place(below: headerView, margin: 0)
        coverView.cd_place(above: buttonView, margin: 0)
        contentStackView.distribution = .equalSpacing
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        coverView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.cd_alignTopToParent(with: 0)
        contentStackView.cd_alignBottomToParent(with: 16)
        contentStackView.cd_alignRightToParent(with: 16)
        contentStackView.cd_alignLeftToParent(with: 16)
    }

    private func createTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.cd_setMaxHeight(100)
        titleLabel.textColor = titleTextColor
        titleLabel.font = titleFont
        contentStackView.addArrangedSubview(titleLabel)
    }

    private func createMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = messageTextColor
        messageLabel.cd_setMaxHeight(290)
        messageLabel.font = messageFont
        contentStackView.addArrangedSubview(messageLabel)
    }

    private func createCustomView(_ custom: UIView) {
        custom.clipsToBounds = true
        contentStackView.addArrangedSubview(custom)
    }

    private func createTextField() {
        if textFieldDelegate == nil {
            textField.delegate = self
        }

        textField.font = textFieldFont
        textField.textColor = textFieldTextColor
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = textFieldIsSecureTextEntry
        textField.returnKeyType = textFieldReturnKeyType
        textField.textAlignment = textFieldTextAlignment
        textField.borderStyle = .roundedRect
        textField.isHidden = isTextFieldHidden
        textField.placeholder = textFieldPlaceholderText
        textField.autocapitalizationType = textFieldAutocapitalizationType
        textField.cd_setHeight(textFieldHeight)
        contentStackView.addArrangedSubview(textField)
    }

    private func loadActionButtons() {
        guard actions.count != 0 else { return }
        for action in buttonContainer.arrangedSubviews {
            buttonContainer.removeArrangedSubview(action)
        }

        for action in actions {
            action.delegate = self
            let button = UIButton(type: .system)
            if let bc = action.buttonBackgroundColor {
                button.backgroundColor = bc
            } else {
                button.backgroundColor = alertBackgroundColor
            }

            button.setTitle(action.buttonTitle, for: .normal)
            button.setTitleColor(action.buttonTextColor, for: .normal)
            button.titleLabel?.font = action.buttonFont
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.addTarget(action, action: #selector(action.didTap), for: .touchUpInside)
            buttonContainer.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            if isActionButtonsVertical {
                button.cd_setWidth(buttonContainer.frame.size.width)
            } else {
                button.cd_setWidth((buttonContainer.frame.size.width - CGFloat(actions.count - 1) * constants.separatorThickness) / CGFloat(actions.count))
            }

            button.cd_setHeight(CGFloat(buttonsHeight))
        }
    }
}

extension CDAlertView: CDAlertViewActionDelegate {
    internal func didTap(action: CDAlertViewAction) {
        self.hide(animations: self.hideAnimations, isPopupAnimated: true)
    }
}

extension CDAlertView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
