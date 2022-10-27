//
//  DisablingForm.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 24/02/2022.
//

import SwiftUI

struct DisablingForm: View {
    
    @State private var username = ""
    @State private var email = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username, prompt: Text("Type in your username"))
                TextField("Email", text: $email, prompt: Text("Type in your e-mail address"))
            }
            
            Section {
                Button("Create account") {
                    print("creating account...")
                }
//                .disabled( username.isEmpty || email.isEmpty ) // using a direct predicate
//                .disabled(disabledForm) // using a computed property
                .disabled(disableForm()) // using a method

            }
        }
    }
    
    var disabledForm: Bool {
         username.count < 5 || email.contains("@")
    }
    
    func disableForm() -> Bool {
        username.count > 20 || !email.contains("@")
    }
}

struct DisablingForm_Previews: PreviewProvider {
    static var previews: some View {
        DisablingForm()
    }
}
