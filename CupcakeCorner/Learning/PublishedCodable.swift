//
//  PublishedCodable.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 24/02/2022.
//

import SwiftUI

// A class can be made Codable with no effort on our side (other than simply declaring 'Codable' next to the type's name) if each property is Codable by design (String, Int, Double, ...)
// But @Published property wrapper is not Codable by default, we have to explicitely define what it means for @Published to be Codable

class User: ObservableObject, Codable {
    // an enum that conforms to CodingKey, a protocol for key encoding/decoding
    // not mandatory to call this enum 'CodingKeys' but this is a convention
    // every Class property requiring archiving and unarchiving (encode/decode) should be listed here:
    enum CodingKeys: CodingKey {
        case name
    }
    
    @Published var name = "Paul Hudson"
    
    // an init that describes how to initiate an instance of this Class from binary data ('decoder')
    // this is required to conform to Decodable
    // 'required' keyword means every sub-Class must override this init with custom implementation
    // alternatively mark this Class as 'final' to avoid subClassing capability (inheritance) and avoid to mark this init as 'required'
    required init(from decoder: Decoder) throws {
        // try to organize binary data as a container ordered by CodingKeys enum:
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // try to decode the container and find the String that matches the enum case '.name':
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
    }
    
    // a method that describes how to encode a Class instance to binary (JSON, XML, YAML, ...) data ('encoder')
    // this is required to conforms to Encodable
    func encode(to encoder: Encoder) throws {
        // organize the binary data as a container ordered by CodingKey enum:
        var container = encoder.container(keyedBy: CodingKeys.self)
        // try to fill the container with Class property 'name' using enum key '.name':
        try container.encode(self.name, forKey: CodingKeys.name)
    }
}

struct PublishedCodable: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PublishedCodable_Previews: PreviewProvider {
    static var previews: some View {
        PublishedCodable()
    }
}
