//
//  CDAlertHeaderView.swift
//  CDAlertView
//
//  Created by Candost Dagdeviren on 10/30/2016.
//  Copyright (c) 2016 Candost Dagdeviren. All rights reserved.
//

import Foundation

internal class CDAlertHeaderView: UIView {

    // MARK: Properties
    
    internal var circleFillColor: UIColor? {
        didSet {
            if let cfc = circleFillColor {
                fillColor = cfc
            }
        }
    }
    internal var isIconFilled: Bool = false
    internal var alertBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9)
    internal var hasShadow: Bool = true
    internal var hasRoundCorners = true
    private var fillColor: UIColor!
    private var type: CDAlertViewType?
    private var imageView: UIImageView?
    
    convenience init(type: CDAlertViewType?, isIconFilled: Bool) {
        self.init(frame: .zero)
        self.type = type
        self.isIconFilled = isIconFilled
        backgroundColor = UIColor.clear
        fillColor = type?.fillColor ?? UIColor.white.withAlphaComponent(0.9)
        imageView = createImageView()
    }
    
    // MARK: UIView
    
    override func draw(_ rect: CGRect) {
        var cornerRadii = CGSize(width: 8, height: 8)
        if hasRoundCorners == false {
            cornerRadii = CGSize(width: 0, height: 0)
        }
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 16, width: rect.size.width, height: rect.size.height-16),
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: cornerRadii)
        alertBackgroundColor.setFill()
        path.fill()

        if type?.hasImage() == true {
            let curve = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2, y: 28),
                                     radius: 28,
                                     startAngle:6.84 * CGFloat.pi / 6,
                                     endAngle: 11.155 * CGFloat.pi / 6,
                                     clockwise: true)
            alertBackgroundColor.setFill()
            curve.fill()
        }

        let innerCircle = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2, y: 28),
                                       radius: 24,
                                       startAngle:0,
                                       endAngle: 2 * CGFloat.pi,
                                       clockwise: true)
        fillColor.setFill()
        innerCircle.fill()

        if hasShadow {
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
            
            self.setShadow(withPath: shadowPath)
        }
    }
    
    // MARK: Private

    private func createImageView() -> UIImageView? {
        guard let type = type else { return nil }
        
        let imageView = UIImageView(frame: .zero)
        imageView.image = type.image(isIconFilled: self.isIconFilled)
        imageView.contentMode = .center
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.cd_centerHorizontally()

        imageView.cd_alignToTop(of: self, margin: 12, multiplier: 1)
        imageView.cd_setHeight(32)
        imageView.cd_setWidth(32)
        
        return imageView
    }
}
