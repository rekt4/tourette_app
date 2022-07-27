//
//  BookEditView.swift
//  BookSpine
//
//  Created by Peter Friese on 07/05/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

enum Mode {
  case new
  case edit
}

enum Action {
  case delete
  case done
  case cancel
}

struct TicEditView: View {
  // MARK: - State
  
  @Environment(\.presentationMode) private var presentationMode
  @State var presentActionSheet = false

  // MARK: - State (Initialiser-modifiable)
  
  @ObservedObject var viewModel = TicDetailsViewModel()
  var mode: Mode = .new
  var completionHandler: ((Result<Action, Error>) -> Void)?
  
  // MARK: - UI Components
    
  var cancelButton: some View {
    Button(action: { self.handleCancelTapped() }) {
      Text("Cancel")
    }
  }
  
  var saveButton: some View {
    Button(action: { self.handleDoneTapped() }) {
      Text(mode == .new ? "Done" : "Save")
    }
    .disabled(!viewModel.modified)
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Tic")) {
          TextField("Title", text: $viewModel.tic.type)
          TextField("Intensity of Tic", value: $viewModel.tic.intensity, formatter: NumberFormatter())
        }
        
        Section(header: Text("When")) {
            TextField("Time of Day", text: $viewModel.tic.timeOfDay)
            TextField("Day of the Week", text: $viewModel.tic.dayOfWeek)
        }
        
        if mode == .edit {
          Section {
            Button("Delete book") { self.presentActionSheet.toggle() }
              .foregroundColor(.red)
          }
        }
      }
      .navigationTitle(mode == .new ? "New tic" : viewModel.tic.type)
      .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
      .navigationBarItems(
        leading: cancelButton,
        trailing: saveButton
      )
      .actionSheet(isPresented: $presentActionSheet) {
        ActionSheet(title: Text("Are you sure?"),
                    buttons: [
                      .destructive(Text("Delete tic"),
                                   action: { self.handleDeleteTapped() }),
                      .cancel()
                    ])
      }
    }
  }
  
  // MARK: - Action Handlers
  
  func handleCancelTapped() {
    self.dismiss()
  }
  
  func handleDoneTapped() {
    self.viewModel.handleDoneTapped()
    self.dismiss()
  }
  
  func handleDeleteTapped() {
    viewModel.handleDeleteTapped()
    self.dismiss()
    self.completionHandler?(.success(.delete))
  }
  
  func dismiss() {
    self.presentationMode.wrappedValue.dismiss()
  }
}

struct TicEditView_Previews: PreviewProvider {
  static var previews: some View {
    let tic = Tic(dayOfWeek: "", timeOfDay: "", type: "", intensity: 0)
    let ticViewModel = TicDetailsViewModel(tic: tic)
    return TicEditView(viewModel: ticViewModel, mode: .edit)
  }
}
