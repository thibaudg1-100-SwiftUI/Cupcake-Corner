//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 25/02/2022.
//

import SwiftUI

struct AddressView: View {
    
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                    .disableAutocorrection(true)
                
                TextField("Street", text: $order.street)
                
                TextField("City", text: $order.city)
                
                TextField("Zip code", text: $order.zip)
                    .keyboardType(.numberPad)
            } footer: {
                Text(order.deliveryIssue)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: self.order)
                } label: {
                    Text("Check Out...")
                }

            }
            .disabled( order.disableCheckout() )
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView(order: Order())
        }
    }
}
