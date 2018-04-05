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
    
    var client : Client? {
        return ClientController.shared.currentClient
    }
    
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var sendConfirmationEmailButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBAction func sendConfirmationEmail(sender: UIButton) {
            composeEmail()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatTextView()
        formatConfirmationButton()
        formatHeaderLabel()
        formatTotalPriceLabel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatTextView()
        formatTotalPriceLabel()
    }
    
    func formatTextView() {
        guard let client = client else { print("No client passed to email view"); return }
        guard let marketingPlan = client.marketingPlan else { return }
        guard let monthlyBudget = client.monthlyBudget else { return }
        summaryTextView.layer.borderColor = UIColor.gray.cgColor
        summaryTextView.layer.borderWidth = 0.5
        summaryTextView.layer.cornerRadius = 5
        summaryTextView.contentInset.left = 15
        summaryTextView.contentInset.right = 15
        summaryTextView.contentInset.top = 10
        summaryTextView.contentInset.bottom = 10
        let firstSection = "Thank you for starting a partnership with Dental Branding. We are thrilled to be working with you. Based on our information, you recently talked with us about your marketing plan. This is the information we have based on our conversation.\n\nBudget: $\(monthlyBudget) per month\n"
        let lastSection = "\nTotal cost: $\(marketingPlan.cost) per month"
        summaryTextView.text = firstSection + printFoundationOptions() + printInternalOptions() + printExternalOptions() + lastSection
    }
    
    func printExternalOptions() -> String {
        guard let client = client, let marketingPlan = client.marketingPlan else { return "" }
        var optionsList = ""
        let options = marketingPlan.getOptionsForCategory(.external, includeOnlyActive: true)
        guard let name = options.first?.name, let price = options.first?.price else { return "" }
        let priceKey = Int(truncating: price)
        guard let packageItems = ProductsInfo.externalMarketingDictionary[name]?[priceKey] else { return "" }
        if packageItems.count != 0 {
            for item in packageItems {
                optionsList.append(item)
                optionsList.append("\n")
            }
        }
        return optionsList
    }
    
    func printInternalOptions() -> String {
        guard let client = client, let marketingPlan = client.marketingPlan else { return "" }
        var optionsList = ""
        let options = marketingPlan.getOptionsForCategory(.internal, includeOnlyActive: true)
        if options.count != 0 {
            for option in options {
                guard let name = option.name else { return "" }
                optionsList.append(name)
                optionsList.append("\n")
            }
        }
        return optionsList
    }
    
    func printFoundationOptions() -> String {
        guard let client = client, let marketingPlan = client.marketingPlan else { return "" }
        var optionsList = ""
        let options = marketingPlan.getOptionsForCategory(.foundation, includeOnlyActive: true)
        if options.count != 0 {
            for option in options {
                guard let name = option.name else { return "" }
                optionsList.append(name)
                optionsList.append("\n")
            }
        }
        return optionsList
    }
    
    func formatConfirmationButton() {
        sendConfirmationEmailButton.layer.cornerRadius = 5
        sendConfirmationEmailButton.backgroundColor = .brandOrange
    }
    
    func formatHeaderLabel() {
        headerLabel.textColor = .brandOrange
    }
    
    func formatTotalPriceLabel() {
        guard let client = client, let marketingPlan = client.marketingPlan, let monthlyBudget = client.monthlyBudget else { return }
        totalPriceLabel.text = "$\(marketingPlan.cost)/$\(monthlyBudget)"
    }
    
    func composeEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mc = MFMailComposeViewController()
            let emailSubject = "Summary & Confirmation"
            guard let messageBody = summaryTextView.text else { return }
            let toRecipients = ["\(client?.email ?? "")", "sheryl.dayler@henryschein.com", "bruce@dentalbranding.com"]
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
