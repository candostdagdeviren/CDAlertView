//
//  CDAlertViewType.swift
//  CDAlertView
//
//  Created by Luca Pizzini on 03/12/20.
//  Copyright © 2020 Candost Dagdeviren. All rights reserved.
//

import Foundation

public enum CDAlertViewType
{
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
    
    var fillColor: UIColor? {
        switch self {
        case .error:
            return UIColor(red: 235/255, green: 61/255, blue: 65/255, alpha: 1)
        case .success:
            return UIColor(red: 65/255, green: 158/255, blue: 57/255, alpha: 1)
        case .warning:
            return UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        case .notification:
            return UIColor(red: 27/255, green: 169/255, blue: 225/255, alpha: 1)
        case .alarm:
            return UIColor(red: 196/255, green: 52/255, blue: 46/255, alpha: 1)
        case .custom, .noImage:
            return nil
        }
    }
    
    func image(isIconFilled: Bool) -> UIImage? {
        switch self {
        case .error:
            return ImageHelper.loadImage(name: "error")
        case .success:
            return ImageHelper.loadImage(name: "check")
        case .warning:
            let imageName = isIconFilled ? "warningFilled" : "warningOutline"
            return ImageHelper.loadImage(name: imageName)
        case .notification:
            let imageName = isIconFilled ? "notificationFilled" : "notificationOutline"
            return ImageHelper.loadImage(name: imageName)
        case .alarm:
            let imageName = isIconFilled ? "alarmFilled" : "alarmOutline"
            return ImageHelper.loadImage(name: imageName)
        case .custom(let image):
            return image
        case .noImage:
            return nil
        }
    }
}
