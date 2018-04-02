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
    
    // TODO: - Connect Action Button
    //    @IBAction func sendConfirmationEmail(sender: UIButton) {
    //        composeEmail()
    //    }
    
    // TODO: - Format Email Content
    func composeEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mc = MFMailComposeViewController()
            let emailSubject = "Confirmation"
            let messageBody = "Bring in info from confirmation screen"
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
