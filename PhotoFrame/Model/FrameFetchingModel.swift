//
//  FrameFetchingModel.swift
//  PhotoFrame
//
//  Created by Al Mobin on 28/11/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import Foundation
class FrameFetchingModel: NSObject {
    private var _frameUrl: String
    private var _frameTitle: String
    private var _framePrice: String
    
    var frameUrl: String {
        get {
            return _frameUrl
        }
    }
    var frameTitle: String {
        get {
            return _frameTitle
        }
    }
    var framePrice: String {
        get {
            return _framePrice
        }
    }
    init(frameUrl: String, frameTitle: String, framePrice : String) {
        self._frameUrl = frameUrl
        self._frameTitle = frameTitle
        self._framePrice = framePrice
    }
}

class DefaultImageSize: NSObject {
    private var _imageSizeTitle: String
    private var _imageSizeId: String
    
    var imageSizeTitle: String {
        get {
            return _imageSizeTitle
        }
    }
    var imageSizeId: String {
        get {
            return _imageSizeId
        }
    }
    init(imageSizeTitle: String, imageSizeId: String) {
        self._imageSizeTitle = imageSizeTitle
        self._imageSizeId = imageSizeId
    }
}
