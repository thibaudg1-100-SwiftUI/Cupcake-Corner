//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 24/02/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Choose your type", selection: $order.type) {
                        ForEach(Order.types.indices) { indice in
                            Text(Order.types[indice])
                        }
                    }
                    
                    Stepper("\(order.quantity) cakes", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests", isOn: $order.specialRequestEnabled.animation())
                    
                    if order.specialRequestEnabled {
                        Toggle("Extra frosting", isOn: $order.extraFrosting)
                        
                        Toggle("Extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: self.order)
                    } label: {
                        Text("Delivery address")
                    }

                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
