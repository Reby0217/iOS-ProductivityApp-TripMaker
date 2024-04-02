//
//  Utilities.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import Foundation
import UIKit
import SwiftUI


extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    static public func ==(lhs: CGPoint, rhs: CGPoint) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

func imageFromString(_ strPic: String) -> Image? {
    if let picImageData = Data(base64Encoded: strPic, options: .ignoreUnknownCharacters) {
        if let picImage = UIImage(data: picImageData) {
            let swiftUIImage = Image(uiImage: picImage)
            return swiftUIImage
        }
    }
    return nil
}

func stringFromImage(_ imagePic: UIImage) -> String {
    let picImageData: Data = imagePic.jpegData(compressionQuality: 0.6)!
    let picBase64 = picImageData.base64EncodedString()
    return picBase64
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
