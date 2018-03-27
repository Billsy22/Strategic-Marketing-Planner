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
    var client: Client?
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: -  Update Views
    func updateViews() {
        if let client = client {
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
            saveOrRemoveClientButton.setTitle("Delete Client", for: .normal)
            saveOrRemoveClientButton.backgroundColor = .red
        } else {
            print("No Client Found \(#file)\(#function)")
            saveOrRemoveClientButton.setTitle("Save Client", for: .normal)
            saveOrRemoveClientButton.backgroundColor = .brandBlue
            return
        }
    }
    
    // MARK: -  Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            print("View Dismissed")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
        let lastName = lastNameTextField.text,
        let practiceName = practiceNameTextField.text,
        let phone = phoneTextField.text,
        let email = emailTextField.text,
        let streetAddress = addressTextField.text,
            let zip = zipCodeTextField.text,
        let city = cityTextField.text,
        let state = stateTextField.text,
        let initialContactDateString = initialContactDateTextField.text,
            let notes = notesTextView.text else { return }
            if firstName.isEmpty || lastName.isEmpty || practiceName.isEmpty || phone.isEmpty || email.isEmpty || streetAddress.isEmpty || streetAddress.isEmpty || zip.isEmpty {
            let emptyTextAlert = UIAlertController(title: "Required text field empty", message: "Please fill out anything with a *", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                print("Alert Dismissed")
            })
            emptyTextAlert.addAction(okAction)
            present(emptyTextAlert, animated: true, completion: nil)
        } else {
                let initialContactDate = DateHelper.dateFrom(string: initialContactDateString)
            ClientController.shared.addClient(withFirstName: firstName, lastName: lastName, practiceName: practiceName, phone: phone, email: email, streetAddress: streetAddress, city: city, state: state, zip: zip, initialContactDate: initialContactDate, notes: notes)
                dismiss(animated: true, completion: {
                    print("Client Created")
                })
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
