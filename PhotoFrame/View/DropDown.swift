//
//  DropDown.swift
//  PhotoFrame
//
//  Created by Al Mobin on 26/11/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
class DropDown: NSObject {
    
    var selectorData = [NSObject]()
    
    var navigationBarHeight : CGFloat!
    var statusBarHeight : CGFloat! = UIApplication.shared.statusBarFrame.height
    var coordinateX : CGFloat! = 0
    var coordinateY : CGFloat! = 0
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0.9, alpha: 0.9)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hide)))
        view.alpha = 0
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.white
        table.allowsMultipleSelection = false
        table.clipsToBounds = true
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    let cellId = "DropDownCell"
    var selectFramVC = SelectFrameViewController()
    
    override init() {
        super.init()
        tableView.register(DropDownCell.self, forCellReuseIdentifier: cellId)
    }
    
    func show(withData tableData: [NSObject]) {
        selectorData = tableData
        setupSubViews()
        tableView.reloadData()
    }
    func setupSubViews() {
        // adding the background view
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(backgroundView)
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 1
            })
            // constraints
            backgroundView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            backgroundView.leftAnchor.constraint(equalTo: window.leftAnchor).isActive = true
            backgroundView.rightAnchor.constraint(equalTo: window.rightAnchor).isActive = true
            backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            
            // adding the container view
            setupContainerView(window: window)
        }
    }
    
    func setupContainerView(window: UIWindow) {
        window.addSubview(containerView)
        let height : CGFloat!
        let width  = window.frame.width * 0.3
        let x = window.frame.width - width
        let y : CGFloat!
        if(self.coordinateX == 0 && self.coordinateY == 0){
             y = self.navigationBarHeight + statusBarHeight
             height = window.frame.height * 0.3
        }
        else{
             y = self.coordinateY + self.navigationBarHeight + statusBarHeight + 35
             height = window.frame.height * 0.3
        }
        containerView.frame = CGRect(x: x, y: y, width: width, height: 0)
        
        setupTableView()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.containerView.frame = CGRect(x: x, y: y, width: width, height: height)
        }, completion: nil)
    }
    
    func setupTableView() {
        containerView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func hide() {
        if let window = UIApplication.shared.keyWindow {
            let width  = window.frame.width * 0.3
            let x = window.frame.width - width
            var y : CGFloat!
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                if(self.coordinateY > 0){
                    y = self.coordinateY + self.navigationBarHeight + self.statusBarHeight + 35
                    self.containerView.frame = CGRect(x: x, y: y, width: self.containerView.frame.width, height: 0)
                }
                else{
                    y = self.navigationBarHeight + self.statusBarHeight
                    self.containerView.frame = CGRect(x: x, y: y, width: self.containerView.frame.width, height: 0)
                }
                self.backgroundView.alpha = 0
            }, completion: nil)
        }
        self.coordinateX = 0
        self.coordinateY = 0
    }
    
}

extension DropDown: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectorData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DropDownCell {
            if let data = selectorData as? [FrameSizeModel] {
                cell.titleText = "\(data[indexPath.row].title)"
            }
            if let data = selectorData as? [ImageSizeModel] {
                cell.titleText = "\(data[indexPath.row].imageSizeTitle)"
            }
            return cell
        } else {
            let cell = tableView.cellForRow(at: indexPath)!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hide()
        if let data = selectorData as? [FrameSizeModel] {
            self.selectFramVC.frameSizeID = "\(data[indexPath.row].id)"
            self.selectFramVC.barButtonTitle = "\(data[indexPath.row].title) ▼"
            self.selectFramVC.customNavigationBar()
            self.selectFramVC.getDefaultImageSize()
        }
        if let data = selectorData as? [ImageSizeModel] {
            self.selectFramVC.changePhotoSizeButtonTitle(title: "\(data[indexPath.row].imageSizeTitle) ▼")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
}
