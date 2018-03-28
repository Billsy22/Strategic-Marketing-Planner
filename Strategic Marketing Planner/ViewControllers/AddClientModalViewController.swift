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
    var client: Client?
    weak var delegate: AddClientModalViewControllerDelegate?
    let imagePicker = UIImagePickerController()
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
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
        save()
    }
    
    @IBAction func saveOrRemoveClientButtonTapped(_ sender: Any) {
        if let client = client {
        ClientController.shared.removeClient(client)
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
    
    // Creating an alert when textfields are empty
    func createEmptyTextAlert() {
        let emptyTextAlert = UIAlertController(title: "Required text field empty", message: "Please fill out all required text fields", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            print("Alert Dismissed")
        })
        emptyTextAlert.addAction(okAction)
        self.present(emptyTextAlert, animated: true, completion: nil)
    }
    
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

// MARK: -  Delegate for adding client
protocol AddClientModalViewControllerDelegate: class {
    func clientAdded()
}
