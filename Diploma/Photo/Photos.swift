//
//  Photos.swift
//  Navigation
//
//  Created by DmitriiG on 23.05.2022.
//

import Foundation
import UIKit
import iOSIntPackage

//struct Photo {
//    var name: String
//}

final class PhotoData {
    
    var imageArrayUpdateStatus: (() -> Void)?
    
    var imagesArray: [UIImage] = [] {
        didSet {
            self.imageArrayUpdateStatus?()
        }
    }
    
    init(photos:[Int]) {
        createPhotoDataInt(photos: photos)
    }
    
    // изменил методы - один для добавления массива картинок, полученных от observer, другой для добавления по имени из xcasset
    //    func createPhotoDataUIImage(photo: [UIImage]) {
    //        photo.forEach {
    //            imagesArray.append($0)
    //        }
    //    }
    
    func createPhotoDataInt(photos: [Int]) {
        photos.forEach {
            guard let image = UIImage(named: "\(String($0))") else { return }
            imagesArray.append(image)
        }
    }
    
}


