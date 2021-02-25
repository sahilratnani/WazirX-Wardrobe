//
//  Shirt.swift
//  Wardrobe
//
//  Created by Sahil Ratnani on 24/02/21.
//  Copyright © 2021 Sahil Ratnani. All rights reserved.
//

import Foundation
import UIKit

class ShirtPantModel: Codable {
    let imageData: Data
    let id: Int

    init(imageData: Data, id: Int) {
        self.imageData = imageData
        self.id = id
    }

    func getImage() -> UIImage? {
        UIImage(data: imageData)
    }
}
