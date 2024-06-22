//
//  Backend.swift
//  FoodTruckTracker
//
//  Created by Cedric Zwahlen on 22.06.2024.
//

//import Foundation
import SwiftData

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
    
    var menu: [Dish]
    
    init(name: String, info: String, long: Double, lat: Double, menu: [Dish]) {
        self.name = name
        self.info = info
        self.long = long
        self.lat = lat
        self.menu = menu
    }
    
}
