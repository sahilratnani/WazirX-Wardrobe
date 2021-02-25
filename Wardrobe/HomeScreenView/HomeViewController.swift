//
//  HomeViewController.swift
//  Wardrobe
//
//  Created by Sahil Ratnani on 24/02/21.
//  Copyright © 2021 Sahil Ratnani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var shirtCollectionView: UICollectionView!
    @IBOutlet weak var pantCollectionView: UICollectionView!

    private var shirts: [ShirtPantModel] = []
    private var pants: [ShirtPantModel] = []

    let dataUpdator: DataUpdatable? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func loadShirtsAndPants() {
        
    }

    @IBAction func addNewShirt(_ sender: UIButton) {
        let url = URL(fileURLWithPath: "mockPath")
        let shirt = ShirtPantModel(localPath: url, id: 1)
        dataUpdator?.addShirt(shirt: shirt)
        shirts.append(shirt)
    }

    @IBAction func addNewPant(_ sender: UIButton) {
        let url = URL(fileURLWithPath: "mockPath")
        let pant = ShirtPantModel(localPath: url, id: 1)
        dataUpdator?.addPant(pant: pant)
        pants.append(pant)
    }

    @IBAction func shuffleCombination(_ sender: UIButton) {
    }

    @IBAction func addFavourite(_ sender: UIButton) {
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}

