//
//  HomeViewController.swift
//  Wardrobe
//
//  Created by Sahil Ratnani on 24/02/21.
//  Copyright © 2021 Sahil Ratnani. All rights reserved.
//

import UIKit

private enum PickerType: String {
    case shirtPicker = "shirtPicker"
    case pantPicker = "pantPicker"
}

class HomeViewController: UIViewController, DataUpdatable {
    @IBOutlet weak var shirtCollectionView: UICollectionView!
    @IBOutlet weak var pantCollectionView: UICollectionView!

    @IBOutlet weak var favouriteButton: UIButton!
    private let maxImageSize = 50000
    private var randomNumbers = Set<Int>()

    private lazy var dataManager = DataManager(dataUpdator: self)
    private lazy var shirts = dataManager.shirts
    private lazy var pants = dataManager.pants
    private lazy var favourites = dataManager.favourites

    private var currentShirt: ShirtPantModel?
    private var currentPant: ShirtPantModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
    }

    private func setUP() {
        shirtCollectionView.dataSource = self
        shirtCollectionView.delegate = self
        pantCollectionView.dataSource = self
        pantCollectionView.dataSource = self

        let favImage = UIImage(systemName: "heart.fill")
        let notFavImage = UIImage(systemName: "heart")
        favouriteButton.setImage(favImage, for: .selected)
        favouriteButton.setImage(notFavImage, for: .normal)
    }

    @IBAction func addNewShirt(_ sender: UIButton) {
        openImagePicker(of: .shirtPicker)
    }

    @IBAction func addNewPant(_ sender: UIButton) {
        openImagePicker(of: .pantPicker)
    }

    private func openImagePicker(of type: PickerType) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            //error
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.accessibilityHint = type.rawValue
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shuffleCombination(_ sender: UIButton) {
        shirts.shuffle()
        pants.shuffle()
        shirtCollectionView.reloadData()
        pantCollectionView.reloadData()
    }

    @IBAction func addFavourite(_ sender: UIButton) {
        guard let shirt = currentShirt, let pant = currentPant else {
              print("Favourite marked favourite")
              return
          }
          let dress = Dress(shirt: shirt, pant: pant)
        if sender.isSelected {
            dataManager.removeFavourite(dress: dress)
            setFavouriteButton(isFavourite: false)
        } else {
            dataManager.addFavourite(dress: dress)
            setFavouriteButton(isFavourite: true)
        }
    }

    func randomIdentifier() -> Int {
        // not unique - prone to bug for fav items
        return Int.random(in: 1..<1000)
    }

    func shirtsUpdate(shirts: [ShirtPantModel]) {
        self.shirts = shirts
        shirtCollectionView.reloadData()
     }
     
     func pantsUpdated(pants: [ShirtPantModel]) {
        self.pants = pants
        pantCollectionView.reloadData()
     }
     
     func favouritesUpdate(dresses: [Dress]) {
         self.favourites = dresses
        checkForFavouriteCombination()
     }
     
     func updateFailed() {
         presentAlert(with: "Error occured performing your actions")
     }

    func presentAlert(with message: String){
        let alert = UIAlertController(title: "Wardrobe", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func setFavouriteButton(isFavourite: Bool) {
        favouriteButton.isSelected = isFavourite
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == shirtCollectionView {
            return shirts.count
        } else {
            return pants.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        defer {
            checkForFavouriteCombination()
        }
        if collectionView == shirtCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shirtCell",
                                                                for: indexPath) as! ShirtCollectionViewCell
            let shirt = shirts[indexPath.row]
            cell.imageView.image = shirt.getImage() ?? UIImage() // TODO: show placeholder
            currentShirt = shirt
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pantCell",
                                                                for: indexPath) as! PantCollectionViewCell
            let pant = pants[indexPath.row]
            cell.imageView.image = pant.getImage() ?? UIImage() // TODO: show placeholder
            currentPant = pant
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    private func checkForFavouriteCombination() {
        let isFavourite = favourites.filter{ $0.pant.id == currentPant?.id && $0.shirt.id == currentShirt?.id}
        guard isFavourite.isEmpty == false else {
            setFavouriteButton(isFavourite: false)
            return
        }
        setFavouriteButton(isFavourite: true)
    }
}

extension HomeViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            print("Could not get image") // TODO: show alert
            return
        }
        let pickerType: PickerType = picker.accessibilityHint == PickerType.shirtPicker.rawValue ? .shirtPicker : .pantPicker
        verifyImageAndStore(image: image, pickerType: pickerType)
        dismiss(animated:true, completion: nil)
    }

    private func verifyImageAndStore(image: UIImage, pickerType: PickerType) {
        guard let imgData = image.jpegData(compressionQuality: 1) as NSData? else {
            presentAlert(with: "Failed to generate image")
            return // TODO: show alert
        }
        let imageSize: Int = imgData.count
        if imageSize > maxImageSize {
            presentAlert(with: "Image size exceeds max limit of 5 Mb")
        }
        let item = ShirtPantModel(imageData: imgData as Data, id: randomIdentifier())
        if pickerType == .shirtPicker {
            dataManager.addShirt(shirt: item)
        } else {
            dataManager.addPant(pant: item)
        }
    }
}

