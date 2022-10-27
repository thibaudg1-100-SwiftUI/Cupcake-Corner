//
//  ContentChallengeView.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 28/02/2022.
//

import SwiftUI

struct ContentChallengeView: View {
    
    @StateObject var order = OrderC()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Choose your type", selection: $order.data.type) {
                        ForEach(0..<OrderC.types.count) { indice in
                            Text(OrderC.types[indice])
                        }
                    }
                    
                    Stepper("\(order.data.quantity) cakes", value: $order.data.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests", isOn: $order.data.specialRequestEnabled.animation())
                    
                    if order.data.specialRequestEnabled {
                        Toggle("Extra frosting", isOn: $order.data.extraFrosting)
                        
                        Toggle("Extra sprinkles", isOn: $order.data.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressChallengeView(order: self.order)
                    } label: {
                        Text("Delivery address")
                    }

                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentChallengeView()
            .previewDevice("iPhone 13")
    }
}
