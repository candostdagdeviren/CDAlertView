//
//  LayoutConstraintsExtension.swift
//  Pods
//
//  Created by Candost Dagdeviren on 01/11/2016.
//
//

import Foundation

internal extension UIView {
    public func alignToTop(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                  attribute: .top,
                                  relatedBy: .equal,
                                  toItem: view,
                                  attribute: .top,
                                  multiplier: 1,
                                  constant: margin))
    }

    public func alignTopToParent(with margin: CGFloat) {
        alignToTop(of: self.superview!, margin: margin)
    }

    public func alignBottomToParent(with margin: CGFloat) {
        alignToBottom(of: self.superview!, margin: margin)
    }

    public func alignToBottom(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: view,
                                                        attribute: .bottom,
                                                        multiplier: 1,
                                                        constant: -margin))
    }

    public func alignLeftToParent(with margin: CGFloat) {
        alignToLeft(of: self.superview!, margin: margin)
    }

    public func alignToLeft(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .left,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .left,
                                                         multiplier: 1,
                                                         constant: margin))
    }

    public func alignRightToParent(with margin: CGFloat) {
        alignToRight(of: self.superview!, margin: margin)
    }

    public func alignToRight(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .right,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .right,
                                                         multiplier: 1,
                                                         constant: -margin))
    }

    public func alignToParent(with margin: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        alignTopToParent(with: margin)
        alignLeftToParent(with: margin)
        alignRightToParent(with: margin)
        alignBottomToParent(with: margin)
    }

    public func setHeight(_ height: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .height,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1,
                                                         constant: height))
    }

    public func setMaxHeight(_ height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .height,
                                                         relatedBy: .lessThanOrEqual,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1,
                                                         constant: height))
    }

    public func setWidth(_ width: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .width,
                                                         relatedBy: .equal,
                                                         toItem: nil,
                                                         attribute: .notAnAttribute,
                                                         multiplier: 1,
                                                         constant: width))
    }

    public func centerHorizontally() {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: self.superview,
                                                         attribute: .centerX,
                                                         multiplier: 1,
                                                         constant: 0))
    }

    public func centerVertically() {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: self.superview,
                                                         attribute: .centerY,
                                                         multiplier: 1,
                                                         constant: 0))
    }

    public func place(below view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: margin))
    }

    public func place(above view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .top,
                                                         multiplier: 1,
                                                         constant: margin))
    }
}
