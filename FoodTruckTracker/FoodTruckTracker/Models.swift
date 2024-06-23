//
//  Backend.swift
//  FoodTruckTracker
//
//  Created by Cedric Zwahlen on 22.06.2024.
//

import Foundation
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
    
    //@Attribute(.unique)
    var name: String
    var info: String
    
    var long: Double
    var lat: Double
    
    @Relationship(deleteRule: .cascade)
    var menu: [Dish]
    @Relationship(deleteRule: .cascade)
    var event: Event
    
    init(name: String, info: String, long: Double, lat: Double, menu: [Dish], event: Event) {
        self.name = name
        self.info = info
        self.long = long
        self.lat = lat
        self.menu = menu
        self.event = event
    }
    
}

class REST {
    
    
    static func trucks() async -> [FoodTruck] {
        
        guard let loc = try? await URLSession.shared.data(from: URL(string: "http://127.0.0.1:5000/location")!).0,
              let json = try? JSONSerialization.jsonObject(with: loc, options: [.fragmentsAllowed]) else { return [] }
        
        
        if let locations = json as? [[String : Any]] {
            
            for location in locations {
                
                //print(location)
                
                if
                    let lat = location["latitude"] as? Double,
                    let lon = location["longitude"] as? Double,
                    let ft_id = location["foodtruck_id"] as? Int,
                    let ev_id = location["event_id"] as? Int
               
                {
                    
                    guard let vnt = try? await URLSession.shared.data(from: URL(string: "http://127.0.0.1:5000/event/\(ev_id)")!).0,
                        let json_ev = try? JSONSerialization.jsonObject(with: vnt, options: [.fragmentsAllowed]),
                          let ev = json_ev as? [String : Any] else { return [] }
                        
                    
                    let dt_s = ev["start_date"] as! String
                    let dt_e = ev["end_date"] as! String
                    
                    // Wed, 03 Jul 2024 00:00:00 GMT
                    
                    let d = DateFormatter()
                    d.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                    d.locale = Locale(identifier: "en_US_POSIX")
                    d.timeZone = TimeZone(abbreviation: "GMT")
                    
                    
            
                    let event = Event(name: ev["name"] as! String, start_date: Int(d.date(from: dt_s)!.timeIntervalSince1970), end_date: Int(d.date(from: dt_e)!.timeIntervalSince1970))
                    
                    guard let fdtrck = try? await URLSession.shared.data(from: URL(string: "http://127.0.0.1:5000/foodtruck/\(ft_id)")!).0,
                        let json_ft = try? JSONSerialization.jsonObject(with: fdtrck, options: [.fragmentsAllowed]),
                          let ft = json_ft as? [String : Any] else { return [] }
                    
                     
                    guard let mn = ft["menu"] as? [[String : Any]] else { return [] }
                    
                    var dishes = [Dish]()
                    
                    for m in mn {
                        
                     //   dishes.append(Dish(name: "", ingredients: <#T##[String]#>, price: <#T##Float#>))
                        
                    }
                    
                    //let foodtruck = FoodTruck(name: <#T##String#>, info: <#T##String#>, long: <#T##Double#>, lat: <#T##Double#>, menu: <#T##[Dish]#>, event: <#T##Event#>)
                    
                    
                }
                
            }
            
        }
        
        return []
    }
    
    
    
}
