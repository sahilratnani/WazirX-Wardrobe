//
//  DataUpdatable.swift
//  Wardrobe
//
//  Created by Sahil Ratnani on 24/02/21.
//  Copyright © 2021 Sahil Ratnani. All rights reserved.
//

protocol DataUpdatable {
    func shirtsUpdate(shirts: [ShirtPantModel])
    func pantsUpdated(pants: [ShirtPantModel])
    func favouritesUpdate(dresses: [Dress])
    func updateFailed()
}
