//
//  ShippingAndPaymentViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 11/14/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class ShippingAndPaymentViewController: UIViewController {
    var frameArray = [#imageLiteral(resourceName: "Frame-1"), #imageLiteral(resourceName: "Frame-2"), #imageLiteral(resourceName: "Frame-3"), #imageLiteral(resourceName: "Frame-4"), #imageLiteral(resourceName: "Frame-5"), #imageLiteral(resourceName: "Frame-6"), #imageLiteral(resourceName: "Frame-7"), #imageLiteral(resourceName: "Frame-8"), #imageLiteral(resourceName: "Frame-9"), #imageLiteral(resourceName: "Frame-10"), #imageLiteral(resourceName: "Frame-11"), #imageLiteral(resourceName: "Frame-12")]
    lazy var selectedPhoto : UIImageView = {
        var photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        photo.semanticContentAttribute = .unspecified
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
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
        //print(UserDefaults.standard.value(forKey: FRAME_ID) as! String)
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = BG_COLOR
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        let frameID : Int = Int(UserDefaults.standard.value(forKey: FRAME_ID) as! String)!
        if frameID >= 0 {
            self.frame.image = self.frameArray[frameID]
        }
        setupUI()
    }
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.title = "Shipping And Payment"
    }
    
    func setupUI(){
        setupSelectedImageView()
        overLayFrame()
    }
    
    func setupSelectedImageView(){
        view.addSubview(selectedPhoto)
        selectedPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        selectedPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedPhoto.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        selectedPhoto.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    func overLayFrame(){
        selectedPhoto.addSubview(frame)
        frame.topAnchor.constraint(equalTo: selectedPhoto.topAnchor).isActive = true
        frame.leftAnchor.constraint(equalTo: selectedPhoto.leftAnchor).isActive = true
        frame.rightAnchor.constraint(equalTo: selectedPhoto.rightAnchor).isActive = true
        frame.bottomAnchor.constraint(equalTo: selectedPhoto.bottomAnchor).isActive = true
    }
}
