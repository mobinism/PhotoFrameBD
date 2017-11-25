//
//  PhotosCollectionViewCell.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/25/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import Photos
import UIKit

class PhotosCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource,UICollectionViewDelegate {

    var photosVC  = PhotosViewController()
    var allPhotos: PHFetchResult<PHAsset>!
    var imagesArray = [UIImage]()
    var userCollections: PHFetchResult<PHCollection>!
    
    let cellId = "VerticalPhotoCollectionViewCell"
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = true
        collection.alwaysBounceVertical = true
        collection.clipsToBounds = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(VerticalPhotoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.backgroundColor = BG_COLOR
        self.layer.masksToBounds = false
        grabPhotos()
        setupSubviews()
        self.collectionView.reloadData()
    }
    
    //grab photos
    func grabPhotos(){
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        if let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions){
           
            if fetchResult.count > 0 {
                if !self.imagesArray.isEmpty{
                    self.imagesArray.removeAll()
                }
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                        (image, error) in
                        self.imagesArray.append(image!)
                    })
                }
            }
            else{
                print("No image Found")
            }
        }
        else{
            collectionView.reloadData()
            print("Sorry you do not have any photos")
        }
    }
    
    func setupSubviews(){
        setupCollectionView()
    }
    func setupCollectionView(){
        self.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    // collection view stuffs
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? VerticalPhotoCollectionViewCell {
            cell.image = self.imagesArray[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath)!
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.photosVC.moveToSelectFrameViewController(tappedImage: imagesArray[indexPath.row] as UIImage, imageId: indexPath.row)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PhotosCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width * 0.5) - 30
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}


class VerticalPhotoCollectionViewCell : UICollectionViewCell{
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BG_COLOR
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 5
        setupSubviews()
    }
    
    func setupSubviews() {
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}








