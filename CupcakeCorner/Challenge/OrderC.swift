//
//  OrderC.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 28/02/2022.
//

import Foundation

// simple struct for data, with automatic Codable conformance:
struct OrderData: Codable {
    
    // order details:
    var type = 0
    var quantity = 3
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    // delivery details:
    var name = ""
    var street = ""
    var city = ""
    var zip = ""
    
    // checkout details:
    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2
        
        // complicated cakes cost more
        cost += (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    
}

// Class wrapper (around OrderData Struct) for ObservableObject conformance and ease of exchange between Views:
class OrderC: ObservableObject {
    @Published var data = OrderData()
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var deliveryIssue: String {
        
        if isInvalidWord(self.data.name){
            return "Please enter a valid name"
            
        } else if isInvalidWord(self.data.street) {
            return "Please enter a valid street"
            
        } else if isInvalidWord(self.data.city) {
            return "Please enter a valid city"
            
        } else if isInvalidZip(self.data.zip) {
            return "Please enter a valid Zip code"
        }
        
        return ""
    }
    
    func disableCheckout() -> Bool {
        isInvalidWord(self.data.name) || isInvalidWord(self.data.street) || isInvalidWord(self.data.city) || isInvalidZip(self.data.zip)
    }
    
    func isInvalidWord(_ word: String) -> Bool {
        word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isInvalidZip(_ zip: String) -> Bool {
        guard let zipcode = Int(zip) else { return true }
        
        return !( zipcode > 0 && zipcode < 99999 && zip.count == 5 )
    }
}
