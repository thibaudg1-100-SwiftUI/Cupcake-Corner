//
//  Order.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 25/02/2022.
//

import Foundation

class Order: ObservableObject, Codable {
    
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    
    // must be a let constant
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    
    // order details:
    @Published var type = 0 // only use subscript index as selected type when the Collection (array 'types') is a declared constant, otherwise if the array is edited and the type (un)changed, you get undefined results...
    @Published var quantity = 3
    
    @Published var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false
    
    
    // delivery details:
    @Published var name = ""
    @Published var street = ""
    @Published var city = ""
    @Published var zip = ""

    
    var deliveryIssue: String {
        
        if isInvalidWord(self.name){
            return "Please enter a valid name"
            
        } else if isInvalidWord(self.street) {
            return "Please enter a valid street"
            
        } else if isInvalidWord(self.city) {
            return "Please enter a valid city"
            
        } else if isInvalidZip(self.zip) {
            return "Please enter a valid Zip code"
        }
        
        return ""
    }
    
    
    // make sure that the delivery details are good enough before moving to checkout:
    var hasValidAddress: Bool {
        !( name.isEmpty || street.isEmpty || city.isEmpty || zip.isEmpty ) // first implementation
    }
    
    func isInvalidWord(_ word: String) -> Bool {
        word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isInvalidZip(_ zip: String) -> Bool {
        guard let zipcode = Int(zip) else { return true }
        
        return !( zipcode > 0 && zipcode < 99999 && zip.count == 5 )
    }
    
    func disableCheckout() -> Bool {
        isInvalidWord(self.name) || isInvalidWord(self.street) || isInvalidWord(self.city) || isInvalidZip(self.zip)
    }
    
    
    // arbitrary price model:
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
    
    // the following initializer is necessary to create "empty" instances of Class 'Order', otherwise the only other declared init 'required init(from: decoder)' would have to be used anywhere a new Order instance is created, forcing us to create this new instance from binary data (JSON, XML, YAML, ...)
    init() {
        // no need to assign values to stored properties as they are already implemented in the Class with default values
    }
    // there can be many different initializers within the same Class
    
    // required 'encode' method for Encodable protocol compliance:
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(street, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
    
    // required 'required init' for Decodable protocol compliance:
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        street = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
}
