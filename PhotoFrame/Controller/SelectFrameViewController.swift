//
//  SelectFrameViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/30/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
import Alamofire
class SelectFrameViewController: UIViewController{
    
    let cellId = "SelecteFrameCollectionView"
    var photosVC = PhotosViewController()
    var frameSizeArray = [FrameSizeModel]()
    var imageSizeArray = [ImageSizeModel]()
    var imageID : Int!
    var frameSizeID : String! = "1"
    var imageSizeID : String! = "1"
    var defaultImageSizeTitle : String!
    var barButtonTitle : String! = "Small ▼"
    var imageToEdit: UIImage!
    var frameURLs = [FrameFetchingModel]()
    var defaultImageSizeDetails = [DefaultImageSize]()
    
    lazy var selectedPhoto : UIImageView = {
        var photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photo.addGestureRecognizer(tapGestureRecognizer)
        return photo
    }()
    lazy var frame : UIImageView = {
        var photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    lazy var frameTitleLabe : UILabel = {
        let label = UILabel()
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
    
    lazy var rotateButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"reload-icon-grey"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = BG_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRotateButton), for: .touchUpInside)
        return button
    }()
    
    lazy var photoSizeButton : UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .center
        button.setTitle("3R ▼", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleImageSize), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: TEXT_FONT, size: 14)
        button.contentHorizontalAlignment = .right
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
    
    lazy var noFrameMessage : UILabel = {
        let label = UILabel()
        label.text = "Selected Item Has No Frames"
        label.font = UIFont(name: TEXT_FONT, size: 17)
        label.backgroundColor = UIColor.white
        label.textColor = .black
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    lazy var dropdown: DropDown = {
        var drop = DropDown()
        drop.selectFramVC = self
        return drop
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BG_COLOR
        self.checkReachability()
        setupUI()
        frameCollectionView.register(SelectFrameCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        self.getDefaultImageSize()
        self.getFrames()
        self.setupWithRatio()
        self.overLayFrame()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.overLayFrame()
        self.customNavigationBar()
    }
    func customNavigationBar(){
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
        let frameSizebutton: UIButton = {
            let button = UIButton(type: .system)
            button.contentHorizontalAlignment = .center
            button.setTitle(self.barButtonTitle, for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handleFrameSizeButton), for: .touchUpInside)
            button.titleLabel?.font = UIFont(name: TEXT_FONT, size: 16)
            return button
        }()
        let barButton = UIBarButtonItem(customView: frameSizebutton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    func showActionSheet(){
        let alertView = UIAlertController(title: "Are You Sure?", message: "Your customizations will no longer exist.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertView.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewController(animated: true)
        }))
        
        alertView.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        present(alertView, animated: true, completion: nil)
    }
    func setupUI(){
        setupSelectedImageView()
        setupDetailsButton()
        setupDetailsContinue()
        setupFrameCollectionView()
        setupNoFrameMessage()
    }
    func setupSelectedImageView(){
        let viewWidth = self.view.frame.width
        let imageViewHeight = ((viewWidth * 0.7) - (63 * 2))
        view.addSubview(selectedPhoto)
        selectedPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: (25 + 63)).isActive = true
        selectedPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedPhoto.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
    }
    func setupFrameTitleLabel(){
        view.addSubview(frameTitleLabe)
        frameTitleLabe.topAnchor.constraint(equalTo: frame.bottomAnchor, constant: 35).isActive = true
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
        cropButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
    }
    func setupRotateButton(){
        view.addSubview(rotateButton)
        rotateButton.centerXAnchor.constraint(equalTo: cropButton.centerXAnchor).isActive = true
        rotateButton.topAnchor.constraint(equalTo: cropButton.bottomAnchor, constant: 15).isActive = true
        rotateButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
        rotateButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
    }
    func setupPhotoSizeButton(){
        view.addSubview(photoSizeButton)
        photoSizeButton.centerYAnchor.constraint(equalTo: frameTitleLabe.centerYAnchor, constant: 15).isActive = true
        photoSizeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        photoSizeButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.09).isActive = true
        photoSizeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
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
        view.addSubview(self.frame)
        frame.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frame.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        frame.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        setupFrameTitleLabel()
        setupFrameSizeLabel()
        setupFramePriceLabel()
        setupCropButton()
        setupRotateButton()
        setupPhotoSizeButton()
    }
    func setupNoFrameMessage(){
        view.addSubview(noFrameMessage)
        noFrameMessage.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        noFrameMessage.bottomAnchor.constraint(equalTo: self.continueButton.topAnchor).isActive = true
        noFrameMessage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        noFrameMessage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }
    func setupWithRatio(){
        UIView.animate(withDuration: 0.3) {
            self.selectedPhoto.widthAnchor.constraint(equalTo: self.selectedPhoto.heightAnchor, multiplier: 0.8).isActive = true
        }
    }
    //change the title of button
    func changePhotoSizeButtonTitle(title: String!){
        self.photoSizeButton.setTitle(title, for: .normal)
    }
    
    //check reachability
    func checkReachability(){
        let reachability = Reachability()
        let isConnected = reachability.connectedToNetwork()
        
        if !isConnected{
            let modalController = InternetConnectionAlert()
            modalController.alertTitle.text   = "Oopps!!"
            modalController.alertMessage.text = "Check The Internet Connection!!"
            modalController.modalPresentationStyle = .overCurrentContext
            present(modalController, animated: true, completion: {
                print("modal raised")
            })
        }
    }
}

//Collection view delegate emthods
extension SelectFrameViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    //collection view delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.frameURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SelectFrameCollectionViewCell {
            
            //cell.selectFrame.sd_setImage(with: URL(string: frameURLs[indexPath.row]))
            cell.selectFrame.sd_setImage(with: URL(string: frameURLs[indexPath.row].frameUrl), placeholderImage: #imageLiteral(resourceName: "loading"), options: [.continueInBackground, .progressiveDownload])
            cell.frameTitle = frameURLs[indexPath.row].frameTitle
            return cell
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath)!
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(frameURLs[indexPath.row].frameUrl, forKey: FRAME_URL)
        UserDefaults.standard.set(frameURLs[indexPath.row].framePrice, forKey: FRAME_PRICE)
        self.frame.sd_setImage(with: URL(string: "\(UserDefaults.standard.value(forKey: FRAME_URL) as! String)"))
        self.frameTitleLabe.text = self.frameURLs[indexPath.row].frameTitle
        self.framePriceLabel.text = "\(UserDefaults.standard.value(forKey: FRAME_PRICE) as! String) - BDT"
        /*let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width*/
        self.overLayFrame()
        self.view.layoutIfNeeded()
    }
}
// action methods
extension SelectFrameViewController {
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        self.handleContinueButton()
    }
    
    @objc func handleCropButton(){
        self.handleContinueButton()
    }
    
    @objc func handleRotateButton(){
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.transform = self.frame.transform.rotated(by: CGFloat(Double.pi / 2))
        })
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.showActionSheet()
    }
    
    @objc func handleButton(){
        print("Button Pressed")
    }
    
    @objc func handleFrameSizeButton(){
        print("Button working")
        self.dropdown.navigationBarHeight = self.navigationController?.navigationBar.frame.height
        self.dropdown.coordinateX         = 0
        self.dropdown.coordinateX         = 0
        self.getFrameSizeFromAPI()
    }
    
    @objc func handleImageSize(){
        self.dropdown.navigationBarHeight = self.navigationController?.navigationBar.frame.height
        self.dropdown.coordinateX         = self.photoSizeButton.frame.origin.x
        self.dropdown.coordinateY         = self.photoSizeButton.frame.origin.y
        self.getImageSizeFromAPI()
    }
    
    @objc func handleContinueButton(){
        let editSelectedPhotoVC = EditSelectedPhotoViewController()
        self.imageToEdit = self.selectedPhoto.image!
        editSelectedPhotoVC.rawPhoto = self.imageToEdit
        self.navigationController?.pushViewController(editSelectedPhotoVC, animated: true)
    }
}

extension SelectFrameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width * 0.25)
        let height = (collectionView.frame.height * 0.85)
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

// API Calls section
extension SelectFrameViewController {
    func getFrameSizeFromAPI(){
        guard let url = URL(string: "\(API_URL)get_frame_size") else { return }
        //let params = ["authenticate": "true"] as [String: Any]
        Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {
            response in
            guard response.result.isSuccess else {
                return
            }
            if !self.frameSizeArray.isEmpty{
                self.frameSizeArray.removeAll()
            }
            if let responseData = response.data {
                let json = JSON(data: responseData)
                if let dictArray = json.array {
                    for dict in dictArray {
                        let data = FrameSizeModel(id: dict["frame_size_id"].string!, title: dict["frame_size_title"].string!)
                        self.frameSizeArray.append(data)
                    }
                }
                self.dropdown.show(withData: self.frameSizeArray)
            }
        })
    }
    
    func getImageSizeFromAPI(){
        guard let url = URL(string: "\(API_URL)get_image_size") else { return }
        let params = ["frame_size_id": self.frameSizeID] as [String: Any]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {
            response in
            guard response.result.isSuccess else {
                return
            }
            if !self.imageSizeArray.isEmpty{
                self.imageSizeArray.removeAll()
            }
            if let responseData = response.data {
                let json = JSON(data: responseData)
                if let dictArray = json.array {
                    for dict in dictArray {
                        let data = ImageSizeModel(imageSizeId: dict["image_size_id"].string!, imageSizeTitle: dict["image_size_title"].string!, frameSizeId: dict["frame_size_id"].string!)
                        self.imageSizeArray.append(data)
                    }
                }
                self.dropdown.show(withData: self.imageSizeArray)
            }
        })
    }
    
    func getDefaultImageSize(){
        guard let url = URL(string: "\(API_URL)get_default_image_size") else { return }
        let params = ["frame_size_id": self.frameSizeID] as [String: Any]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: {
            response in
            guard response.result.isSuccess else {
                return
            }
            if !self.defaultImageSizeDetails.isEmpty{
                self.defaultImageSizeDetails.removeAll()
            }
            if let responseData = response.data {
                let json = JSON(data: responseData)
                if let dictArray = json.array {
                    for dict in dictArray {
                        let data = DefaultImageSize(imageSizeTitle: dict["image_size_title"].string!, imageSizeId: dict["image_size_id"].string!)
                        self.defaultImageSizeTitle = data.imageSizeTitle + " ▼"
                        self.imageSizeID      = data.imageSizeId
                        self.changePhotoSizeButtonTitle(title: self.defaultImageSizeTitle)
                        self.getFrames()
                    }
                }
            }
        })
    }
    
    // fetch frames from api
    func getFrames(){
        var counter = 0
        guard let url = URL(string: "\(API_URL)get_frames") else { return }
        let params = ["frame_size_id": self.frameSizeID,
                      "image_size_id": self.imageSizeID] as [String: Any]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: nil).responseString(completionHandler: {
            response in
            guard response.result.isSuccess else {
                return
            }
            if !self.frameURLs.isEmpty{
                self.frameURLs.removeAll()
            }
            if let responseData = response.data {
                let json = JSON(data: responseData)
                if let dictArray = json.array {
                    for dict in dictArray {
                        let data = FrameFetchingModel(frameUrl: dict["image_url"].string!, frameTitle: dict["title"].string!, framePrice: dict["price"].string!)
                        self.frameURLs.append(data)
                    }
                    
                    if  self.frameURLs.count > 0{
                        self.frameCollectionView.alpha = 1
                        self.noFrameMessage.alpha      = 0
                        self.frameCollectionView.reloadData()
                        if counter == 0{
                            UserDefaults.standard.set(self.frameURLs[0].frameUrl, forKey: FRAME_URL)
                            UserDefaults.standard.set(self.frameURLs[0].framePrice, forKey: FRAME_PRICE)
                            self.frame.sd_setImage(with: URL(string: "\(UserDefaults.standard.value(forKey: FRAME_URL) as! String)"))
                            self.frameTitleLabe.text = self.frameURLs[0].frameTitle
                            self.framePriceLabel.text = "\(UserDefaults.standard.value(forKey: FRAME_PRICE) as! String) - BDT"
                            counter = counter + 1
                        }
                    }
                    else{
                        self.frameCollectionView.alpha = 0
                        self.noFrameMessage.alpha      = 1
                    }
                }
            }
        })
    }
}

