//
//  AddClientModalViewController.swift
//  Strategic Marketing Planner
//
//  Created by Taylor Bills on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import AVKit


protocol AddClientDelegate: class {
    func presentationStarting()
}

class AddClientModalViewController: UIViewController {
    
    // MARK: -  Properites
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var clientPhotoButton: UIButton!
    @IBOutlet weak var practiceNameTextField: UITextField!
    @IBOutlet weak var practiceTypeButton: UIButton!
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
    weak var delegate: AddClientDelegate?
    var practiceTypeListOpen: Bool = false
    let pickerData = ["Select Type...", "\(Client.practiceTypes[0])".capitalized, "\(Client.practiceTypes[1])".capitalized, "\(Client.practiceTypes[2])".capitalized]
    
    // Picker Properties
    private lazy var pickerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brandPaleBlue
        return view
    }()
    
    private lazy var practicePicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    
    
    // MARK: -  Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Update Views
        updateViews()
        setUpClientPhotoButtonProperties()
        setupPickerViews()
        pickerContainer.isHidden = true
        emailTextField.placeholder = "e.g. john@example.com"
        phoneTextField.placeholder = "e.g. (555) 123-4567"
        
        // Set Delegates
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        practiceNameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        addressTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        imagePicker.delegate = self
        practicePicker.delegate = self
        practicePicker.dataSource = self
        
        // Keyboard NotificationCenter observers to move the views frame depending on which text field its in
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
        practiceTypeButton.layer.cornerRadius = 5
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
            practiceNameTextField.text = client.practiceName
            phoneTextField.text = client.phoneNumber
            emailTextField.text = client.email
            addressTextField.text = client.streetAddress
            cityTextField.text = client.city
            stateTextField.text = client.state
            zipCodeTextField.text = client.zip
            guard let contactDate = client.contactDate else { print("No contact date for client"); return }
            let formattedContactedDate = DateHelper.format(date: contactDate as Date)
            initialContactDateTextField.text = "\(formattedContactedDate)"
            notesTextView.text = client.notes
            saveOrRemoveClientButton.setTitle("Delete Client", for: .normal)
            saveOrRemoveClientButton.backgroundColor = .red
            guard let practiceType = client.practiceType?.capitalized else { return }
            practiceTypeButton.setTitle(practiceType, for: .normal)
            guard let clientImage = client.imageData else { print("No Client image data"); return }
            clientPhotoButton.setBackgroundImage(UIImage(data: clientImage), for: .normal)
        } else {
            print("No Client Found \(#file)\(#function)")
            saveOrRemoveClientButton.setTitle("Save Client", for: .normal)
            saveOrRemoveClientButton.backgroundColor = .brandBlue
            let formattedDate = DateHelper.format(date: Date())
            initialContactDateTextField.text = formattedDate
        }
    }
    
    func setUpClientPhotoButtonProperties() {
        clientPhotoButton.clipsToBounds = true
        clientPhotoButton.layer.cornerRadius = clientPhotoButton.frame.width/2
        clientPhotoButton.layer.borderWidth = 0.1
        clientPhotoButton.imageView?.contentMode = .scaleAspectFill
    }
    
    func setupPickerViews() {
        view.addSubview(pickerContainer)
        pickerContainer.addSubview(practicePicker)
    }
    
    // MARK: -  Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true) {
            print("View Dismissed")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        formatPhone()
        if validateTextFields() == true {
            save()
        }
    }
    
    @IBAction func saveOrRemoveClientButtonTapped(_ sender: Any) {
        if let client = client {
            deleteConfirmation(client: client)
        } else {
            save()
        }
    }
    
    @IBAction func practiceTypeButtonTapped(_ sender: Any) {
        if practiceTypeListOpen == false {
            practiceTypeListOpen = true
            setupPickerAndContainer()
        } else {
            practiceTypeListOpen = false
            setupPickerAndContainer()
        }
    }
    
    @IBAction func startPresentationButtonTapped(_ sender: Any) {
        formatPhone()
        if validateTextFields() == true {
            save()
            ClientController.shared.currentClient = self.client
            delegate?.presentationStarting()
        }
    }
    
    @IBAction func clientPhotoButtonTapped(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: -  Extension for DRY methods
extension AddClientModalViewController {
    
    // Constrain picker container and picker
    func setupPickerAndContainer() {
        pickerContainer.translatesAutoresizingMaskIntoConstraints = false
        practicePicker.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: pickerContainer, attribute: .width, relatedBy: .equal, toItem: practiceTypeButton, attribute: .width, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: pickerContainer, attribute: .top, relatedBy: .equal, toItem: practiceTypeButton, attribute: .bottom, multiplier: 1, constant: -5)
        let rightConstraint = NSLayoutConstraint(item: pickerContainer, attribute: .trailing, relatedBy: .equal, toItem: practiceTypeButton, attribute: .trailing, multiplier: 1, constant: 0)
        let containerHeight = NSLayoutConstraint(item: pickerContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150)
        self.view.addConstraints([topConstraint, rightConstraint, widthConstraint, containerHeight])
        let pickerLeftConstraint = NSLayoutConstraint(item: practicePicker, attribute: .leading, relatedBy: .equal, toItem: pickerContainer, attribute: .leading, multiplier: 1, constant: 0)
        let pickerRightConstraint = NSLayoutConstraint(item: practicePicker, attribute: .trailing, relatedBy: .equal, toItem: pickerContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let pickerTopConstraint = NSLayoutConstraint(item: practicePicker, attribute: .top, relatedBy: .equal, toItem: pickerContainer, attribute: .top, multiplier: 1, constant: 0)
        let pickerBottomConstraint = NSLayoutConstraint(item: practicePicker, attribute: .bottom, relatedBy: .equal, toItem: pickerContainer, attribute: .bottom, multiplier: 1, constant: 0)
        let pickerX = NSLayoutConstraint(item: practicePicker, attribute: .centerX, relatedBy: .equal, toItem: pickerContainer, attribute: .centerX, multiplier: 1, constant: 0)
        let pickerY = NSLayoutConstraint(item: practicePicker, attribute: .centerY, relatedBy: .equal, toItem: pickerContainer, attribute: .centerY, multiplier: 1, constant: 0)
        self.pickerContainer.addConstraints([pickerLeftConstraint, pickerRightConstraint, pickerTopConstraint, pickerBottomConstraint, pickerX, pickerY])
        if practiceTypeListOpen == true {
            pickerContainer.isHidden = false
        } else {
            pickerContainer.isHidden = true
        }
    }
    
    func formatPhone() {
        guard let phone = phoneTextField.text else { return }
        guard let result = format(phoneNumber: phone) else { return }
        phoneTextField.text = result
    }
    
    // RegEx Keys
    func validatePhoneNumber(inputPhone: String) -> Bool {
        let phoneRegex = "^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: inputPhone)
        return phoneTest
    }
    
    func validateEmail(inputEmail: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: inputEmail)
        return emailTest
    }
    
    func validateZipCode(inputZip: String) -> Bool {
        let zipRegex = "^[0-9]{5}$"
        let zipTest = NSPredicate(format: "SELF MATCHES %@", zipRegex).evaluate(with: inputZip)
        return zipTest
    }
    
    func validateTextFields() -> Bool {
        guard let phone = phoneTextField.text, let email = emailTextField.text, let zip = zipCodeTextField.text else { return false }
        if validatePhoneNumber(inputPhone: phone) == true {
            print("Valid phone number")
        } else {
            print("Invalid phone number")
            createInvalidPhoneNumberAlert()
            return false
        }
        if validateEmail(inputEmail: email) == true {
            print("Valid email")
        } else {
            print("Invalid email")
            createInvalidEmailAlert()
            return false
        }
        if validateZipCode(inputZip: zip) == true {
            print("Valid zip code")
        } else {
            print("Invalid zip code")
            createInvalidZipAlert()
            return false
        }
        return true
    }
    
    // Save Client
    func save() {
        guard let firstName = self.firstNameTextField.text,
            let clientPhoto = clientPhotoButton.backgroundImage(for: .normal),
            let lastName = self.lastNameTextField.text,
            let practiceName = self.practiceNameTextField.text,
            let phone = self.phoneTextField.text,
            let email = self.emailTextField.text,
            let streetAddress = self.addressTextField.text,
            let zip = self.zipCodeTextField.text,
            let city = self.cityTextField.text,
            let state = self.stateTextField.text,
            let practiceType = practiceTypeButton.titleLabel?.text,
            let notes = self.notesTextView.text else { return }
        if firstName.isEmpty || lastName.isEmpty || practiceName.isEmpty || phone.isEmpty || email.isEmpty || streetAddress.isEmpty || streetAddress.isEmpty || zip.isEmpty || practiceTypeButton.titleLabel?.text == "Select Type..." {
            self.createEmptyTextAlert()
            return
        } else {
            if let client = client {
                guard let practiceType = Client.PracticeType(rawValue: practiceType.lowercased()) else { return }
                ClientController.shared.updateClient(client, withFirstName: firstName, lastName: lastName, practiceName: practiceName, practiceType: practiceType, phone: phone, email: email, streetAddress: streetAddress, city: city, state: state, zip: zip, notes: notes)
                ClientController.shared.updateImage(for: client, toImage: clientPhoto)
            } else {
                guard let practiceType = Client.PracticeType(rawValue: practiceType.lowercased()) else { return }
                self.client = ClientController.shared.addClient(withFirstName: firstName, lastName: lastName, practiceName: practiceName, practiceType: practiceType, phone: phone, email: email, streetAddress: streetAddress, city: city, state: state, zip: zip, initialContactDate: Date(), notes: notes)
                ClientController.shared.updateImage(for: self.client!, toImage: clientPhoto)
            }
            dismiss(animated: true, completion: {
                print("Client Created")
            })
        }
    }
    
    // Creating an alert when phone number is invalid
    func createInvalidPhoneNumberAlert() {
        let invalidPhoneNumberAlert = UIAlertController(title: "Invalid phone number", message: "Please input a 10-digit phone number.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            print("Alert Dismissed")
        })
        invalidPhoneNumberAlert.addAction(dismissAction)
        self.present(invalidPhoneNumberAlert, animated: true, completion: nil)
    }
    
    // Creating an alert when email address is invalid
    func createInvalidEmailAlert() {
        let invalidEmailAlert = UIAlertController(title: "Invalid email address", message: "Please input a valid email address.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            print("Alert Dismissed")
        })
        invalidEmailAlert.addAction(dismissAction)
        self.present(invalidEmailAlert, animated: true, completion: nil)
    }
    
    // Creating an alert when zip code is invalid
    func createInvalidZipAlert() {
        let invalidZipAlert = UIAlertController(title: "Invalid ZIP code", message: "Please input a 5-digit ZIP code.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            print("Alert Dismissed")
        })
        invalidZipAlert.addAction(dismissAction)
        self.present(invalidZipAlert, animated: true, completion: nil)
    }
    
    // Creating an alert when textfields are empty
    func createEmptyTextAlert() {
        let emptyTextAlert = UIAlertController(title: "Required field empty", message: "Please fill out all required fields.", preferredStyle: .alert)
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
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if numbersOnly.count == 10 {
            let length = numbersOnly.count
            let hasLeadingOne = numbersOnly.hasPrefix("1")
            
            // Check for supported phone number length
            guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
                return nil
            }
            
            let hasAreaCode = (length >= 10)
            var sourceIndex = 0
            
            // Leading 1
            var leadingOne = ""
            if hasLeadingOne {
                leadingOne = "1 "
                sourceIndex += 1
            }
            
            // Area code
            var areaCode = ""
            if hasAreaCode {
                let areaCodeLength = 3
                guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                    return nil
                }
                areaCode = String(format: "(%@) ", areaCodeSubstring)
                sourceIndex += areaCodeLength
            }
            
            // Prefix, 3 characters
            let prefixLength = 3
            guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
                return nil
            }
            sourceIndex += prefixLength
            
            // Suffix, 4 characters
            let suffixLength = 4
            guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
                return nil
            }
            return leadingOne + areaCode + prefix + "-" + suffix
        } else {
            return sourcePhoneNumber
        }
    }
}

extension String {
    // This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        return String(self[substringStartIndex ..< substringEndIndex])
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let allowedSymbols = CharacterSet(charactersIn: "()-")
            let allowedSymbolsAndNumbers = CharacterSet.decimalDigits.union(allowedSymbols)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedSymbolsAndNumbers.isSuperset(of: characterSet)
        } else if textField == zipCodeTextField {
            let allowedChar = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedChar.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTextField {
            formatPhone()
            guard let phoneNumber = phoneTextField.text else { return }
            if validatePhoneNumber(inputPhone: phoneNumber) == false {
                phoneTextField.backgroundColor = .opaqueRed
                phoneLabel.textColor = .red
                phoneLabel.text = "Phone Number * (10 digits)"
            } else {
                phoneTextField.backgroundColor = .textFieldGrey
                phoneLabel.textColor = .black
                phoneLabel.text = "Phone Number *"
            }
        }
        if textField == emailTextField {
            guard let email = emailTextField.text else { return }
            if validateEmail(inputEmail: email) == false {
                emailTextField.backgroundColor = .opaqueRed
                emailLabel.textColor = .red
                emailLabel.text = "Email Address *"
            } else {
                emailTextField.backgroundColor = .textFieldGrey
                emailLabel.textColor = .black
                emailLabel.text = "Email Label *"
            }
        }
        if textField == zipCodeTextField {
            guard let zip = zipCodeTextField.text else { return }
            if validateZipCode(inputZip: zip) == false {
                zipCodeTextField.backgroundColor = .opaqueRed
                zipLabel.textColor = .red
                zipLabel.text = "Zip Code * (5 digits)"
            } else {
                zipCodeTextField.backgroundColor = .textFieldGrey
                zipLabel.textColor = .black
                zipLabel.text = "Zip Code *"
            }
        }
    }
    // Dismiss keyboard when touching outside the keyboard or textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // move view based on textfield
    @objc func keyboardWillChange(notification: Notification) {
        if notification.name == Notification.Name.UIKeyboardWillChangeFrame || notification.name == Notification.Name.UIKeyboardWillShow {
            if activeTextField == addressTextField {
                view.frame.origin.y = view.frame.origin.y - 50
            } else if activeTextField == cityTextField || activeTextField == stateTextField || activeTextField == zipCodeTextField {
                view.frame.origin.y = view.frame.origin.y - 100
            }
        } else {
            view.frame.origin.y = 0
        }
    }
}

// MARK: -  Extension for Photo Picker button
extension AddClientModalViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: -  UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let clientImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        clientPhotoButton.setBackgroundImage(clientImage, for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIImagePickerController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

// MARK: -  Extension for picker view that will pop up for the practice type text field
extension AddClientModalViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerData[row])".capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedPracticeType = "\(pickerData[row])"
        practiceTypeButton.setTitle(selectedPracticeType, for: .normal)
        practiceTypeListOpen = false
        pickerContainer.isHidden = true
        print("item selected")
    }
}
