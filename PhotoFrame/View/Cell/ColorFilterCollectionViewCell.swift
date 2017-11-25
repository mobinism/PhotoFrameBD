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
            /*let resizedImage = self.resizeImage(image: filter!, targetSize: CGSize(width: 80.0, height: 80.0))
            self.filterPreview.image = resizedImage*/
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
    
    //resize image for filter preview
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
