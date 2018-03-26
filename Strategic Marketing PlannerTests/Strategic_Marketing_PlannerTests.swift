//
//  Strategic_Marketing_PlannerTests.swift
//  Strategic Marketing PlannerTests
//
//  Created by Christopher Thiebaut on 3/26/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import XCTest
@testable import Strategic_Marketing_Planner

class Strategic_Marketing_PlannerTests: XCTestCase {
    
    var clientCount = 0
    var testClient: Client?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clientCount = ClientController.shared.clients.count
    }
    
    override func tearDown() {
        clientCount = 0
        super.tearDown()
    }
    
    func testClientAddDelete(){
        ClientController.shared.addClient(withFirstName: "unitTest", lastName: "unitTest", practiceName: "unitTest", phone: "unitTest", email: "unitTest", streetAddress: "unitTest", city: nil, state: nil, zip: "unitTest", initialContactDate: Date(), notes: nil)
        testClient = ClientController.shared.clients.last
        XCTAssert(ClientController.shared.clients.last != nil)
        XCTAssert(ClientController.shared.clients.count == clientCount + 1)
        ClientController.shared.removeClient(testClient!)
        XCTAssert(ClientController.shared.clients.count == clientCount)
    }
    
}
