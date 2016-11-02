//
//  ImageHelper.swift
//  Pods
//
//  Created by Candost Dagdeviren on 02/11/2016.
//
//

import Foundation

class ImageHelper {
    class func loadImage(name: String) -> UIImage? {
        let podBundle = Bundle(for: ImageHelper.self)
        if let url = podBundle.url(forResource: "AlertView", withExtension: "bundle") {
            let bundle = Bundle(url: url)
            return UIImage(named: name, in: bundle, compatibleWith: nil)
        }
        return nil
    }
}
