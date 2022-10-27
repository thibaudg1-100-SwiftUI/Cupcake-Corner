//
//  RemoteImage.swift
//  CupcakeCorner
//
//  Created by RqwerKnot on 24/02/2022.
//

import SwiftUI

struct RemoteImage: View {
    var body: some View {
        // will load asynchronously a remote Image from an URL
        // at compile time Swift doesn't know anything about the Image, so it's loaded at scale 1: 1px = 1 pt
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
    }
}

struct RemoteImage01: View {
    var body: some View {
        // to change to @3x scale:
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3)
    }
}

struct RemoteImage02: View {
    var body: some View {
        // you might want to define a frame to get a precise size:
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
            .frame(width: 200, height: 200)
        // but the frame actually applies to the AsyncImage View wrapper rather than the final Image to display, so it doesn't fulfill our initial goal
        // actually it will apply to the placeholder only
    }
}

struct RemoteImage03: View {
    var body: some View {
        // trying to add .resizable won't work any more, because AsyncImage can't use .resizable modifier. Any Image modifier can't apply here because the data for the final Image has not been fetched yet
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
//            .resizable()
            .frame(width: 200, height: 200)
    }
}

struct RemoteImage2: View {
    var body: some View {
        
        // We need to use a more advanced version of AsyncImage:
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
            // image is the closure parameter that represent the final Image once fetched remotely
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
//            Color.red // will display a red surface instead until final Image is ready and displayed
            ProgressView() // just shows a spinner until final Image is displayed
        }
        .frame(width: 200, height: 200)
    }
}

struct RemoteImage3: View {
    var body: some View {
        
        // a third way to use AsyncImage:
        // phase allows you to handle an error View when the content can't be fectched for some reason
        // we use a bad URL on purpose to showw off the error View
        AsyncImage(url: URL(string: "https://hws.dev/img/bad.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
//        RemoteImage()
//        RemoteImage01()
//        RemoteImage02()
//        RemoteImage03()
//        RemoteImage2()
        RemoteImage3()
    }
}
