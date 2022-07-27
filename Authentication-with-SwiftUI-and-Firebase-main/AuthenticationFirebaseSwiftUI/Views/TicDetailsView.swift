//
//  BookDetailsView.swift
//  BookSpine
//
//  Created by Peter Friese on 15/09/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct TicDetailsView: View {
  // MARK: - State
  
  @Environment(\.presentationMode) var presentationMode
  @State var presentEditTicSheet = false
  
  // MARK: - State (Initialiser-modifiable)
  
  var tic: Tic
  
  // MARK: - UI Components
  
  private func editButton(action: @escaping () -> Void) -> some View {
    Button(action: { action() }) {
      Text("Edit")
    }
  }
  
  var body: some View {
    Form {
      Section(header: Text("Tic")) {
        Text(tic.type)
        Text("\(tic.intensity)")
      }
      
      Section(header: Text("Time")) {
        Text(tic.dayOfWeek)
        Text(tic.timeOfDay)
      }
    }
    .navigationBarTitle(Text("Tics"))
    .navigationBarItems(trailing: editButton {
      self.presentEditTicSheet.toggle()
    })
    .onAppear() {
      print("TicDetailsView.onAppear() for \(self.tic.type)")
    }
    .onDisappear() {
      print("TicDetailsView.onDisappear()")
    }
    .sheet(isPresented: self.$presentEditTicSheet) {
      TicEditView(viewModel: TicDetailsViewModel(tic: tic), mode: .edit) { result in
        if case .success(let action) = result, action == .delete {
          self.presentationMode.wrappedValue.dismiss()
        }
      }
    }
  }
  
}

struct BookDetailsView_Previews: PreviewProvider {
  static var previews: some View {
      let tic = Tic(dayOfWeek: "", timeOfDay: "", type: "", intensity: 0)
    return
      NavigationView {
        TicDetailsView(tic: tic)
      }
  }
}
