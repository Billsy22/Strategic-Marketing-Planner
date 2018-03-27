//
//  AddClientModalViewController.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit

class AddClientModalViewController: UIViewController {

    // MARK: -  Properites
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var clientPhotoButton: UIButton!
    @IBOutlet weak var practiceNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var initialContactDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveOrRemoveClientButton: UIButton!
    var client: Client? {
        didSet {
            saveOrRemoveClientButton.titleLabel?.text = "Delete Client"
        }
    }
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: -  Update Views
    func updateViews() {
        guard let client = client else { print("No Client Found \(#file)\(#function)"); return }
        firstNameTextField.text = client.firstName
        lastNameTextField.text = client.lastName
        // TODO: -  Add photo property for button
        practiceNameTextField.text = client.practiceName
        phoneTextField.text = client.phoneNumber
        emailTextField.text = client.email
        addressTextField.text = client.streetAddress
        cityTextField.text = client.city
        stateTextField.text = client.state
        zipCodeTextField.text = client.zip
        guard let contactDate = client.contactDate else { print("No contact date for client"); return }
        initialContactDateTextField.text = "\(contactDate)"
        notesTextView.text = client.notes
    }
    
    // MARK: -  Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            print("View Dismissed")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
