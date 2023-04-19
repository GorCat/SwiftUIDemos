//
//  ImageSaver.swift
//  ImagePreviewDemo
//
//  Created by GorCat on 2023/4/19.
//

import Foundation
import UIKit

class ImageSaver: NSObject {
    var finished: ((String?) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage, finished: ((String?) -> Void)? = nil) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        finished?(error?.localizedDescription)
    }
}
