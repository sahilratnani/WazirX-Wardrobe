//
//  Dress.swift
//  Wardrobe
//
//  Created by Sahil Ratnani on 24/02/21.
//  Copyright © 2021 Sahil Ratnani. All rights reserved.
//

class Dress: Codable {
    let shirt: ShirtPantModel
    let pant: ShirtPantModel

    init(shirt: ShirtPantModel, pant: ShirtPantModel) {
        self.shirt = shirt
        self.pant = pant
    }
}
