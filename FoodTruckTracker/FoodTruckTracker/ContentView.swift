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
                            Section(header:
                                HStack {
                                    
                                    Text("\(dish.name)")
                                    Spacer()
                                    Text("\(dish.price)")
                                    
                                }
                            
                            ) {
                                ForEach(dish.ingredients, id: \.self) { piece in
                                    Text(piece)
                                }
                            }
                        }
                    }
                    
                    
                    
                }
                #if os(macOS)
                .frame(minWidth: 300, minHeight: 300)
                #endif
                .onAppear() {
                    
                    print(truck.menu)
                    
                }
                .padding()
                    
                
            }
            
            
            
            
        }
        .padding()
        .onAppear() {
            
            context.autosaveEnabled = false
       
            
            let ft = FoodTruck(name: "Hot Rod", info: "the best one", long: 12.345, lat: 3.21, menu: [
            
                Dish(name: "Hot Dog", ingredients: ["bun", "hot"], price: 3.45),
                Dish(name: "Fries", ingredients: ["french", "fries"], price: 5.31)
                
            ])
            
          
            
            
            context.insert(ft)
            
        }
        
    }
}

#Preview {
    ContentView()
}
