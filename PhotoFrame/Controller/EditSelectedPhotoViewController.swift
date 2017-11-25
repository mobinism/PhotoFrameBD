//
//  EditSelectedPhotoViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 11/2/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//


import Photos
import AKImageCropperView
import UIKit
class EditSelectedPhotoViewController: UIViewController{
    let selectFrameVC = SelectFrameViewController()
    var rawPhoto : UIImage!
    var croppedImage : UIImage!
    // contrast and brightness handler
    var context = CIContext()
    var imageToProcess: UIImage!
    var outputImage : UIImage!
    
    //added filters
    let colorFilterArray = [
        "CIVignette",
        "CISepiaTone",
        "CIDotScreen",
        "CIColorInvert",
        "CIColorPosterize",
        "CIVignetteEffect",
        "CIPhotoEffectFade",
        "CIPhotoEffectMono",
        "CIPhotoEffectNoir",
        "CISharpenLuminance",
        "CIPhotoEffectTonal",
        "CIPhotoEffectChrome",
        "CIPhotoEffectProcess",
        "CIPhotoEffectInstant",
        "CIPhotoEffectTransfer",
        ]
    
    let cellID = "ColorFilterCollectionViewCell"
    
    var cropViewProgrammatically: AKImageCropperView!
    
    private var cropView: AKImageCropperView {
        return cropViewProgrammatically
    }
    
    lazy var brightnessLabel : UILabel = {
        let label = UILabel()
        label.text = "Brightness"
        label.textColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 13)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var contrastLabel : UILabel = {
        let label = UILabel()
        label.text = "Contrast"
        label.textColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 13)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    lazy var brightnessSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -0.1
        slider.maximumValue = 0.1
        slider.value = 0
        slider.isContinuous = true
        slider.isUserInteractionEnabled = true
        slider.addTarget(self, action: #selector(handleSlider(_:)), for: .valueChanged)
        slider.clipsToBounds = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tag = 1
        slider.minimumTrackTintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        slider.maximumTrackTintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        slider.thumbTintColor =  UIColor(red:0.01, green:0.61, blue:0.90, alpha:1.0)
        return slider
    }()
    lazy var contrastSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.5
        slider.maximumValue = 1.5
        slider.value = 1
        slider.isContinuous = true
        slider.tintColor = UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0)
        slider.isUserInteractionEnabled = true
        slider.addTarget(self, action: #selector(handleSlider(_:)), for: .valueChanged)
        slider.clipsToBounds = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tag = 2
        slider.minimumTrackTintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        slider.maximumTrackTintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        slider.thumbTintColor =  UIColor(red:0.01, green:0.61, blue:0.90, alpha:1.0)
        return slider
    }()
    lazy var colorFilterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceHorizontal = false
        collection.clipsToBounds = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    lazy var imageArea : UIImageView = {
        var uiImageView = UIImageView()
        uiImageView.isUserInteractionEnabled = true
        uiImageView.contentMode = .scaleAspectFill
        uiImageView.clipsToBounds = true
        uiImageView.backgroundColor = .clear
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        return uiImageView
    }()
    
    lazy var selectedImage : UIImageView = {
        var uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFill
        uiImageView.clipsToBounds = true
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.isUserInteractionEnabled = true
        uiImageView.alpha = 0.4
        /*let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handleFramePinch(_:)))
        uiImageView.addGestureRecognizer(pinch)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleFramePan(_:)))
         uiImageView.addGestureRecognizer(pan)*/
        return uiImageView
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .center
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red:0.22, green:0.69, blue:0.91, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 18)
        button.layer.shadowOffset = CGSize(width: 0, height: -2)
        return button
    }()
    lazy var cropButton: UIButton = {
        let button = UIButton(type: .system)
        button.contentHorizontalAlignment = .center
        button.setTitle("Crop", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red:0.22, green:0.69, blue:0.91, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCrop), for: .touchUpInside)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 18)
        button.layer.shadowOffset = CGSize(width: 0, height: -2)
        return button
    }()
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.contentHorizontalAlignment = .center
        button.backgroundColor = BG_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 18)
        button.layer.shadowOffset = CGSize(width: 0, height: -2)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedImage.image = self.rawPhoto
        view.backgroundColor = BG_COLOR
        
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        self.colorFilterCollectionView.register(ColorFilterCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        setupUI()
        setupCropView()
        self.makeStuffsInvisible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.cropView.showOverlayView(animationDuration: 0.2)
        })
    }
    
    func setupCropView(){
        // Programmatically initialization
        
        // iPhone 4.7"
        
         /*cropViewProgrammatically = AKImageCropperView(frame: CGRect(x: 0, y: 20.0, width: 375.0, height: 607.0))
         view.addSubview(cropViewProgrammatically)*/
        
         // with constraints
         cropViewProgrammatically = AKImageCropperView()
         cropViewProgrammatically.translatesAutoresizingMaskIntoConstraints = false
        cropViewProgrammatically.contentMode = .scaleAspectFit
         view.addSubview(cropViewProgrammatically)
        
        // layout constarints
         cropViewProgrammatically.topAnchor.constraint(equalTo: imageArea.topAnchor).isActive = true
         cropViewProgrammatically.leftAnchor.constraint(equalTo: imageArea.leftAnchor).isActive = true
         cropViewProgrammatically.rightAnchor.constraint(equalTo: imageArea.rightAnchor).isActive = true
         cropViewProgrammatically.bottomAnchor.constraint(equalTo: imageArea.bottomAnchor).isActive = true
        
        
        // Inset for overlay action view
        
         cropView.overlayView?.configuraiton.cropRectInsets.bottom = 50
        
        // Custom overlay view configuration
        
         var customConfiguraiton = AKImageCropperCropViewConfiguration()
         customConfiguraiton.cropRectInsets.bottom = 50
         cropView.overlayView = CustomImageCropperOverlayView(configuraiton: customConfiguraiton)
        
        cropView.delegate = self
        cropView.image = self.rawPhoto
    }
    
    func simpleBlurFilterExample(myImage: UIImage) -> UIImage {
        // convert UIImage to CIImage
        let inputCIImage = CIImage(image: myImage)!
        
        // Create Blur CIFilter, and set the input image
        let blurFilter = CIFilter(name: "CIZoomBlur")!
        blurFilter.setValue(inputCIImage, forKey: kCIInputImageKey)
        blurFilter.setValue(8, forKey: kCIInputRadiusKey)
        
        // Get the filtered output image and return it
        let myImage = blurFilter.outputImage!
        self.selectedImage.image = UIImage.init(ciImage: myImage)
        return UIImage(ciImage: myImage)
    }
    
    func addFilterForButtonPreview(colorFilter: String)->UIImage{
        // Create filters for each button
        let myImage : UIImage! = self.rawPhoto
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: myImage!)
        let filter = CIFilter(name: colorFilter)
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        //let imageForButton = CIImage(cgImage: filteredImageRef!)
        return UIImage.init(cgImage: filteredImageRef!)
    }
    
    func addFilter(colorFilter: String)->UIImage {
        
        //making the slider button as default
        self.brightnessSlider.value = 0
        self.contrastSlider.value = 1
        
        self.imageToProcess = nil
        var filterOverCroppedImage : UIImage!
        var myImage : UIImage! = nil
        myImage = self.croppedImage!
        
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: myImage)
        let filter = CIFilter(name: colorFilter)
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        //let imageForButton = CIImage(cgImage: filteredImageRef!)
        filterOverCroppedImage = nil
        filterOverCroppedImage = UIImage.init(cgImage: filteredImageRef!)
        self.imageToProcess = filterOverCroppedImage
        return filterOverCroppedImage
    }
    
    // method called when the slider value is changed
    @objc func handleSlider(_ sender: UISlider) {
        
        var inputImage = CIImage()
        if self.imageToProcess == nil{
            //print("No filter applied")
            inputImage = CIImage(image: self.croppedImage!)!
        }
        else{
            //print("Filter applied")
            inputImage = CIImage(image: self.imageToProcess!)!
        }
        var outputImage = CIImage()
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(inputImage, forKey: "inputImage")
        if sender.tag ==  1 {
            filter?.setValue(sender.value, forKey: "inputBrightness") // 0 by default
        } else if sender.tag == 2 {
            filter?.setValue(sender.value, forKey: "inputContrast") // 1 by default
        }
        outputImage = (filter?.outputImage)!
        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        let finalImage = UIImage(cgImage: imageRef!)
        UIView.animate(withDuration: 0.3) {
            self.selectedImage.image = finalImage
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
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
        self.title = "Edit"
    }
    
    func setupUI(){
        setupImageArea()
        setupSelectedImage()
        setupBrightnessSlider()
        setupContrastSlider()
        setupBrightnessLabel()
        setupContrastLabel()
        setupCancelButton()
        setupDoneButton()
        setupCropButton()
        setupColorFilterCollectionView()
    }
    
    func setupImageArea(){
        view.addSubview(imageArea)
        imageArea.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        imageArea.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        imageArea.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        imageArea.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }
    func setupSelectedImage(){
        imageArea.addSubview(selectedImage)
        selectedImage.topAnchor.constraint(equalTo: imageArea.topAnchor).isActive = true
        selectedImage.leftAnchor.constraint(equalTo: imageArea.leftAnchor).isActive = true
        selectedImage.rightAnchor.constraint(equalTo: imageArea.rightAnchor).isActive = true
        selectedImage.heightAnchor.constraint(equalTo: imageArea.heightAnchor, multiplier: 1).isActive = true
    }
    func setupBrightnessSlider(){
        view.addSubview(brightnessSlider)
        brightnessSlider.topAnchor.constraint(equalTo: imageArea.bottomAnchor, constant: 30).isActive = true
        brightnessSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        brightnessSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        brightnessSlider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
    }
    
    func setupContrastSlider(){
        view.addSubview(contrastSlider)
        contrastSlider.topAnchor.constraint(equalTo: imageArea.bottomAnchor, constant: 30).isActive = true
        contrastSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        contrastSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        contrastSlider.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
    }
    
    func setupBrightnessLabel(){
        view.addSubview(brightnessLabel)
        brightnessLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        brightnessLabel.topAnchor.constraint(equalTo: brightnessSlider.bottomAnchor).isActive = true
        brightnessLabel.widthAnchor.constraint(equalTo: brightnessSlider.widthAnchor).isActive = true
    }
    
    func setupContrastLabel(){
        view.addSubview(contrastLabel)
        contrastLabel.leftAnchor.constraint(equalTo: brightnessLabel.rightAnchor, constant: 25).isActive = true
        contrastLabel.topAnchor.constraint(equalTo: contrastSlider.bottomAnchor).isActive = true
        contrastLabel.widthAnchor.constraint(equalTo: contrastSlider.widthAnchor).isActive = true
    }
    
    func setupColorFilterCollectionView(){
        view.addSubview(colorFilterCollectionView)
        colorFilterCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        colorFilterCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        colorFilterCollectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10).isActive = true
        colorFilterCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupCancelButton(){
        view.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    func setupDoneButton(){
        view.addSubview(doneButton)
        doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupCropButton(){
        view.addSubview(cropButton)
        cropButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cropButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cropButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        cropButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    @objc func handleCancel(){
        self.showActionSheet()
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
    
    @objc func handleDone(){
        
        let shippingVC = ShippingAndPaymentViewController()
        shippingVC.selectedPhoto.image = self.selectedImage.image
        self.navigationController?.pushViewController(shippingVC, animated: true)
    }
    
    @objc func handleCrop(){
        guard let image = cropViewProgrammatically.croppedImage else {
            return
        }
        self.croppedImage        = image
        self.selectedImage.image = croppedImage
        self.makeStuffsVisible(image: image)
    }
    func makeStuffsVisible(image: UIImage!){
        UIView.animate(withDuration: 0.3) {
            self.cropViewProgrammatically.alpha  = 0
            self.cropView.alpha                  = 0
            self.doneButton.alpha                = 1
            self.cropButton.alpha                = 0
            self.selectedImage.alpha             = 1
            self.selectedImage.contentMode       = .scaleAspectFit
            self.brightnessLabel.alpha           = 1
            self.brightnessSlider.alpha          = 1
            self.contrastLabel.alpha             = 1
            self.contrastSlider.alpha            = 1
            self.colorFilterCollectionView.alpha = 1
        }
    }
    func makeStuffsInvisible(){
        self.brightnessLabel.alpha           = 0
        self.brightnessSlider.alpha          = 0
        self.contrastLabel.alpha             = 0
        self.contrastSlider.alpha            = 0
        self.colorFilterCollectionView.alpha = 0
    }
    @objc func handleFramePan(_ recognizer: UIPanGestureRecognizer) {
        if let parentView = recognizer.view?.superview {
            let itemToPan = parentView.subviews[0]
            let translation = recognizer.translation(in: selectedImage)
            itemToPan.center = CGPoint(x: itemToPan.center.x + translation.x, y: itemToPan.center.y + translation.y)
            recognizer.setTranslation(.zero, in: selectedImage)
        }
    }
    
    @objc func handleFramePinch(_ recognizer: UIPinchGestureRecognizer) {
        if let parentView = recognizer.view?.superview {
            let itemToPinch = parentView.subviews[0]
            itemToPinch.transform = itemToPinch.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
}
extension EditSelectedPhotoViewController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        print("New crop rectangle: \(rect)")
    }
    
}
extension EditSelectedPhotoViewController: UIActionSheetDelegate{
    
}
extension EditSelectedPhotoViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorFilterArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ColorFilterCollectionViewCell {
            
            DispatchQueue.main.async {
                self.cropViewProgrammatically.image = self.rawPhoto
                cell.filter = self.addFilterForButtonPreview(colorFilter: self.colorFilterArray[indexPath.row])
                cell.filterPreview.layer.cornerRadius = cell.frame.height / 2
            }
            return cell
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath)!
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("did select")
        UIView.animate(withDuration: 0.3, animations: {
            self.selectedImage.image = self.addFilter(colorFilter: self.colorFilterArray[indexPath.row])
        })
    }
}

extension EditSelectedPhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
