//
//  PracticeTypeDropDownButton.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 4/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class PracticeTypeDropDownButton: UIButton, DropDownProtocol {
    
    // MARK: -  Properties
    var dropDownView = DropDownView()
    var dropDownHeight = NSLayoutConstraint()
    var isOpen = false
    
    // MARK: -  Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        dropDownView = DropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropDownView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -  Life Cycles
    override func didMoveToSuperview() {
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubview(toFront: dropDownView)
        dropDownView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropDownView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropDownView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        dropDownHeight = dropDownView.heightAnchor.constraint(equalToConstant: 0)
        dropDownView.layer.zPosition = 2
    }
    
    // MARK: -  Event methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.dropDownHeight])
            if self.dropDownView.tableView.contentSize.height > 150 {
                self.dropDownHeight.constant = 150
            } else {
                self.dropDownHeight.constant = self.dropDownView.tableView.contentSize.height
            }
            NSLayoutConstraint.activate([self.dropDownHeight])
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropDownView.layoutIfNeeded()
                self.dropDownView.center.y += self.dropDownView.frame.height / 2            }, completion: nil)
        } else {
            isOpen = false
            NSLayoutConstraint.deactivate([self.dropDownHeight])
            self.dropDownHeight.constant = 0
            NSLayoutConstraint.activate([self.dropDownHeight])
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropDownView.center.y -= self.dropDownView.frame.height / 2
                self.dropDownView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    // MARK: -  Protocol Method
    func dropDownItemSelected(item: String) {
        self.setTitle(item, for: .normal)
    }
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -  Instance Properties
    var dropDownOptions: [String] = []
    var tableView = UITableView()
    var delegate: DropDownProtocol?
    
    // MARK: -  Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: -  Table View Data Source Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Client.practiceTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
        cell.textLabel?.text = "\(Client.practiceTypes[indexPath.row])".capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.dropDownItemSelected(item: "\(Client.practiceTypes[indexPath.row])")
    }
}

protocol DropDownProtocol {
    func dropDownItemSelected(item: String)
}
