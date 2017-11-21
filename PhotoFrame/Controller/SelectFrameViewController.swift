//
//  SelectFrameViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/30/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class SelectFrameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imageID : Int!
    var photosVC = PhotosViewController()
    let cellId = "SelecteFrameCollectionView"
    var imageToEdit: UIImage!
    var frameArray = [#imageLiteral(resourceName: "Frame-1"), #imageLiteral(resourceName: "Frame-2"), #imageLiteral(resourceName: "Frame-3"), #imageLiteral(resourceName: "Frame-4"), #imageLiteral(resourceName: "Frame-5"), #imageLiteral(resourceName: "Frame-6"), #imageLiteral(resourceName: "Frame-7"), #imageLiteral(resourceName: "Frame-8"), #imageLiteral(resourceName: "Frame-9"), #imageLiteral(resourceName: "Frame-10"), #imageLiteral(resourceName: "Frame-11"), #imageLiteral(resourceName: "Frame-12")]
    lazy var selectedPhoto : UIImageView = {
        var photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photo.addGestureRecognizer(tapGestureRecognizer)
        return photo
    }()
    lazy var frameTitleLabe : UILabel = {
        let label = UILabel()
        label.text = "Frame Name"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .black
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    lazy var frameSizeLabel : UILabel = {
        let label = UILabel()
        label.text = "\"9 X 9\" Frame"
        label.textColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 17)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    lazy var framePriceLabel : UILabel = {
        let label = UILabel()
        label.text = "299 - BDT"
        label.textColor = UIColor(red:1.00, green:0.54, blue:0.40, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 17)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    lazy var cropButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"crop-icon"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = BG_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCropButton), for: .touchUpInside)
        return button
    }()
    lazy var photoSizeButton : UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .center
        //button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 5)
        //button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 0)
        button.setTitle("3R ▼", for: .normal)
        //button.setImage(UIImage(named:"dropdown-icon"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: TEXT_FONT, size: 14)
        return button
    }()
    lazy var detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .center
        button.setTitle("Details", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = BG_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 18)
        button.layer.shadowOffset = CGSize(width: 0, height: -2)
        return button
    }()
    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red:0.22, green:0.69, blue:0.91, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 18)
        button.layer.shadowOffset = CGSize(width: 0, height: -2)
        return button
    }()
    lazy var frameCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(red:0.91, green:0.92, blue:0.94, alpha:1.0)
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceHorizontal = true
        collection.clipsToBounds = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var frame : UIImageView = {
        var photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BG_COLOR
        setupUI()
        frameCollectionView.register(SelectFrameCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.frame.image = self.frameArray[0]
        UserDefaults.standard.set("\(0)", forKey: FRAME_ID)
        self.overLayFrame()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.handleContinueButton()
    }
    @objc func handleCropButton(){
        self.handleContinueButton()
    }
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if  frame.image == nil{
            UserDefaults.standard.set("-1", forKey: FRAME_ID)
        }
        else{
            print("Frame id is not empty")
        }
        self.customNavigationBar()
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
         let button: UIButton = {
            let button = UIButton(type: .system)
            //button.setImage(UIImage(named:"dropdown-icon"), for: .normal)
            button.contentHorizontalAlignment = .center
//            button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 5)
//            button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 0)
            button.setTitle("Small ▼", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
            button.titleLabel?.font = UIFont(name: TEXT_FONT, size: 16)
            return button
        }()
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        // removes the back title from back button of navigation bar
        //        let barAppearace = UIBarButtonItem.appearance()
        //        barAppearace.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)
    }
    
    func setupUI(){
        setupSelectedImageView()
        setupFrameTitleLabel()
        setupFrameSizeLabel()
        setupFramePriceLabel()
        setupCropButton()
        setupPhotoSizeButton()
        setupDetailsButton()
        setupDetailsContinue()
        setupFrameCollectionView()
    }
    func setupSelectedImageView(){
        view.addSubview(selectedPhoto)
        selectedPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        selectedPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedPhoto.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        selectedPhoto.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    func setupFrameTitleLabel(){
        view.addSubview(frameTitleLabe)
        frameTitleLabe.topAnchor.constraint(equalTo: selectedPhoto.bottomAnchor, constant: 35).isActive = true
        frameTitleLabe.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func setupFrameSizeLabel(){
        view.addSubview(frameSizeLabel)
        frameSizeLabel.topAnchor.constraint(equalTo: frameTitleLabe.bottomAnchor, constant: 10).isActive = true
        frameSizeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func setupFramePriceLabel(){
        view.addSubview(framePriceLabel)
        framePriceLabel.topAnchor.constraint(equalTo: frameSizeLabel.bottomAnchor, constant: 10).isActive = true
        framePriceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func setupCropButton(){
        view.addSubview(cropButton)
        cropButton.centerYAnchor.constraint(equalTo: frameTitleLabe.centerYAnchor, constant: 15).isActive = true
        cropButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        cropButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
        cropButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
    }
    func setupPhotoSizeButton(){
        view.addSubview(photoSizeButton)
        photoSizeButton.centerYAnchor.constraint(equalTo: frameTitleLabe.centerYAnchor, constant: 15).isActive = true
        photoSizeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        photoSizeButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
        photoSizeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
    }
    func setupDetailsButton(){
        view.addSubview(detailsButton)
        detailsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailsButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        detailsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    func setupDetailsContinue(){
        view.addSubview(continueButton)
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        continueButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupFrameCollectionView(){
        view.addSubview(frameCollectionView)
        frameCollectionView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        frameCollectionView.bottomAnchor.constraint(equalTo: self.continueButton.topAnchor).isActive = true
        frameCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        frameCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
    }
    func overLayFrame(){
        selectedPhoto.addSubview(frame)
        frame.topAnchor.constraint(equalTo: selectedPhoto.topAnchor).isActive = true
        frame.leftAnchor.constraint(equalTo: selectedPhoto.leftAnchor).isActive = true
        frame.rightAnchor.constraint(equalTo: selectedPhoto.rightAnchor).isActive = true
        frame.bottomAnchor.constraint(equalTo: selectedPhoto.bottomAnchor).isActive = true
    }
    @objc func handleButton(){
        print("Button Pressed")
    }
    @objc func handleContinueButton(){
        print("Crop Image tapped")
        let editSelectedPhotoVC = EditSelectedPhotoViewController()
        self.imageToEdit = self.selectedPhoto.image!
        editSelectedPhotoVC.rawPhoto = self.imageToEdit
        self.navigationController?.pushViewController(editSelectedPhotoVC, animated: true)
    }
    //collection view delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.frameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SelectFrameCollectionViewCell {
            cell.frameImage = self.frameArray[indexPath.row]
            cell.frameTitle = "Title"
            return cell
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath)!
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set("\(indexPath.row)", forKey: FRAME_ID)
        print("Frame Number: \(indexPath.row)")
        self.frame.image = frameArray[indexPath.row]
        self.overLayFrame()
    }
}

extension SelectFrameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width * 0.25)
        let height = (collectionView.frame.height * 0.8)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

