//
//  DropDownReusableModel.swift
//  PhotoFrame
//
//  Created by Creativeitem on 11/27/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import Foundation
class FrameSizeModel: NSObject {
    private var _id: String
    private var _title: String
    
    var id: String {
        get {
            return _id
        }
    }
    var title: String {
        get {
            return _title
        }
    }
    init(id: String, title: String) {
        self._id = id
        self._title = title
    }
}
class ImageSizeModel: NSObject {
    private var _imageSizeId: String
    private var _imageSizeTitle: String
    private var _frameSizeId: String
    
    var imageSizeId: String {
        get {
            return _imageSizeId
        }
    }
    var imageSizeTitle: String {
        get {
            return _imageSizeTitle
        }
    }
    var frameSizeId: String {
        get {
            return _frameSizeId
        }
    }
    init(imageSizeId: String, imageSizeTitle: String, frameSizeId: String) {
        self._imageSizeId = imageSizeId
        self._imageSizeTitle = imageSizeTitle
        self._frameSizeId = frameSizeId
    }
}
