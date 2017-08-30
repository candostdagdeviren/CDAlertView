//
//  LayoutConstraintsExtension.swift
//  Pods
//
//  Created by Candost Dagdeviren on 01/11/2016.
//
//

import Foundation

internal extension UIView {
    func cd_alignToTop(of view: UIView, margin: CGFloat, multiplier: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .top,
                                                         multiplier: multiplier,
                                                         constant: margin))
    }

    func cd_alignTopToParent(with margin: CGFloat) {
        cd_alignToTop(of: self.superview!, margin: margin, multiplier: 1)
    }

    func cd_alignBottomToParent(with margin: CGFloat) {
        cd_alignToBottom(of: self.superview!, margin: margin)
    }

    func cd_alignToBottom(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: -margin))
    }

    func cd_alignLeftToParent(with margin: CGFloat) {
        cd_alignToLeft(of: self.superview!, margin: margin)
    }

    func cd_alignToLeft(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .left,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .left,
                                                         multiplier: 1,
                                                         constant: margin))
    }

    func cd_alignRightToParent(with margin: CGFloat) {
        cd_alignToRight(of: self.superview!, margin: margin)
    }

    func cd_alignToRight(of view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .right,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .right,
                                                         multiplier: 1,
                                                         constant: -margin))
    }

    func cd_alignToParent(with margin: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        cd_alignTopToParent(with: margin)
        cd_alignLeftToParent(with: margin)
        cd_alignRightToParent(with: margin)
        cd_alignBottomToParent(with: margin)
    }

    func cd_setHeight(_ height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: height))
    }

    func cd_setMaxHeight(_ height: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .height,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: height))
    }

    func cd_setWidth(_ width: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: self,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: width))
    }

    func cd_centerHorizontally() {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerX,
                                                         relatedBy: .equal,
                                                         toItem: self.superview,
                                                         attribute: .centerX,
                                                         multiplier: 1,
                                                         constant: 0))
    }

    func cd_centerVertically() {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .centerY,
                                                         relatedBy: .equal,
                                                         toItem: self.superview,
                                                         attribute: .centerY,
                                                         multiplier: 1,
                                                         constant: 0))
    }

    func cd_place(below view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .top,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .bottom,
                                                         multiplier: 1,
                                                         constant: margin))
    }

    func cd_place(above view: UIView, margin: CGFloat) {
        self.superview!.addConstraint(NSLayoutConstraint(item: self,
                                                         attribute: .bottom,
                                                         relatedBy: .equal,
                                                         toItem: view,
                                                         attribute: .top,
                                                         multiplier: 1,
                                                         constant: margin))
    }
}
