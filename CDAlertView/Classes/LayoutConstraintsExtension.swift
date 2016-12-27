//
//  LayoutConstraintsExtension.swift
//  Pods
//
//  Created by Candost Dagdeviren on 01/11/2016.
//
//

import Foundation

internal extension UIView {
    func alignToTop(of view: UIView, margin: CGFloat, multiplier: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .top,
                                                         multiplier: multiplier,
                                                         constant: margin))
    }

    func alignTopToParent(with margin: CGFloat) {
        alignToTop(of: self.superview!, margin: margin, multiplier: 1)
    }

    func alignBottomToParent(with margin: CGFloat) {
        alignToBottom(of: self.superview!, margin: margin)
    }

    func alignToBottom(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: -margin))
    }

    func alignLeftToParent(with margin: CGFloat) {
        alignToLeft(of: self.superview!, margin: margin)
    }

    func alignToLeft(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .left,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .left,
                                                         multiplier: 1,
                                                         constant: margin))
    }

    func alignRightToParent(with margin: CGFloat) {
        alignToRight(of: self.superview!, margin: margin)
    }

    func alignToRight(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .right,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .right,
                                                         multiplier: 1,
                                                         constant: -margin))
    }

    func alignToParent(with margin: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        alignTopToParent(with: margin)
        alignLeftToParent(with: margin)
        alignRightToParent(with: margin)
        alignBottomToParent(with: margin)
    }

    func setHeight(_ height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: height))
    }

    func setMaxHeight(_ height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: height))
    }

    func setWidth(_ width: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: width))
    }

    func centerHorizontally() {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: self.superview,
                                                         attribute: .centerX,
                                                         multiplier: 1,
                                                         constant: 0))
    }

    func centerVertically() {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: self.superview,
                                                         attribute: .centerY,
                                                         multiplier: 1,
                                                         constant: 0))
    }

    func place(below view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: margin))
    }

    func place(above view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .top,
                                                         multiplier: 1,
                                                         constant: margin))
    }
}
