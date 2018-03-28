//
//  ClientController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
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
    
    //MARK: - CREATE
    func addClient(withFirstName firstName: String, lastName: String, practiceName: String, phone: String, email: String, streetAddress: String, city: String?, state: String?, zip: String, initialContactDate: Date, notes: String?){
        let _ = Client(firstName: firstName, lastName: lastName, practiceName: practiceName, phone: phone, email: email, address: streetAddress, city: city, state: state, zip: zip, initialContact: initialContactDate, notes: notes)
        save()
    }
    
    //MARK: - UPDATE
    func setMarketingPlan(_ plan: MarketingPlan,forClient client: Client) {
        client.marketingPlan = plan
        save()
    }
    
    
    //MARK: - Delete
    func removeClient(_ client: Client) {
        context.delete(client)
        save()
    }
    
    private func addDummyData(){
        addClient(withFirstName: "Mike", lastName: "Jones", practiceName: "You Know the Drill", phone: "801-691-9273", email: "notarealemail@uncreative.com", streetAddress: "1234 WhateverPlace", city: nil, state: nil, zip: "54321", initialContactDate: Date(), notes: nil)
        addClient(withFirstName: "Taylor", lastName: "Bills", practiceName: "Wall", phone: "801-485-3948", email: "noemail@foragoodtimecall.com", streetAddress: "4321 dummyDataIsDumb", city: nil, state: nil, zip: "12345", initialContactDate: Date(), notes: nil)
        addClient(withFirstName: "Steven", lastName: "Brown", practiceName: "test office", phone: "801-358-4071", email: "notarealemail@uncreative.com", streetAddress: "1234 WhateverPlace", city: nil, state: nil, zip: "54321", initialContactDate: Date(), notes: nil)
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
