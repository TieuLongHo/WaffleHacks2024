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
    
    private var df = DateFormatter()
    
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
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .sheet(item: $selection) { truck in
                
                VStack(alignment: .leading) {
                    
                    Text(truck.name)
                        .font(.title2)
                        .bold()
                        
                    ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                        
                        RoundedRectangle(cornerRadius: 12.5)
                            .foregroundStyle(.white)
                            .shadow(radius: 5)
                        
                        VStack(alignment: .leading) {
                            
                            Text("\(truck.event.name.capitalized)")
                                .font(.title2)
                                .padding(.bottom, 10)
                                
                            
                            HStack {
                                
                                Text("\( df.string(from: Date(timeIntervalSince1970: TimeInterval(truck.event.start_date))) )")
                                Text(" – ")
                                Text("\( df.string(from: Date(timeIntervalSince1970: TimeInterval(truck.event.end_date))) )")
                                
                            }
                            
                        }
                        .padding()
                        
                        
                    }
                    .padding()
                    
                    List {
                        ForEach(truck.menu) { dish in
                            Section(header:
                                HStack {
                                    
                                    Text("\(dish.name)")
                                    Spacer()
                                Text("\(String(format: "%.2f",dish.price)) Fr.")
                                    
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
                    
                    //print(truck.events)
                    
                   
                    
                }
                .padding()
                    
                
            }
            
            
            
            
        }
        .padding()
        .onAppear() {
            
            context.autosaveEnabled = false
            
            
            Task {
                
                let t = await REST.trucks()
                
            }
            
       
            df.dateFormat = "cccc, dd.MM"
            df.locale = Locale.current
            
            let ft = FoodTruck(name: "Hot Rod", info: "the best one", long: 12.345, lat: 3.21, menu: [
            
                Dish(name: "Hot Dog", ingredients: ["bun", "hot"], price: 3.45),
                Dish(name: "Fries", ingredients: ["french", "fries"], price: 5.31)
                
            ], event:
                Event(name: "Summer Solstice", start_date: Int(Date.now.timeIntervalSince1970), end_date: Int(Date.now.timeIntervalSince1970 + 1000))
            )
            
          
            
            
            context.insert(ft)
            
        }
        
    }
}

#Preview {
    ContentView()
}
