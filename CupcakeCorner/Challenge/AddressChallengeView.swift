//
//  AddressChallengeView.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 28/02/2022.
//

import SwiftUI

struct AddressChallengeView: View {
    @ObservedObject var order: OrderC
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.data.name)
                    .disableAutocorrection(true)
                
                TextField("Street", text: $order.data.street)
                
                TextField("City", text: $order.data.city)
                
                TextField("Zip code", text: $order.data.zip)
                    .keyboardType(.numberPad)
            } footer: {
                Text(order.deliveryIssue)
            }
            
            Section {
                NavigationLink {
                    CheckoutChallengeView(order: self.order)
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

struct AddressChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        AddressChallengeView(order: OrderC())
    }
}
