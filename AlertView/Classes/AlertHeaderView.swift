//
//  AlertHeaderView.swift
//  AlertView
//
//  Created by Candost Dagdeviren on 10/30/2016.
//  Copyright (c) 2016 Candost Dagdeviren. All rights reserved.
//

import Foundation

internal class AlertHeaderView: UIView {

    private var type: AlertViewType!
    private var fillColor: UIColor!

    convenience init(type: AlertViewType) {
        self.init(frame: .zero)
        self.type = type
        backgroundColor = UIColor.clear
        let imageView = UIImageView(frame: .zero)
        imageView.tintColor = UIColor.white.withAlphaComponent(0.9)
        switch type {
        case .error:
            imageView.image = ImageHelper.loadImage(name: "error")
            fillColor = UIColor(red: 235/255, green: 61/255, blue: 65/255, alpha: 1)
        case .success:
            imageView.image = ImageHelper.loadImage(name: "check")
            fillColor = UIColor(red: 65/255, green: 158/255, blue: 57/255, alpha: 1)
        case .warning:
            imageView.image = ImageHelper.loadImage(name: "warningOutline")
            fillColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        case .notification:
            imageView.image = ImageHelper.loadImage(name: "notificationOutline")
            fillColor = UIColor(red: 27/255, green: 169/255, blue: 225/255, alpha: 1)
        }

        imageView.contentMode = .center
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerHorizontally()
        imageView.alignToTop(of: self, margin: 16, multiplier: 1)
        imageView.setHeight(24)
        imageView.setWidth(24)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 16, width: rect.size.width, height: rect.size.height-16),
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 8, height: 8))
        UIColor.white.withAlphaComponent(0.9).setFill()
        path.fill()

        let curve = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2, y: 28),
                                 radius: 28,
                                 startAngle:6.84 * CGFloat.pi / 6,
                                 endAngle: 11.155 * CGFloat.pi / 6,
                                 clockwise: true)
        UIColor.white.withAlphaComponent(0.9).setFill()
        curve.fill()

        let innerCircle = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2, y: 28),
                                       radius: 24,
                                       startAngle:0,
                                       endAngle: 2 * CGFloat.pi,
                                       clockwise: true)
        fillColor.setFill()
        innerCircle.fill()

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize.zero
        layer.masksToBounds = false
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0.0, y: rect.size.height))
        shadowPath.addLine(to: CGPoint(x: 0, y: 16))
        shadowPath.addLine(to: CGPoint(x: (rect.size.width/2)-15, y: 16))
        shadowPath.addArc(withCenter: CGPoint(x: rect.size.width/2, y: 28),
                          radius: 28,
                          startAngle: 6.84 * CGFloat.pi / 6,
                          endAngle: 11.155 * CGFloat.pi / 6,
                          clockwise: true)
        shadowPath.addLine(to: CGPoint(x: rect.size.width, y: 16))
        shadowPath.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        shadowPath.addLine(to: CGPoint(x: rect.size.width-10, y: rect.size.height-5))
        shadowPath.addLine(to: CGPoint(x: 10, y: rect.size.height-5))
        shadowPath.close()
        layer.shadowPath = shadowPath.cgPath
    }
}
