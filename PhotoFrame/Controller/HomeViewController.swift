//
//  HomeViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/10/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit

struct ImageArray{
    var imagesArray = [UIImage!]()
}

class HomeViewController: UIViewController {
    
    lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"menu"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = BG_COLOR
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
        return button
    }()
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Framing", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red:0.22, green:0.69, blue:0.91, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 21)
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        return button
    }()
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let featuredImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "featured_image")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "Lets Make Your Moments Captured, Framed and Delivered..."
        label.font = UIFont(name: TEXT_FONT, size: 17)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = BG_COLOR
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func setupUI(){
        setupMenuButton()
        setupLogoImageView()
        setupSubtitleLabel()
        setupFeaturedImageView()
        setupStartButton()
    }
    func setupMenuButton(){
        view.addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        menuButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        menuButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        menuButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
    }
    func setupLogoImageView(){
        view.addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: menuButton.bottomAnchor).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupSubtitleLabel(){
        view.addSubview(subTitleLabel)
        subTitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30).isActive = true
        subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subTitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    func setupFeaturedImageView(){
        view.addSubview(featuredImageView)
        featuredImageView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 60).isActive = true
        featuredImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        featuredImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        featuredImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    func setupStartButton(){
        view.addSubview(startButton)
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    @objc func handleStartButton(){
        self.navigationController?.pushViewController(SelectSizeViewController(), animated: true)
    }
    @objc func handleMenuButton(){
        
    }
}

