//
//  Utilities.swift
//  TripMaker
//
//  Created by Megan Lin on 3/19/24.
//

import Foundation
import UIKit
import SwiftUI

func imageFromString(_ strPic: String) -> Image {
    var picImage: UIImage?
    if let picImageData = Data(base64Encoded: strPic, options: .ignoreUnknownCharacters) {
        picImage = UIImage(data: picImageData)
    }
    // return picImage!
    let swiftUIImage = Image(uiImage: picImage!)
    return swiftUIImage
}

func stringFromImage(_ imagePic: UIImage) -> String {
    let picImageData: Data = imagePic.jpegData(compressionQuality: 0.6)!
    let picBase64 = picImageData.base64EncodedString()
    return picBase64
}
