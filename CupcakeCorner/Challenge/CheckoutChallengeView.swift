//
//  CheckoutChallengeView.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 28/02/2022.
//

import SwiftUI

struct CheckoutChallengeView: View {
    
    @ObservedObject var order: OrderC
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 233) // to reserve the necessary space for the fetched image so that the UI doesn't make the cost text jump down the screen after network request has completed
            
            Text("Your total is: \(order.data.cost, format: .currency(code: "USD"))")
                .font(.title)
            
            Button {
                // the 'action' closure that Button expects doen't allow for async functions
                // it must be inserted inside a Task:
                Task {
                    await placeOrder()
                }
            } label: {
                Text("Place Order")
            }
            .padding()
            
            Spacer()
            
        }
        .alert("Thank you!", isPresented: $showingConfirmation) {
//            Button("OK") { } // not needed: automatically added by SwiftUI if no Button at all is added to the actions closure
        } message: {
            Text(confirmationMessage)
        }
        .alert("Checkout failed :(", isPresented: $showingError) {
            Button("Try again") {
                Task {
                    await placeOrder()
                }
            }
            
            Button("Cancel", role: .cancel) { }
            
        } message: {
            Text(errorMessage)
        }
        
    }
    
    
    func placeOrder() async {
        // encode our Swift data (Order) to JSON data:
        guard let encoded = try? JSONEncoder().encode(order.data) else {
            print("Failed to encode order")
            return
        }
        
        // define the URL from a typical String:
        // force unwrap is safe here since we hand typed the address with no string interpolation
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        // create a URL Request from our URL and configure a few parameters:
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(OrderData.self, from: data)
            
            print("Checkout came back from ReqRes API ✅")
            
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(OrderC.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true

        } catch {
            print("Checkout failed.")
            errorMessage = "Please check your network connection and try again 💪"
            showingError = true
        }
    }
}

struct CheckoutChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutChallengeView(order: OrderC())
    }
}
