//
//  AlbumTitleCollectionViewCell.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/26/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class AlbumTitleCollectionViewCell: UICollectionViewCell {
    
    lazy var albumTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        //label.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        label.textColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 18)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    var text: String? = "" {
        didSet {
            albumTitle.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BG_COLOR
        setupSubviews()
    }
    
    func setupSubviews() {
        self.addSubview(albumTitle)
        albumTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        albumTitle.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        albumTitle.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

