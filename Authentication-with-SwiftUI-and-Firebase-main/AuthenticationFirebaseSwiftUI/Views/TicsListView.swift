//
//  ContentView.swift
//  TicSpine
//
//  Created by Peter Friese on 15/04/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct TicsListView: View {
  // MARK: - State
  
    @StateObject var viewModel = TicsListViewModel()
    @State var presentAddTicSheet = false
    @State var isNavigationLinkActive = false
  
  // MARK: - UI Components
  
    private var addButton: some View {
        Button(action: {
            self.presentAddTicSheet.toggle()
            isNavigationLinkActive = true
        }) {
            Image(systemName: "plus")
        }
    }

    private func ticRowView(tic: Tic) -> some View {
        NavigationLink(destination: TicDetailsView(tic: tic), isActive: $isNavigationLinkActive) {
            VStack(alignment: .leading) {
                Text(tic.type.uppercased())
                    .font(.headline)
                Text(tic.dayOfWeek.uppercased())
                    .font(.subheadline)
                Text(tic.timeOfDay.uppercased())
                    .font(.subheadline)
                Text("Intensity: \(tic.intensity)")
                    .font(.subheadline)
            }
        }
        .navigationBarTitle(Text("Tics"))
    }
        
    var body: some View {
        let ticList = viewModel.tics.compactMap { $0 }
        VStack {
            Text("Click the 'plus' icon on the upper right hand corner of your screen to add a tic!").font(.system(Font.TextStyle.body, design: .rounded)).padding(10)
            List {
                ForEach (ticList) { tic in
                    ticRowView(tic: tic)
                }
                .onDelete() { indexSet in
                    viewModel.removeTics(atOffsets: indexSet)
                }
            }
            .navigationBarTitle("Tics")
            .navigationBarItems(trailing: addButton)
            .onAppear() {
                print("TicsListView appears. Subscribing to data updates.")
                self.viewModel.subscribe()
            }
            .onDisappear() {
        // By unsubscribing from the view model, we prevent updates coming in from
        // Firestore to be reflected in the UI. Since we do want to receive updates
        // when the user is on any of the child screens, we keep the subscription active!
        //
        // print("TicsListView disappears. Unsubscribing from data updates.")
        // self.viewModel.unsubscribe()
            }
            .sheet(isPresented: self.$presentAddTicSheet) {
                TicEditView()
            }
        }
    }
}

struct TicsListView_Previews: PreviewProvider {
  static var previews: some View {
    TicsListView()
  }
}
