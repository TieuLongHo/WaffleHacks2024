//
//  ContentView.swift
//  FoodTruckTracker
//
//  Created by Cedric Zwahlen on 22.06.2024.
//

import SwiftUI
import SwiftData
import MapKit

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    
    @Query var trucks: [FoodTruck]
    
    @State var selection: FoodTruck?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Food Truck")
                .font(.title)
                .bold()
                .foregroundStyle(LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
           
            Text("Find us! What can we write here?")
                .padding(.bottom)
               
            
            Map(selection: $selection) {
                ForEach(trucks) { truck in
                     Marker(truck.name, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(floatLiteral: truck.lat), longitude: CLLocationDegrees(floatLiteral: truck.long)))
                         .tag(truck)
                         //.tint(.purple)
                 }
            }
            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .sheet(item: $selection) { truck in
                
                VStack(alignment: .leading) {
                    
                    Text(truck.name)
                        .font(.title2)
                    
                    List {
                        ForEach(truck.menu) { dish in
                            Section(header: Text("Major \(dish.name) Ocean Seas")) {
                              //  ForEach(dish.ingredients, id: \.self) { piece in
                              //      Text(piece)
                              //  }
                            }
                        }
                    }
                    
                    
                    
                }
                .padding()
                    
                
            }
            
            HStack {
                
                
                
            // add a list for the menu, maybe even prices
            /*
                List {
                    ForEach(trucks) {
                        Text($0.name)
                    }
                }
                */
                
                
                
           }
            
            
            
            
        }
        .padding()
        .onAppear() {
            
            context.autosaveEnabled = false
            
            let ft = FoodTruck(name: "Hot Rod", info: "the best one", long: 12.345, lat: 3.21)
            
            
            context.insert(ft)
        
            let d1 = Dish(truck: ft, name: "Hot Dog", price: 3.45)
            let d2 = Dish(truck: ft, name: "Fries", price: 5.31)
            
            
            context.insert(d1)
            context.insert(d2)
            
            
            
        }
    }
}

#Preview {
    ContentView()
}
