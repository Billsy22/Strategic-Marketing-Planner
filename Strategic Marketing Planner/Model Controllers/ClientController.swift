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
    
    //MARK: - CREATE
    @discardableResult func addClient(withFirstName firstName: String, lastName: String, practiceName: String, phone: String, email: String, streetAddress: String, city: String?, state: String?, zip: String, initialContactDate: Date, notes: String?) -> Client {
        let client = Client(firstName: firstName, lastName: lastName, practiceName: practiceName, phone: phone, email: email, address: streetAddress, city: city, state: state, zip: zip, initialContact: initialContactDate, notes: notes)
        save()
        return client
    }
    
    //MARK: - UPDATE
    func setMarketingPlan(_ plan: MarketingPlan,forClient client: Client) {
        client.marketingPlan = plan
        save()
    }
    
    func toggleActivationForMarketingOption(_ option: MarketingOption, forClient client: Client){
        guard let marketingPlan = client.marketingPlan, let options = marketingPlan.options else {
            NSLog("Tried to edit a marketing option without a marketing plan.")
            return
        }
        if options.contains(option){
            option.isActive = !option.isActive
            save()
        }
    }
    
    func updateExternalMarketingFocus(_ focus: MarketingPlan.ExternalMarketingFocus, forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.name = focus.rawValue
        save()
    }
    
    func updateExternalMarketingBudget(_ budget: Decimal, forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.price = budget as NSDecimalNumber
        save()
    }
    
    func activateExternalMarketing(forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.isActive = true
        save()
    }
    
    func deactivateExternalMarketing(forClient client: Client){
        guard let externalMarketingOption = client.marketingPlan?.getOptionsForCategory(.external).first else { return }
        externalMarketingOption.isActive = false
        save()
    }
    
    func updateClient(_ client: Client, withFirstName firstName: String, lastName: String, practiceName: String, phone: String, email: String, streetAddress: String, city: String?, state: String?, zip: String, notes: String?){
        client.firstName = firstName
        client.lastName = lastName
        client.practiceName = practiceName
        client.phoneNumber = phone
        client.email = email
        client.streetAddress = streetAddress
        client.city = city
        client.state = state
        client.zip = zip
        save()
    }
    
    func updateMonthlyBudget(for client: Client, withAmount amount: Decimal) {
        client.monthlyBudget = amount as NSDecimalNumber
        save()
    }
    
    func updateCurrentProduction(for client: Client, withAmount amount: Decimal) {
        client.currentProduction = amount as NSDecimalNumber
        save()
    }
    
    func updateProductionGoal(for client: Client, withAmount amount: Decimal) {
        client.productionGoal = amount as NSDecimalNumber
        save()
    }
    
    func updateImage(for client: Client, toImage image: UIImage){
        client.imageData = UIImageJPEGRepresentation(image, 1)
        save()
    }
    
    //MARK: - Delete
    func removeClient(_ client: Client) {
        context.delete(client)
        save()
    }
    
    
    //MARK: - Persistence
    private func save(){
        try? CoreDataStack.context.save()
        delegate?.clientsUpdated()
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
}
