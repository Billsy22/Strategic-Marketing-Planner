//
//  PracticeTypeDropDownButton.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 4/5/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class PracticeTypeDropDownButton: UIButton {
    
    // MARK: -  Properties
    var dropDownView = DropDownView()
    var dropDownHeight = NSLayoutConstraint()
    var isOpen = false
    
    // MARK: -  Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        dropDownView = DropDownView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
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
    }
    
    // MARK: -  Event methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.dropDownHeight])
            self.dropDownHeight.constant = 150
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
}

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -  Instance Properties
    var dropDownOptions: [String] = []
    var tableView = UITableView()
    
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
        cell.textLabel?.text = "\(Client.practiceTypes[indexPath.row])".capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
