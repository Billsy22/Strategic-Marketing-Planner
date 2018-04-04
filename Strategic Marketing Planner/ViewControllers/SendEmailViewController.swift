//
//  SendEmailViewController.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 4/2/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import MessageUI

class SendEmailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var client: Client?
    
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var sendConfirmationEmailButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBAction func sendConfirmationEmail(sender: UIButton) {
            composeEmail()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTextView()
    }
    
    func populateTextView() {
        summaryTextView.text = "Thank you for starting a partnership with Dental Branding. We are thrilled to be working with you. Based on our information, you recently talked with ***SALESMAN*** about your marketing plan. This is the information we have based on your conversation.\n\nBudget: ***BUDGET*** per month\n\(String(describing: client?.marketingPlan))\n\nTotal cost: ***TOTAL COST*** per month"
        formatTextView()
        formatConfirmationButton()
        formatHeaderLabel()
        formatTotalPriceLabel()
    }
    
    func formatTextView() {
        summaryTextView.layer.borderColor = UIColor.gray.cgColor
        summaryTextView.layer.borderWidth = 0.5
        summaryTextView.layer.cornerRadius = 5
        summaryTextView.contentInset.left = 15
        summaryTextView.contentInset.right = 15
        summaryTextView.contentInset.top = 10
        summaryTextView.contentInset.bottom = 10
        summaryTextView.text = "Thank you for starting a partnership with Dental Branding. We are thrilled to be working with you. Based on our information, you recently talked with us about your marketing plan. This is the information we have based on our conversation.\n\nBudget: ***BUDGET*** per month\n***MARKETINGPLAN***\n\nTotal cost: ***TOTAL COST*** per month"
    }
    
    func formatConfirmationButton() {
        sendConfirmationEmailButton.layer.cornerRadius = 5
        sendConfirmationEmailButton.backgroundColor = .brandOrange
    }
    
    func formatHeaderLabel() {
        headerLabel.textColor = .brandOrange
    }
    
    func formatTotalPriceLabel() {
    }
    
    // TODO: - Format Email Content
    func composeEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mc = MFMailComposeViewController()
            let emailSubject = "Confirmation"
            guard let messageBody = summaryTextView.text else { return }
            let toRecipients = ["\(client?.email ?? "")", "salesman@db.com", "corporate@db.com"]
            mc.mailComposeDelegate = self
            mc.setSubject(emailSubject)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipients)
            self.present(mc, animated: true, completion: nil)
        } else {
            print("Cannot send email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Email cancelled")
        case MFMailComposeResult.saved:
            print("Email saved")
        case MFMailComposeResult.sent:
            print("Email sent")
        case MFMailComposeResult.failed:
            print("Email sent failure: \(String(describing: error?.localizedDescription))")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
