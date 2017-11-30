//
//  ShippingAndPaymentViewController.swift
//  PhotoFrame
//
//  Created by Creativeitem on 11/14/17.
//  Copyright © 2017 Creativeitem. All rights reserved.
//

import UIKit
import GMStepper
class ShippingAndPaymentViewController: UIViewController {
    
    let cellID = "PaymentDetailsTableCell"
    
    lazy var selectedPhoto : UIImageView = {
        var photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.semanticContentAttribute = .unspecified
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    lazy var frame : UIImageView = {
        var photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    lazy var addShippingAddressButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Shipping Address", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red:0.22, green:0.69, blue:0.91, alpha:1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddShippingAdressButton), for: .touchUpInside)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 21)
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = BG_COLOR
        table.allowsMultipleSelection = false
        table.clipsToBounds = true
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        return table
    }()
    lazy var stepper: GMStepper = {
        let stepper = GMStepper()
        stepper.autorepeat = true
        stepper.minimumValue = 1
        stepper.maximumValue = 100
        stepper.stepValue = 1
        stepper.labelFont = UIFont(name: TEXT_FONT, size: 18)!
        stepper.buttonsFont = UIFont(name: TEXT_FONT, size: 24)!
        stepper.labelTextColor = UIColor(red:0.08, green:0.40, blue:0.75, alpha:1.0)
        stepper.labelBackgroundColor = UIColor.white
        stepper.buttonsBackgroundColor = UIColor(red:0.13, green:0.59, blue:0.95, alpha:1.0)
        stepper.cornerRadius = 0
        stepper.borderColor = UIColor(red:0.08, green:0.40, blue:0.75, alpha:1.0)
        stepper.borderWidth = 1
        stepper.clipsToBounds = true
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(handleStepper), for: .touchUpInside)
        return stepper
    }()
    lazy var addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Note +", for: .normal)
        button.setTitleColor(UIColor(red:0.08, green:0.40, blue:0.75, alpha:1.0), for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddNoteButton), for: .touchUpInside)
        button.titleLabel!.font =  UIFont(name: TEXT_FONT, size: 17)
        /*button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowColor = UIColor.init(white: 0.5, alpha: 1).cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5*/
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PaymentDetailsTableCell.self, forCellReuseIdentifier: cellID)
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = BG_COLOR
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // setting the frame from session
        self.frame.sd_setImage(with: URL(string: "\(UserDefaults.standard.value(forKey: FRAME_URL) as! String)"))
        setupUI()
    }
    @objc func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customNavigationBar()
    }
    func customNavigationBar(){
        navigationController?.navigationBar.shadowImage = UIImage() // this line makes the navigation bar borderless.
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 3)
        navigationController?.navigationBar.layer.shadowRadius = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.1
        self.title = "Shipping And Payment"
    }
    
    func setupUI(){
        setupSelectedImageView()
        setupWithRatio()
        overLayFrame()
        setupAddShippingAddressButton()
        setupTableView()
        setupStepper()
        setupAddNoteButton()
    }
    
    func setupSelectedImageView(){
        let viewWidth = self.view.frame.width
        let imageViewHeight = ((viewWidth * 0.7) - (63 * 2))
        view.addSubview(selectedPhoto)
        selectedPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: (25 + 63)).isActive = true
        selectedPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectedPhoto.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
    }
    func setupWithRatio(){
        UIView.animate(withDuration: 0.3) {
            self.selectedPhoto.widthAnchor.constraint(equalTo: self.selectedPhoto.heightAnchor, multiplier: 0.8).isActive = true
        }
    }
    func overLayFrame(){
        view.addSubview(self.frame)
        frame.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        frame.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        frame.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    func setupStepper(){
        view.addSubview(stepper)
        // constraints
        stepper.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        stepper.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -40).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 25).isActive = true
        stepper.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
    }
    func setupAddNoteButton(){
        view.addSubview(addNoteButton)
        // constraints
        addNoteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        addNoteButton.centerYAnchor.constraint(equalTo: stepper.centerYAnchor).isActive = true
        addNoteButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        addNoteButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
    }
    func setupAddShippingAddressButton(){
        view.addSubview(addShippingAddressButton)
        addShippingAddressButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addShippingAddressButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        addShippingAddressButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
    func setupTableView(){
        view.addSubview(tableView)
        tableView.bottomAnchor.constraint(equalTo: addShippingAddressButton.topAnchor, constant: -10).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
    }
}

extension ShippingAndPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? PaymentDetailsTableCell {
            if(indexPath.row == 0){
                cell.framingAndPrintingCostTitleLabel.text = "Framing And Shipping Cost"
                cell.framingCost = "\(UserDefaults.standard.value(forKey: FRAME_PRICE) as! String) BDT"
            }
            else if(indexPath.row == 1){
                cell.framingAndPrintingCostTitleLabel.text = "Shipping And Handling Cost"
                cell.framingCost = "0 BDT"
            }
            else if(indexPath.row == 2){
                cell.framingAndPrintingCostTitleLabel.text = "Total"
                cell.framingCost = "\(UserDefaults.standard.value(forKey: FRAME_PRICE) as! String) BDT"
            }
            return cell
        } else {
            let cell = tableView.cellForRow(at: indexPath)!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
}

// action methods
extension ShippingAndPaymentViewController {
    @objc func handleAddShippingAdressButton(){
        
    }
    @objc func handleAddNoteButton(){
        
    }
    @objc func handleStepper(){
        print(stepper.value)
    }
}
class PaymentDetailsTableCell: UITableViewCell {
    
    let framingAndPrintingCostTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: TEXT_FONT, size: 17)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Framing And Printing Cost"
        return label
    }()
    let framingAndPrintingCostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: TEXT_FONT, size: 17)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let shippingCostTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: TEXT_FONT, size: 14)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Shipping And Hadling Cost"
        return label
    }()
    
    let shippingCostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: TEXT_FONT, size: 14)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let totalCostTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: TEXT_FONT, size: 14)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Total"
        return label
    }()
    
    let totalCostLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.font = UIFont(name: TEXT_FONT, size: 14)
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    var framingCost: String? = ""{
        didSet {
            framingAndPrintingCostLabel.text = framingCost
        }
    }
    
    var shippingCost: String? = ""{
        didSet {
            shippingCostLabel.text = shippingCost
        }
    }
    
    var totalCost: String? = ""{
        didSet {
            totalCostLabel.text = totalCost
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = BG_COLOR
        self.selectionStyle = .default
        setupSubviews()
    }
    
    func setupSubviews() {
        setupFramingAndPrintingCostTitleLabel()
        setupFramingAndPrintingCostLabel()
        /*setupShippingCostTitleLabel()
        setupShippingCostLabel()
        setupTotalCostTitleLabel()
        setupTotalCostLabel()*/
    }
    
    func setupFramingAndPrintingCostTitleLabel(){
        self.addSubview(framingAndPrintingCostTitleLabel)
        framingAndPrintingCostTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        framingAndPrintingCostTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        framingAndPrintingCostTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupFramingAndPrintingCostLabel(){
        self.addSubview(framingAndPrintingCostLabel)
        framingAndPrintingCostLabel.centerYAnchor.constraint(equalTo: framingAndPrintingCostTitleLabel.centerYAnchor).isActive = true
        framingAndPrintingCostLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        framingAndPrintingCostLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupShippingCostTitleLabel(){
        self.addSubview(shippingCostTitleLabel)
        shippingCostTitleLabel.topAnchor.constraint(equalTo: framingAndPrintingCostTitleLabel.topAnchor, constant: 10).isActive = true
        shippingCostTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        shippingCostTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupShippingCostLabel(){
        self.addSubview(shippingCostLabel)
        shippingCostLabel.centerYAnchor.constraint(equalTo: shippingCostTitleLabel.centerYAnchor).isActive = true
        shippingCostLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        shippingCostLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupTotalCostTitleLabel(){
        self.addSubview(totalCostTitleLabel)
        totalCostTitleLabel.topAnchor.constraint(equalTo: shippingCostTitleLabel.topAnchor, constant: 10).isActive = true
        totalCostTitleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        totalCostTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
    }
    func setupTotalCostLabel(){
        self.addSubview(totalCostLabel)
        totalCostLabel.centerYAnchor.constraint(equalTo: totalCostTitleLabel.centerYAnchor).isActive = true
        totalCostLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        totalCostLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
