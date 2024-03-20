//
//  Utilities.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import Foundation
import UIKit
import SwiftUI

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
