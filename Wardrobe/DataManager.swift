//
//  DataUpdator.swift
//  Wardrobe
//
//  Created by Sahil Ratnani on 24/02/21.
//  Copyright © 2021 Sahil Ratnani. All rights reserved.
//
import Foundation

class DataManager: DataUpdatable {
    func persistShirts(shirt: [ShirtPantModel]) {
        do {
            let fileURL = try FileManager.default.url(for: .desktopDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: true).appendingPathComponent("Shirt.json")
            let jsonEncoder = JSONEncoder()
            try jsonEncoder.encode(shirt).write(to: fileURL)
        } catch {
             print(error.localizedDescription)
        }
    }

    func persistPants(pant: [ShirtPantModel]) {
        do {
             let fileURL = try FileManager.default.url(for: .desktopDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true).appendingPathComponent("Pant.json")
             let jsonEncoder = JSONEncoder()
             try jsonEncoder.encode(pant).write(to: fileURL)
         } catch {
              print(error.localizedDescription)
         }
    }

    func persistFavourites(dress: [Dress]) {
        do {
             let fileURL = try FileManager.default.url(for: .desktopDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true).appendingPathComponent("Favourite.json")
             let jsonEncoder = JSONEncoder()
             try jsonEncoder.encode(dress).write(to: fileURL)
         } catch {
              print(error.localizedDescription)
         }
    }
}
