//
//  SelectSizeViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/10/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//
import UIKit
class SelectSizeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource   {
    
    let cellId = "FrameCollectionViewCell"
    let sizeArray = ["Small", "Medium", "Large", "Canvas"]
    let imageSizeArray = [#imageLiteral(resourceName: "size-1"), #imageLiteral(resourceName: "size-2"), #imageLiteral(resourceName: "size-3"), #imageLiteral(resourceName: "size-4")]
    
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
    
    let grayScaleLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "grayscale-logo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override func viewDidLoad() {
        view.backgroundColor = BG_COLOR
        collectionView.register(FrameCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setupUI()
        
        //self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customNavigationBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
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
        self.title = "Select Size"
        
        // removes the back title from back button of navigation bar
        let barAppearace = UIBarButtonItem.appearance()
        barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
    }
    
    func setupUI(){
        setupCollectionView()
        setupGrayScaleLogoImageView()
    }
    
    func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
    }
    func setupGrayScaleLogoImageView(){
        view.addSubview(grayScaleLogoImageView)
        grayScaleLogoImageView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30).isActive = true
        grayScaleLogoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        grayScaleLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //collection view delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sizeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FrameCollectionViewCell {
            cell.layer.borderWidth = 10
            cell.layer.borderColor = UIColor(red:0.83, green:0.85, blue:0.86, alpha:1.0).cgColor
            cell.backgroundColor = UIColor.white
            var size : String
            size = self.sizeArray[indexPath.item]
            cell.image = imageSizeArray[indexPath.item]
            cell.text = "\(size)"
            return cell
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath)!
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PhotosViewController(), animated: true)
    }
}

extension SelectSizeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width * 0.5) - 10
        let height = (collectionView.frame.height * 0.40)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
}
