//
//  FrameCollectionViewCell.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/10/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class FrameCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red:0.01, green:0.66, blue:0.90, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 20)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    var text: String? = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BG_COLOR
        self.layer.masksToBounds = false
        setupSubviews()
    }
    
    func setupSubviews() {
        
        self.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        textLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        self.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        //imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
