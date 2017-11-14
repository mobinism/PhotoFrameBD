//
//  ColorFilterCollectionViewCell.swift
//  PhotoFrame
//
//  Created by Creativeitem on 11/12/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class ColorFilterCollectionViewCell: UICollectionViewCell {
    let filterPreview : UIImageView = {
        let filter = UIImageView()
        filter.contentMode = .scaleAspectFill
        filter.clipsToBounds = true
        filter.translatesAutoresizingMaskIntoConstraints = false
        return filter
    }()
    
    let filterTitle : UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 12)
        return label
    }()
    
    var filter: UIImage? = nil {
        didSet {
            filterPreview.image = filter
        }
    }
    
    var title : String? = ""{
        didSet{
            self.filterTitle.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = BG_COLOR
        setupSubviews()
    }
    
    func setupSubviews(){
        setupFilterPreview()
    }
    func setupFilterPreview(){
        self.addSubview(filterPreview)
        filterPreview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        filterPreview.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        filterPreview.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        filterPreview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
