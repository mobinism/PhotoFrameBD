//
//  PhotosViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/25/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
import Photos
class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    var chekerForAllPhotosAlbum : Int = 0
    
    let cellId = "PhotosCollectionView"
    let albumCellId = "AlbumTitleCellId"
    
    //var fetchResult: PHFetchResult<PHAsset>!
    var albumArray = [String]()
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var allPhotos: PHFetchResult<PHAsset>!
    
    lazy var albumTitleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceHorizontal = true
        collection.clipsToBounds = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = true
        collection.alwaysBounceHorizontal = true
        collection.clipsToBounds = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.isScrollEnabled = false
        return collection
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = BG_COLOR
        albumTitleCollectionView.register(AlbumTitleCollectionViewCell.self, forCellWithReuseIdentifier: albumCellId)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setupUI()
        
        PHPhotoLibrary.shared().register(self)
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        
        //self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        for i in 0..<smartAlbums.count{
            self.albumArray.append(smartAlbums.object(at: i).localizedTitle!)
        }
    }
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("here")
        let width = view.frame.width
        let scrollviewPointer = targetContentOffset.pointee.x
        let albumIndex = scrollviewPointer / width
        let _ = NSIndexPath(item: Int(albumIndex), section: 0)
        //self.moveAlbumsHorizontalScrollView(indexPath: indexPath)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customNavigationBar()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    //custom navigation bar
    func customNavigationBar(){
        /*let backImage = UIImage(named: "back-icon")
         self.navigationController?.navigationBar.backIndicatorImage = backImage
         self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage*/
        
        navigationController?.navigationBar.shadowImage = UIImage() // this line makes the navigation bar borderless.
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        navigationController?.navigationBar.layer.shadowRadius = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.title = "Select Your Image"
        
        // removes the back title from back button of navigation bar
//        let barAppearace = UIBarButtonItem.appearance()
//        barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
    }
    func setupUI(){
        setupAlbumTitleCollectionView()
        setupCollectionView()
    }
    
    func setupAlbumTitleCollectionView(){
        view.addSubview(albumTitleCollectionView)
        albumTitleCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        albumTitleCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        albumTitleCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        albumTitleCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
    }
    func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: albumTitleCollectionView.bottomAnchor, constant: 15).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // collection view stuffs
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == albumTitleCollectionView{
            return self.albumArray.count
        }
        else{
            return self.albumArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == albumTitleCollectionView{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumCellId, for: indexPath) as? AlbumTitleCollectionViewCell {
                let collection = smartAlbums.object(at: indexPath.row)
                cell.text = collection.localizedTitle
                
                cell.albumTitle.highlightedTextColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
                
                return cell
            }
            else {
                let cell = collectionView.cellForItem(at: indexPath)!
                return cell
            }
        }
        else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? PhotosCollectionViewCell {
                cell.photosVC = self
                return cell
                
            }
            else {
                let cell = collectionView.cellForItem(at: indexPath)!
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == albumTitleCollectionView{
            let indexPath = NSIndexPath(item: indexPath.row, section: 0)
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
        }
        else{
            print("Here")
        }
    }
    
    func moveAlbumsHorizontalScrollView(indexPath:NSIndexPath){
        self.albumTitleCollectionView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
        
    }
    
    func moveToSelectFrameViewController(image : UIImage){
        let selectedFrameVC = SelectFrameViewController()
        selectedFrameVC.selectedPhoto.image = image
        self.navigationController?.pushViewController(selectedFrameVC, animated: true)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == albumTitleCollectionView{
            let width = (collectionView.frame.width * 0.3)
            return CGSize(width: width, height: width)
        }
        else{
            let height = collectionView.frame.height
            let width  = (collectionView.frame.width)
            return CGSize(width: width, height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         if collectionView == albumTitleCollectionView{
            return 10
        }
        else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == albumTitleCollectionView{
            return 0
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == albumTitleCollectionView{
            return UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        }
        else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}
 //MARK: PHOTO LIBRARY CHANGE OBSERVER
//extension PhotosViewController: PHPhotoLibraryChangeObserver {
//    func photoLibraryDidChange(_ changeInstance: PHChange) {
//        guard let changes = changeInstance.changeDetails(for: fetchedPhotos) else { return }
//        DispatchQueue.main.sync {
//            fetchedPhotos = changes.fetchResultAfterChanges
//            self.collectionView.reloadData()
//            self.albumTitleCollectionView.reloadData()
//            print("Observer")
//        }
//    }
//}

extension PhotosViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            print("change detected")
            // Check each of the three top-level fetches for changes.
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                allPhotos = changeDetails.fetchResultAfterChanges
                print(allPhotos.count)
                self.viewDidLoad()
                self.collectionView.reloadData()
                self.albumTitleCollectionView.reloadData()
            }
            else{
               print("Better Luck Next Time Dude")
            }
        }
    }
}

