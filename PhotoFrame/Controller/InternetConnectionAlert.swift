//
//  InternetConnectionAlert.swift
//  PhotoFrame
//
//  Created by Al Mobin on 30/11/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class InternetConnectionAlert: UIViewController {
    
    let alertBackgroundLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.backgroundColor = UIColor(red:1.00, green:0.44, blue:0.26, alpha:1.0).cgColor
        label.layer.cornerRadius = 5
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 6
        label.layer.masksToBounds = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHome)))
        return label
    }()
    let alertSignImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "broken-chain")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var alertTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var alertMessage: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: TEXT_FONT, size: 17)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var goToHomeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named:"white-home-icon"), for: .normal)
        button.contentHorizontalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleHome), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view?.backgroundColor = UIColor(white: 1, alpha: 0)
        setupUI()
    }
    func setupUI(){
        setupAlertBackgroundLabel()
        showAlertSign()
        showAlertTitle()
        showAlertMessage()
        showButton()
    }
    func setupAlertBackgroundLabel(){
        view.addSubview(alertBackgroundLabel)
        alertBackgroundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //alertBackgroundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertBackgroundLabel.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive = true
        alertBackgroundLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive = true
        alertBackgroundLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    func showAlertSign(){
        alertBackgroundLabel.addSubview(alertSignImageView)
        alertSignImageView.centerXAnchor.constraint(equalTo: alertBackgroundLabel.centerXAnchor).isActive = true
        alertSignImageView.topAnchor.constraint(equalTo: alertBackgroundLabel.topAnchor, constant: 10).isActive = true
        alertSignImageView.heightAnchor.constraint(equalTo: alertBackgroundLabel.heightAnchor, multiplier: 0.4).isActive = true
        alertSignImageView.widthAnchor.constraint(equalTo: alertBackgroundLabel.heightAnchor, multiplier: 0.4).isActive = true
    }
    func showAlertTitle(){
        alertBackgroundLabel.addSubview(alertTitle)
        alertTitle.topAnchor.constraint(equalTo: alertSignImageView.bottomAnchor, constant: 5).isActive = true
        alertTitle.centerXAnchor.constraint(equalTo: alertSignImageView.centerXAnchor).isActive = true
        alertTitle.widthAnchor.constraint(equalTo: alertBackgroundLabel.widthAnchor, multiplier: 0.8).isActive = true
        alertTitle.heightAnchor.constraint(equalTo: alertBackgroundLabel.heightAnchor, multiplier: 0.1).isActive = true
    }
    func showAlertMessage(){
        alertBackgroundLabel.addSubview(alertMessage)
        alertMessage.centerXAnchor.constraint(equalTo: alertSignImageView.centerXAnchor).isActive = true
        alertMessage.topAnchor.constraint(equalTo: alertTitle.bottomAnchor, constant: 7).isActive = true
        alertMessage.widthAnchor.constraint(equalTo: alertBackgroundLabel.widthAnchor, multiplier: 0.8).isActive = true
        alertMessage.heightAnchor.constraint(equalTo: alertBackgroundLabel.heightAnchor, multiplier: 0.2).isActive = true
    }
    func showButton(){
        alertBackgroundLabel.addSubview(goToHomeButton)
        goToHomeButton.centerXAnchor.constraint(equalTo: alertSignImageView.centerXAnchor).isActive = true
        goToHomeButton.bottomAnchor.constraint(equalTo: alertBackgroundLabel.bottomAnchor, constant: -10).isActive = true
        goToHomeButton.heightAnchor.constraint(equalTo: alertBackgroundLabel.heightAnchor, multiplier: 0.2).isActive = true
        goToHomeButton.widthAnchor.constraint(equalTo: alertBackgroundLabel.heightAnchor, multiplier: 0.2).isActive = true
    }
    @objc func handleHome(){
        self.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}

