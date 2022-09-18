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
            List {
                ForEach (resourceList) { resource in
//                    Text(resource.name)
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
