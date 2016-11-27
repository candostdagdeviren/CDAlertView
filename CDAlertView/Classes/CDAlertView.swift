//
//  CDAlertView.swift
//  CDAlertView
//
//  Created by Candost Dagdeviren on 10/30/2016.
//  Copyright (c) 2016 Candost Dagdeviren. All rights reserved.
//

import Foundation

public enum CDAlertViewType {
    case error, warning, success, notification, alarm, custom(image: UIImage)
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

    private var handlerBlock: ((CDAlertViewAction) -> Swift.Void)?

    public convenience init(title: String?,
                            font: UIFont? = UIFont.systemFont(ofSize: 17),
                            textColor: UIColor? = UIColor(red: 27/255, green: 169/255, blue: 225/255, alpha: 1),
                            backgroundColor: UIColor? = nil,
                            handler: ((CDAlertViewAction) -> Swift.Void)? = nil) {
        self.init()
        buttonTitle = title
        buttonTextColor = textColor
        buttonFont = font
        buttonBackgroundColor = backgroundColor
        handlerBlock = handler
    }

    func didTap() {
        if let handler = handlerBlock {
            handler(self)
        }
        self.delegate?.didTap(action: self)
    }
}

open class CDAlertView: UIView {

    public var actionSeparatorColor: UIColor = UIColor(red: 50/255,
                                                        green: 51/255,
                                                        blue: 53/255,
                                                        alpha: 0.12)
    public var titleTextColor: UIColor = UIColor(red: 50/255,
                                                 green: 51/255,
                                                 blue: 53/255,
                                                 alpha: 1)

    public var messageTextColor: UIColor = UIColor(red: 50/255,
                                                 green: 51/255,
                                                 blue: 53/255,
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

    public var isActionButtonsVertical: Bool = false

    public var hasShadow: Bool = true

    public var isHeaderIconFilled: Bool = false

    public var alertBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9)

    public var circleFillColor: UIColor? = nil

    public var popupWidth: CGFloat = 255.0

    private struct CDAlertViewConstants {
        let headerHeight: CGFloat = 56
        let activeVelocity: CGFloat = 150
        let minVelocity: CGFloat = 300
        let separatorThickness: CGFloat = 1.0/UIScreen.main.scale
    }

    private var buttonsHeight: CGFloat {
        get {
            return self.actions.count > 0 ? 44.0 : 0
        }
    }

    private var popupViewInitialFrame: CGRect!
    private let constants = CDAlertViewConstants()
    private var backgroundView: UIView = UIView(frame: .zero)
    private var popupView: UIView = UIView(frame: .zero)
    private var coverView: UIView = UIView(frame: .zero)
    private var completionBlock: ((CDAlertView) -> Swift.Void)?
    private var contentStackView: UIStackView = UIStackView(frame: .zero)
    private var buttonContainer: UIStackView = UIStackView(frame: .zero)
    private var headerView: CDAlertHeaderView!
    private var buttonView: UIView = UIView(frame: .zero)
    private var titleLabel: UILabel = UILabel(frame: .zero)
    private var messageLabel: UILabel = UILabel(frame: .zero)
    private var type: CDAlertViewType!
    private lazy var actions: [CDAlertViewAction] = [CDAlertViewAction]()

    public convenience init(title: String?,
                            message: String?,
                            type: CDAlertViewType? = nil) {
        self.init(frame: .zero)

        self.type = type
        backgroundColor = UIColor(red: 50/255, green: 51/255, blue: 53/255, alpha: 0.4)
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
            path.addLine(to: CGPoint(x: 0, y: constants.headerHeight))
            path.addLine(to: CGPoint(x: popupView.bounds.size.width,
                                     y: CGFloat(constants.headerHeight-5)))
            path.addLine(to: CGPoint(x: popupView.bounds.size.width,
                                     y: popupView.bounds.size.height))
            path.close()
            popupView.layer.shadowPath = path.cgPath
        }
    }

    public func show(_ completion:((CDAlertView) -> Swift.Void)? = nil) {
        UIApplication.shared.keyWindow?.addSubview(self)
        alignToParent(with: 0)
        addSubview(backgroundView)
        backgroundView.alignToParent(with: 0)
        if !isActionButtonsVertical && actions.count > 3 {
            debugPrint("CDAlertView: You can't use more than 3 actions in horizontal mode. If you need more than 3 buttons, consider using vertical alignment for buttons. Setting vertical alignments for buttons is available via isActionButtonsVertical property of AlertView")
            actions.removeSubrange(3..<actions.count)
        }
        createViews()
        loadActionButtons()
        popupViewInitialFrame = popupView.frame
        completionBlock = completion
    }

    public func hide(isPopupAnimated: Bool) {
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            if isPopupAnimated {
                var offScreenCenter = self.popupView.center
                offScreenCenter.y += self.constants.minVelocity * 3
                self.popupView.center = offScreenCenter
            }
            self.transform = CGAffineTransform(translationX: 0.5, y: 0.5)
            self.alpha = 0
            }, completion: { (finished) in
                if finished {
                    self.removeFromSuperview()
                    if let completion = self.completionBlock {
                        completion(self)
                    }
                }
        })
    }

    public func add(action: CDAlertViewAction) {
        actions.append(action)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if actions.count == 0 {
            touches.forEach { (touch) in
                if touch.view == self.backgroundView {
                    self.hide(isPopupAnimated: true)
                }
            }
        }
    }

    func popupMoved(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: backgroundView)
        UIView.animate(withDuration: 0, animations: {
            self.popupView.center = location
        })

        if recognizer.state == .ended {
            let location = recognizer.location(in: backgroundView)
            let origin = CGPoint(x: backgroundView.center.x - popupViewInitialFrame.size.width/2,
                                 y: backgroundView.center.y - popupViewInitialFrame.size.height/2)
            let velocity = recognizer.velocity(in: backgroundView)
            if !CGRect(origin: origin, size: popupViewInitialFrame.size).contains(location) ||
                (velocity.x > constants.activeVelocity || velocity.y > constants.activeVelocity) {
                UIView.animate(withDuration: 1, animations: {
                    self.popupView.center = self.calculatePopupViewOffScreenCenter(from: velocity)
                    self.hide(isPopupAnimated: false)
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.popupView.center = self.backgroundView.center
                })
            }
        } else if recognizer.state == .cancelled {
            UIView.animate(withDuration: 0, animations: {
                self.popupView.center = self.backgroundView.center
            })
        }
    }

    // MARK: Private

    private func calculatePopupViewOffScreenCenter(from velocity: CGPoint) -> CGPoint {
        var velocityX = velocity.x
        var velocityY = velocity.y
        var offScreenCenter = popupView.center

        velocityX = velocityX >= 0 ?
            (velocityX < constants.minVelocity ? 0 : velocityX) :
            (velocityX > -constants.minVelocity ? 0 : velocityX)

        velocityY = velocityY >= 0 ?
            (velocityY < constants.minVelocity ? constants.minVelocity : velocityY) :
            (velocityY > -constants.minVelocity ? -constants.minVelocity : velocityY)

        offScreenCenter.x += velocityX
        offScreenCenter.y += velocityY

        return offScreenCenter
    }



    private func roundBottomOfCoverView() {
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

        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.centerHorizontally()
        popupView.centerVertically()
        popupView.setWidth(popupWidth)
        popupView.setMaxHeight(430)
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
        headerView.hasShadow = hasShadow
        headerView.alertBackgroundColor = alertBackgroundColor
        headerView.circleFillColor = circleFillColor
        popupView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.alignTopToParent(with: 0)
        headerView.alignLeftToParent(with: 0)
        headerView.alignRightToParent(with: 0)
        headerView.setHeight(constants.headerHeight)
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
        let roundLayer = CAShapeLayer()
        roundLayer.path = roundCornersPath.cgPath
        buttonView.layer.mask = roundLayer
        popupView.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.alignBottomToParent(with: 0)
        buttonView.alignLeftToParent(with: 0)
        buttonView.alignRightToParent(with: 0)
        if actions.count == 0 {
            buttonView.setHeight(0)
        } else {

            let backgroundColoredView = UIView(frame: .zero)
            backgroundColoredView.backgroundColor = actionSeparatorColor
            buttonView.addSubview(backgroundColoredView)
            backgroundColoredView.alignToParent(with: 0)

            buttonContainer.spacing = constants.separatorThickness
            if isActionButtonsVertical {
                buttonContainer.axis = .vertical
            } else {
                buttonContainer.axis = .horizontal
            }
            buttonView.setHeight(height)
            buttonContainer.translatesAutoresizingMaskIntoConstraints = false
            backgroundColoredView.addSubview(buttonContainer)
            buttonContainer.alignTopToParent(with: constants.separatorThickness)
            buttonContainer.alignBottomToParent(with: 0)
            buttonContainer.alignLeftToParent(with: 0)
            buttonContainer.alignRightToParent(with: 0)
        }
    }

    private func createStackView() {
        coverView.backgroundColor = alertBackgroundColor
        popupView.addSubview(coverView)
        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.alignLeftToParent(with: 0)
        coverView.alignRightToParent(with: 0)
        coverView.place(below: headerView, margin: 0)
        coverView.place(above: buttonView, margin: 0)
        contentStackView.distribution = .equalSpacing
        contentStackView.axis = .vertical
        contentStackView.spacing = 8
        coverView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.alignTopToParent(with: 0)
        contentStackView.alignBottomToParent(with: 16)
        contentStackView.alignRightToParent(with: 16)
        contentStackView.alignLeftToParent(with: 16)
    }

    private func createTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.setMaxHeight(100)
        titleLabel.textColor = titleTextColor
        titleLabel.font = titleFont
        contentStackView.addArrangedSubview(titleLabel)
    }

    private func createMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.textColor = messageTextColor
        messageLabel.setMaxHeight(290)
        messageLabel.font = messageFont
        contentStackView.addArrangedSubview(messageLabel)
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
                button.setWidth(buttonContainer.frame.size.width)
            } else {
                button.setWidth((buttonContainer.frame.size.width-CGFloat(actions.count-1) * constants.separatorThickness)/CGFloat(actions.count))
            }

            button.setHeight(CGFloat(buttonsHeight))
        }
    }
}

extension CDAlertView: CDAlertViewActionDelegate {
    internal func didTap(action: CDAlertViewAction) {
        self.hide(isPopupAnimated: true)
    }
}
