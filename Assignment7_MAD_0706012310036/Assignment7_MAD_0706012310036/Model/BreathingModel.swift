//
//  BreathingModel.swift
//  Assignment7_MAD_0706012310036
//
//  Created by student on 10/04/25.
//

import Foundation



struct BreathingSession: Identifiable, Codable {
    let id = UUID()
    let start: Date
    let end: Date
    var duration: TimeInterval {
        end.timeIntervalSince(start)
    }
}
