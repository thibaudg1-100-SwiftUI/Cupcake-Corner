//
//  CodableURLSession.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 24/02/2022.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct CodableURLSession: View {
    @State private var results = [Result]()
    
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task { // this modifier is like onAppear with added ability to handle async tasks
            await loadData() // 'await' keyword acknowledges that a sleep might happen
        }
    }
    
    // 'async' keyword means asynchronous function, might go to sleep while waiting for some work to complete
    func loadData() async {
        
        // URL(from: String) might return nil if the string is empty or contains illegal URL characters
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        // data(from: URL) might throw errors if user is not connected to the network for example
        // returns a tuple with data found at this URL and metadata about how the URLSession (request) went
        // since we don't use this metadata, we toss it away with '_' keyword
        // here is the await declaration that acknowledges data(from: URL) is an async method and justifies we put 'async' keyword in front of our method 'loadData()'
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                self.results = decodedResponse.results
            }
            
        } catch {
            print("Invalid data")
        }
    }
}

struct CodableURLSession_Previews: PreviewProvider {
    static var previews: some View {
        CodableURLSession()
    }
}
