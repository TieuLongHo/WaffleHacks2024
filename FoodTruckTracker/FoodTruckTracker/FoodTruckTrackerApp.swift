//
//  FoodTruckTrackerApp.swift
//  FoodTruckTracker
//
//  Created by Cedric Zwahlen on 22.06.2024.
//

import SwiftUI

@main
struct FoodTruckTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FoodTruck.self)
    }
}
