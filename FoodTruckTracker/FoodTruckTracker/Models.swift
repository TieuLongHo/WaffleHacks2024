//
//  Backend.swift
//  FoodTruckTracker
//
//  Created by Cedric Zwahlen on 22.06.2024.
//

//import Foundation
import SwiftData

@Model
class Event {
    
    var truck: FoodTruck?
    
    var name: String
    var start_date: Int
    var end_date: Int
    
    init(name: String, start_date: Int, end_date: Int) {
        self.name = name
        self.start_date = start_date
        self.end_date = end_date
    }
    
}

@Model
class Dish {
    
    var truck: FoodTruck?
    
    var name: String
    
    var ingredients: [String]
    var price: Float
    
    init(name: String, ingredients: [String], price: Float) {
        self.name = name
        self.ingredients = ingredients
        self.price = price
    }
    
}

@Model
class FoodTruck {
    
    @Attribute(.unique)
    var name: String
    var info: String
    
    var long: Double
    var lat: Double
    
    @Relationship(deleteRule: .cascade)
    var menu: [Dish]
    @Relationship(deleteRule: .cascade)
    var events: [Event]
    
    init(name: String, info: String, long: Double, lat: Double, menu: [Dish], events: [Event]) {
        self.name = name
        self.info = info
        self.long = long
        self.lat = lat
        self.menu = menu
        self.events = events
    }
    
}
