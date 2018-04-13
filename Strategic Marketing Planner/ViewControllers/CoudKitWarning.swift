//
//  CoudKitWarning.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 4/12/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import CloudKit

extension UIViewController {
    func registerForCKManagerNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(noAccount), name: CloudKitManager.Notifications.NoAccountNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(accountRestricted), name: CloudKitManager.Notifications.AccountRestricted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(infoUnavailable), name: CloudKitManager.Notifications.AccountInfoUnavailable, object: nil)
    }
    
    @objc func noAccount(){
        showAlertController(title: "No Account Signed into iCloud", message: "Cloud backup and restore will not be available until you sign into iCloud.")
    }
    
    @objc func accountRestricted(){
        showAlertController(title: "Cannot access iCloud due to device restrictions", message: "Cannot access iCloud due to device restrictions. This will prevent backup and restore from your cloud database. Please review your settings to find out what is preventing iCloud access.")
    }
    
    @objc func infoUnavailable(){
        showAlertController(title: "Could not access iCloud account", message: "This could be due to network issues, please try again later. Changes will still be saved locally.")
    }
    
    func showAlertController(title: String, message: String?, style: UIAlertControllerStyle = UIAlertControllerStyle.alert){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

