//
//  ClientController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import UIKit
import CoreData

protocol ClientControllerDelegate: class {
    func clientsUpdated()
}

class ClientController {
    
    var clients: [Client] {
        return load()
    }
    
    weak var delegate: ClientControllerDelegate?
    
    static let shared = ClientController()
    
    private let context = CoreDataStack.context
    
    var currentClient: Client?
    
    private init(){
        if clients.count == 0 {
            loadCloudBackup()
        }
    }
    
    //MARK: - CREATE
    @discardableResult func addClient(withFirstName firstName: String, lastName: String, practiceName: String, practiceType: Client.PracticeType, phone: String, email: String, streetAddress: String, city: String?, state: String?, zip: String, initialContactDate: Date, notes: String?) -> Client {
        let client = Client(firstName: firstName, lastName: lastName, practiceName: practiceName, phone: phone, email: email, address: streetAddress, city: city, state: state, zip: zip, initialContact: initialContactDate, notes: notes, practiceType: practiceType)
        save()
        updateClientBackup(client: client)
        return client
    }
    
    //MARK: - Read
    func getClientWithRecordName(recordName: String) -> Client? {
        return clients.first(where: {$0.recordName == recordName})
    }
    
    //MARK: - UPDATE
    func setMarketingPlan(_ plan: MarketingPlan,forClient client: Client) {
        client.marketingPlan = plan
        client.marketingPlan?.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func toggleActivationForMarketingOption(_ option: MarketingOption, forClient client: Client){
        guard let marketingPlan = client.marketingPlan, let options = marketingPlan.options else {
            NSLog("Tried to edit a marketing option without a marketing plan.")
            return
        }
        if options.contains(option){
            option.isActive = !option.isActive
            option.lastModificationTimestamp = Date().timeIntervalSince1970
            client.recordModified = true
            updateClientBackup(client: client)
            save()
        }
    }
    
    func updateExternalMarketingFocus(_ focus: MarketingPlan.ExternalMarketingFocus, forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.name = focus.rawValue
        externalMarketingOption.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateExternalMarketingBudget(_ budget: Decimal, forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.price = budget as NSDecimalNumber
        externalMarketingOption.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func activateExternalMarketing(forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.isActive = true
        externalMarketingOption.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func deactivateExternalMarketing(forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.isActive = false
        externalMarketingOption.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateStartupMarketingBudget(forClient client: Client, to price: Decimal){
        guard let startupMarketingOption = client.marketingPlan?.getOptionsForCategory(.startup).first else { return }
        startupMarketingOption.price = price as NSDecimalNumber
        startupMarketingOption.lastModificationTimestamp = Date().timeIntervalSince1970
        startupMarketingOption.isActive = price > 0
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateB2BMarketingFocus(forClient client: Client, to focus: MarketingPlan.BusinessToBusinessMarketing){
        guard let b2bMarketingOption = client.marketingPlan?.getOptionsForCategory(.businessToBusiness).first else { return }
        b2bMarketingOption.name = focus.rawValue
        b2bMarketingOption.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateB2BMarketingBudget(forClient client: Client, to price: Decimal){
        guard let b2bMarketingOption = client.marketingPlan?.getOptionsForCategory(.businessToBusiness).first else { return }
        b2bMarketingOption.price = price as NSDecimalNumber
        b2bMarketingOption.isActive = price > 0
        b2bMarketingOption.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateClient(_ client: Client, withFirstName firstName: String, lastName: String, practiceName: String, practiceType: Client.PracticeType, phone: String, email: String, streetAddress: String, city: String?, state: String?, zip: String, notes: String?){
        client.firstName = firstName
        client.lastName = lastName
        client.practiceName = practiceName
        client.phoneNumber = phone
        client.email = email
        client.streetAddress = streetAddress
        client.city = city
        client.state = state
        client.zip = zip
        client.practiceType = practiceType.rawValue
        client.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateMonthlyBudget(for client: Client, withAmount amount: Decimal) {
        client.monthlyBudget = amount as NSDecimalNumber
        client.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateCurrentProduction(for client: Client, withAmount amount: Decimal) {
        client.currentProduction = amount as NSDecimalNumber
        client.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateProductionGoal(for client: Client, withAmount amount: Decimal) {
        client.productionGoal = amount as NSDecimalNumber
        client.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    func updateImage(for client: Client, toImage image: UIImage){
        client.imageData = UIImageJPEGRepresentation(image, 1)
        client.lastModificationTimestamp = Date().timeIntervalSince1970
        client.recordModified = true
        updateClientBackup(client: client)
        save()
    }
    
    //MARK: - Delete
    func removeClient(_ client: Client) {
        context.delete(client)
        CloudKitManager.delete(entity: client) { (success) in
            if !success {
                NSLog("Warning: Failed to delete client")
            }
        }
        save()
    }
    
    
    //MARK: - Persistence
    private func save(){
        try? CoreDataStack.context.save()
        DispatchQueue.main.async {[weak self] in
            self?.delegate?.clientsUpdated()
        }
    }
    
    private func updateClientBackup(client: Client){
        var clientSaved = true
        var planSaved = true
        var allOptionsSaved = true
        guard client.recordModified else { return }
        CloudKitManager.updateEntity(entity: client) { (success) in
            if !success {
                NSLog("Failed to save client.")
                clientSaved = false
            }
            guard let marketingPlan = client.marketingPlan else { return }
            CloudKitManager.updateEntity(entity: marketingPlan, completion: { (success) in
                if !success {
                    NSLog("Failed to save marketing plan.")
                    planSaved = false
                }
                guard let options = marketingPlan.options else { return }
                for option in options.compactMap({$0 as? MarketingOption}){
                    CloudKitManager.updateEntity(entity: option, completion: { (success) in
                        if !success {
                            NSLog("Failed to save marketing option")
                            allOptionsSaved = false
                        }
                        client.recordModified = !(clientSaved && planSaved && allOptionsSaved)
                    })
                }
            })
        }
    }
    
    private func load() -> [Client]{
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let results = try CoreDataStack.context.fetch(fetchRequest)
            return results
        } catch let error {
            NSLog("Error fetching clients from file: \(error.localizedDescription)")
            return []
        }
    }
    
    func loadCloudBackup() {
        CloudKitManager.loadEntities(ofType: Client.self, exclude: []) {[weak self] (retrievedObjects, error) in
            if let error = error {
                NSLog("Error fetching clients from backup: \(error.localizedDescription)")
            }
            CloudKitManager.loadEntities(ofType: MarketingPlan.self, exclude: [], completion: { (retrievedPlans, error) in
                if let error = error {
                    NSLog("Error fetching marketing plans from backup: \(error.localizedDescription)")
                }
                CloudKitManager.loadEntities(ofType: MarketingOption.self, exclude: [], completion: { (retrievedOptions, error) in
                    if let error = error {
                        NSLog("Error fetching marketing options from backup: \(error.localizedDescription)")
                    }
                })
            })
            DispatchQueue.main.async {
                self?.delegate?.clientsUpdated()
            }
        }
    }
}
