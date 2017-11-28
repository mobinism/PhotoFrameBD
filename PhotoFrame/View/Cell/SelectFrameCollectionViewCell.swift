//
//  SelectFrameCollectionViewCell.swift
//  PhotoFrame
//
//  Created by Creativeitem on 10/30/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class SelectFrameCollectionViewCell: UICollectionViewCell {
    
    lazy var selectFrame : UIImageView = {
        var frame = UIImageView()
        frame.contentMode = .scaleAspectFit
        frame.clipsToBounds = true
        frame.translatesAutoresizingMaskIntoConstraints = false
        return frame
    }()
    lazy var frameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.0)
        label.font = UIFont(name: TEXT_FONT, size: 14)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    var frameTitle: String? = "" {
        didSet {
            frameLabel.text = frameTitle
        }
    }
    var frameImage: UIImage? = nil{
        didSet {
            selectFrame.image = frameImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.91, green:0.92, blue:0.94, alpha:1.0)
        setupSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        selectFrame.image = nil
    }
    
    func setupSubviews() {
        setupFrame()
        setupFrameTitle()
    }
    
    func setupFrame(){
        self.addSubview(selectFrame)
        self.selectFrame.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.selectFrame.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        self.selectFrame.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        self.selectFrame.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55).isActive = true
        
    }
    func setupFrameTitle(){
        self.addSubview(frameLabel)
        self.frameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.frameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        self.frameLabel.topAnchor.constraint(equalTo: self.selectFrame.bottomAnchor, constant: 15).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
