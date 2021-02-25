//
//  DataManager.swift
//  Wardrobe
//
//  Created by Sahil Ratnani on 24/02/21.
//  Copyright © 2021 Sahil Ratnani. All rights reserved.
//
import Foundation

class DataManager {
    var shirts: [ShirtPantModel] {
        getShirts()
    }
    var pants: [ShirtPantModel] {
        getPants()
    }
    var favourites: [Dress] {
        getFavouites()
    }

    private let dataUpdator: DataUpdatable
    private let shirtJson = "shirts.json"
    private let pantJson = "pants.json"
    private let favouriteJson = "favourite.json"

    init(dataUpdator: DataUpdatable) {
        self.dataUpdator = dataUpdator
    }

    private func getUrl(for file: String) -> URL? {
        do {
            let fileUrl = try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true).appendingPathComponent(file)
            return fileUrl
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func getShirts() -> [ShirtPantModel]{
        do {
        guard let url = getUrl(for: shirtJson) else { return [] }
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let shirts = try decoder.decode([ShirtPantModel].self, from: jsonData)
        return shirts
        } catch {
            print("Could not get shirts")
            return []
        }
    }

    private func getPants() -> [ShirtPantModel] {
        do {
        guard let url = getUrl(for: pantJson) else { return [] }
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let pants = try decoder.decode([ShirtPantModel].self, from: jsonData)
        return pants
        } catch {
            print("Could not get pants")
            return []
        }
    }

    private func getFavouites() -> [Dress] {
        do {
        guard let url = getUrl(for: favouriteJson) else { return [] }
        let jsonData = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let favourites = try decoder.decode([Dress].self, from: jsonData)
        return favourites
        } catch {
            print("Could not get Favourite combinations - \(error)")
            return []
        }
    }

    func addShirt(shirt: ShirtPantModel) {
        do {
            var shirtsArray = shirts
            shirtsArray.insert(shirt, at: 0)
            guard let fileURL = getUrl(for: shirtJson) else { return }
            let jsonEncoder = JSONEncoder()
            try jsonEncoder.encode(shirtsArray).write(to: fileURL)
            dataUpdator.shirtsUpdate(shirts: shirtsArray)
        } catch {
            print("Failed to add shirt - \(error.localizedDescription)")
        }
    }

    func removeShirt(shirt: ShirtPantModel) {
        do {
            var shirtsArray = shirts
            shirtsArray.removeAll{ $0.id == shirt.id }
            guard let fileURL = getUrl(for: shirtJson) else { return }
            let jsonEncoder = JSONEncoder()
            try jsonEncoder.encode(shirtsArray).write(to: fileURL)
            dataUpdator.shirtsUpdate(shirts: shirtsArray)
        } catch {
            print("Failed to add shirt - \(error.localizedDescription)")
        }
    }

    func addPant(pant: ShirtPantModel) {
        do {
            var pantsArray = pants
            pantsArray.insert(pant, at: 0)
            guard let fileURL = getUrl(for: pantJson) else { return }
            let jsonEncoder = JSONEncoder()
            try jsonEncoder.encode(pantsArray).write(to: fileURL)
            dataUpdator.pantsUpdated(pants: pantsArray)
        } catch {
            print("Failed to add pant - \(error.localizedDescription)")
        }
    }

    func removePant(pant: ShirtPantModel) {
        do {
            var pantsArray = pants
            pantsArray.removeAll { $0.id == pant.id }
            guard let fileURL = getUrl(for: pantJson) else { return }
            let jsonEncoder = JSONEncoder()
            try jsonEncoder.encode(pantsArray).write(to: fileURL)
            dataUpdator.pantsUpdated(pants: pantsArray)
        } catch {
            print("Failed to add pant - \(error.localizedDescription)")
        }
    }

    func addFavourite(dress: Dress) {
        do {
            var favCombinations = favourites
            favCombinations.insert(dress, at: 0)
            guard let fileURL = getUrl(for: favouriteJson) else { return }
            let jsonEncoder = JSONEncoder()
            try jsonEncoder.encode(favCombinations).write(to: fileURL)
            dataUpdator.favouritesUpdate(dresses: favCombinations)
        } catch {
            print("Failed to add favourite - \(error.localizedDescription)")
        }
    }

    func removeFavourite(dress: Dress) {
        do {
            var favCombinations = favourites
            favCombinations.removeAll {
                $0.shirt.id == dress.shirt.id && $0.pant.id == dress.pant.id
            }
            guard let fileURL = getUrl(for: favouriteJson) else { return }
            let jsonEncoder = JSONEncoder()
            try jsonEncoder.encode(favCombinations).write(to: fileURL)
            dataUpdator.favouritesUpdate(dresses: favCombinations)
        } catch {
            print("Failed to add favourite - \(error.localizedDescription)")
        }
    }
}
