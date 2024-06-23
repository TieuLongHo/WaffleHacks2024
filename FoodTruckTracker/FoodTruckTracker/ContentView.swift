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
           
            Text("Come visit us! The map below shows our currently scheduled events. We are open from 11:00 AM to 7:00 PM every day of the event.")
                .padding(.bottom)
            
           
            
            
               
            
            Map(selection: $selection) {
                ForEach(trucks) { truck in
                     Marker(truck.name, coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(floatLiteral: truck.lat), longitude: CLLocationDegrees(floatLiteral: truck.long)))
                         .tag(truck)
                         //.tint(.purple)
                 }
            }
            
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            //.padding(25)
            .sheet(item: $selection) { truck in
                
                VStack(alignment: .leading) {
                    
                    Text(truck.name)
                        .font(.title2)
                        .bold()
                        
                    Text(truck.info)
                        .font(.callout)
                        
                    
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
                    .layoutPriority(-3)
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
                                    Text(piece.capitalized)
                                }
                            }
                        }
                    }
                    .layoutPriority(3)
                    
                    
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
            
            try! ModelContainer(for: FoodTruck.self).deleteAllData()
            
            context.autosaveEnabled = false
            
            df.dateFormat = "cccc, dd.MM"
            df.locale = Locale.current
            
            
            
            
            try? context.transaction {
                
                
                Task {
                    
                    
                    for truck in await REST.trucks() {
                        
                        context.insert(truck)
                        
                    }
                    
                    
                }
                
            }
            
            
        }
        
    }
}

#Preview {
    ContentView()
}
