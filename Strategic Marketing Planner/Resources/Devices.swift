//
//  Devices.swift
//  Strategic Marketing Planner
//
//  Created by Steven Brown on 3/30/18.
//  Copyright © 2018 Christopher Thiebaut. All rights reserved.
//

import Foundation

enum Devices: String {
    
    case iPadPro12Inch
    case iPadPro10Inch
    case iPadPro9Inch
    case handheld
    case otheriPad
    
    static var currentDevice: Devices {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let idString = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
        switch idString {
        case "iPad6,3", "iPad6,4", "iPad6,11", "iPad6,12":
            return .iPadPro9Inch
        case "iPad7,3", "iPad7,4":
            return .iPadPro10Inch
        case "iPad6,7", "iPad6,8", "iPad7,1", "iPad7,2":
            return .iPadPro12Inch
        // Simulator
        case "x86_64":
            return .iPadPro9Inch
        default:
            guard idString.contains("iPhone") || idString.contains("iPod") else { return .otheriPad }
            return .handheld
        }
    }
}
