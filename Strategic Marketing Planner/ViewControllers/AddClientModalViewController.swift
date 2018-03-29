//
//  AddClientModalViewController.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import AVKit

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
    @IBOutlet weak var startPresentationButton: UIButton!
    var client: Client?
    var activeTextField: UITextField?
    let imagePicker = UIImagePickerController()
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        practiceNameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    // MARK: -  Update Views
    func updateViews() {
        notesTextView.layer.cornerRadius = 5
        notesTextView.layer.borderWidth = 0.1
        firstNameTextField.layer.cornerRadius = 5
        lastNameTextField.layer.cornerRadius = 5
        practiceNameTextField.layer.cornerRadius = 5
        phoneTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        addressTextField.layer.cornerRadius = 5
        cityTextField.layer.cornerRadius = 5
        stateTextField.layer.cornerRadius = 5
        zipCodeTextField.layer.cornerRadius = 5
        initialContactDateTextField.layer.cornerRadius = 5
        saveOrRemoveClientButton.layer.cornerRadius = 5
        startPresentationButton.layer.cornerRadius = 5
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
        save()
    }
    
    @IBAction func saveOrRemoveClientButtonTapped(_ sender: Any) {
        if let client = client {
            deleteConfirmation(client: client)
        } else {
            save()
        }
    }
    
    @IBAction func startPresentationButtonTapped(_ sender: Any) {
        save()
    }
    
    @IBAction func clientPhotoButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPresentationVC" {
            guard let destinationVC = segue.destination as? UINavigationController, let presentationVC = destinationVC.viewControllers.first as? PresentationBaseViewController, let client = ClientController.shared.clients.last else { return }
            presentationVC.client = client
        }
    }
}

// MARK: -  Extension for DRY methods
extension AddClientModalViewController {
    
    // Save Client
    func save() {
        guard let firstName = self.firstNameTextField.text,
            let lastName = self.lastNameTextField.text,
            let practiceName = self.practiceNameTextField.text,
            let phone = self.phoneTextField.text,
            let email = self.emailTextField.text,
            let streetAddress = self.addressTextField.text,
            let zip = self.zipCodeTextField.text,
            let city = self.cityTextField.text,
            let state = self.stateTextField.text,
            let initialContactDateString = self.initialContactDateTextField.text,
            let notes = self.notesTextView.text else { return }
        if firstName.isEmpty || lastName.isEmpty || practiceName.isEmpty || phone.isEmpty || email.isEmpty || streetAddress.isEmpty || streetAddress.isEmpty || zip.isEmpty {
            self.createEmptyTextAlert()
        } else {
            let initialContactDate = DateHelper.dateFrom(string: initialContactDateString)
            ClientController.shared.addClient(withFirstName: firstName, lastName: lastName, practiceName: practiceName, phone: phone, email: email, streetAddress: streetAddress, city: city, state: state, zip: zip, initialContactDate: initialContactDate, notes: notes)
            dismiss(animated: true, completion: {
                print("Client Created")
            })
        }
    }
    
    // Creating an alert when textfields are empty
    func createEmptyTextAlert() {
        let emptyTextAlert = UIAlertController(title: "Required text field empty", message: "Please fill out all required text fields", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("Alert Dismissed")
        })
        emptyTextAlert.addAction(okAction)
        self.present(emptyTextAlert, animated: true, completion: nil)
    }
    
    // Create a delete confirmation alert when hitting delete button
    func deleteConfirmation(client: Client) {
        let deleteConfirmationAlert = UIAlertController(title: "Delete Client", message: "Are you sure you want to delete this client?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            print("Action Cancelled")
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            ClientController.shared.removeClient(client)
            self.dismiss(animated: true, completion: nil)
            print("Client Deleted")
        }
        deleteConfirmationAlert.addAction(cancelAction)
        deleteConfirmationAlert.addAction(deleteAction)
        self.present(deleteConfirmationAlert, animated: true, completion: nil)
    }
}

// MARK: -  Extension for textfields and keyboard appearance
extension AddClientModalViewController: UITextFieldDelegate {

    // Return key moves to the next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            textField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            textField.resignFirstResponder()
            practiceNameTextField.becomeFirstResponder()
        } else if textField == practiceNameTextField {
            textField.resignFirstResponder()
            phoneTextField.becomeFirstResponder()
        } else if textField == phoneTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            addressTextField.becomeFirstResponder()
        } else if textField == addressTextField {
            textField.resignFirstResponder()
            cityTextField.becomeFirstResponder()
        } else if textField == cityTextField {
            textField.resignFirstResponder()
            stateTextField.becomeFirstResponder()
        } else if textField == stateTextField {
            textField.resignFirstResponder()
            zipCodeTextField.becomeFirstResponder()
        } else if textField == zipCodeTextField {
            textField.resignFirstResponder()
            notesTextView.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    // Dismiss keyboard when touching outside the keyboard or textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // move view based on textfield
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name == Notification.Name.UIKeyboardWillChangeFrame || notification.name == Notification.Name.UIKeyboardWillShow {
        if activeTextField == emailTextField || activeTextField == addressTextField {
            view.frame.origin.y = view.frame.origin.y - 50
        } else if activeTextField == cityTextField || activeTextField == stateTextField || activeTextField == zipCodeTextField {
            view.frame.origin.y = view.frame.origin.y - 100
            }
        } else {
            view.frame.origin.y = 0
        }
    }
}

// MARK: -  Extention for AVKit
extension AddClientModalViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let clientImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        clientPhotoButton.setBackgroundImage(clientImage, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
