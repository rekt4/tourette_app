//
//  ResourcesView.swift
//  AuthenticationFirebaseSwiftUI
//
//  Created by Nikhil M on 9/10/22.
//

import SwiftUI

struct ResourcesView: View {
    @ObservedObject var resourceViewModel = ResourceListViewModel()

    var body: some View {
        let resourceList = resourceViewModel.resources.compactMap { $0 }
        
        VStack {
            Text("Here are a few resources that are helpful to understand Tourette syndrome.").padding(24)
            List {
                ForEach (resourceList) { resource in
                    Link(resource.name, destination: URL(string: resource.link)!)
                }
            }
            .navigationBarTitle("Resources")
            .onAppear() {
                print("ResourceView appears. Subscribing to data updates.")
                self.resourceViewModel.subscribe()
            }
        }
    }
}

struct ResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesView()
    }
}
