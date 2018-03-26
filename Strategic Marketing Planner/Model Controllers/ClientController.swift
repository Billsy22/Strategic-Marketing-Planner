//
//  ClientController.swift
//  Strategic Marketing Planner
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation
import CoreData

class ClientController {
    
    var clients: [Client] = []
    
    static let shared = ClientController()
    
    private let context = CoreDataStack.context
    
    init() {
        load()
        if clients.count == 0 {
            addDummyData()
        }
    }
    
    //MARK: - CREATE
    func addClient(withFirstName firstName: String, lastName: String, practiceName: String, phone: String, email: String, streetAddress: String, city: String?, state: String?, zip: String, initialContactDate: Date, notes: String?){
        let client = Client(firstName: firstName, lastName: lastName, practiceName: practiceName, phone: phone, email: email, address: streetAddress, city: city, state: state, zip: zip, initialContact: initialContactDate, notes: notes)
        clients.append(client)
        save()
    }
    
    //MARK: - UPDATE
    func setMarketingPlan(_ plan: MarketingPlan,forClient client: Client) {
        client.marketingPlan = plan
        save()
    }
    
    
    //MARK: - Delete
    func removeClient(_ client: Client) {
        guard let removedClientIndex = clients.index(of: client) else {return}
        clients.remove(at: removedClientIndex)
        context.delete(client)
        save()
    }
    
    private func addDummyData(){
        addClient(withFirstName: "test1", lastName: "testLast", practiceName: "You Know the Drill", phone: "12345678", email: "notarealemail@uncreative.com", streetAddress: "1234 WhateverPlace", city: nil, state: nil, zip: "54321", initialContactDate: Date(), notes: nil)
        addClient(withFirstName: "Jenny", lastName: "Gotchournumber", practiceName: "Wall", phone: "8675309", email: "noemail@foragoodtimecall.com", streetAddress: "4321 dummyDataIsDumb", city: nil, state: nil, zip: "12345", initialContactDate: Date(), notes: nil)
        addClient(withFirstName: "test2", lastName: "testLast", practiceName: "test office", phone: "12345678", email: "notarealemail@uncreative.com", streetAddress: "1234 WhateverPlace", city: nil, state: nil, zip: "54321", initialContactDate: Date(), notes: nil)
    }
    
    //MARK: - Persistence
    private func save(){
        try? CoreDataStack.context.save()
    }
    
    private func load(){
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            clients = try CoreDataStack.context.fetch(fetchRequest)
        } catch let error {
            NSLog("Error fetching clients from file: \(error.localizedDescription)")
        }
        
    }
}
