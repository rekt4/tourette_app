//
//  HomeView.swift
//  AuthenticationStarter
//
//  Created by Work on 13.12.21.
//

import SwiftUI
import Firebase

struct HomeView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var signOutProcessing = false
    @State var isNavigationLinkActive = true
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Text("Welcome to Tic Tracker! The purpose of this app is to help those with Tourette Syndrome and Tic Disorders. Being able to understand the pattern of one's tics leads to the possiblity of being able to manage and control them.").font(.system(Font.TextStyle.body, design: .rounded)).padding(10)
                    Text("To begin, go to the **Data** tab. When the user has a tic attack, he/she will click on the 'plus' button on the top right of the page and input the requested information. Once completed, the user can see a representation of their data in the **Tic Tracker** tab.").font(.system(Font.TextStyle.body, design: .rounded)).padding(10)
                    Text("For resources and important links regarding tics and Tourette's, proceed to the **Resources** tab. To briefly learn more about Tourette Syndrome, proceed to **Learn More**.").font(.system(Font.TextStyle.body, design: .rounded)).padding(10)

                    NavigationLink(destination: TicsListView()) {
                        Text("Data")
                    }.frame(width: 250, height: 50, alignment: .center)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    NavigationLink(destination: TrackerView()) {
                        Text("Tic Tracker")
                    }.frame(width: 250, height: 50, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    NavigationLink(destination: ResourceView()) {
                        Text("Resources")
                    }.frame(width: 250, height: 50, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    NavigationLink(destination: AboutView()) {
                        Text("Learn More")
                    }.frame(width: 250, height: 50, alignment: .center)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Spacer()
                }
                    .navigationTitle("Home")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if signOutProcessing {
                                ProgressView()
                            } else {
                                Button("Sign Out") {
                                    signOutUser()
                                }
                            }
                        }
                    }
            }
        }
        
    }
    
    func signOutUser() {
        signOutProcessing = true
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
            signOutProcessing = false
        }
        withAnimation {
            viewRouter.currentPage = .signInPage
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ResourceView: View {
    var body: some View {
        VStack {
            Text("**Resources**").font(.system(Font.TextStyle.title, design: .rounded)) .frame(width: 150, height: 30, alignment: .topLeading)
            Form {
                Link("Tourette Association of America",
                    destination: URL(string: "https://tourette.org")!)

                Link("Find a Local TAA Chapter",
                    destination: URL(string: "https://tourette.org/resources/local-support/")!)
                
                Link("CDC Website on Tourette Syndrome",
                     destination: URL(string: "https://www.cdc.gov/ncbddd/tourette/index.html")!)
            }
        }
    }
}



struct TrackerView: View {
    
    @ObservedObject var model = TicGraphViewModel()
    @State var pickerSelectedItem = 0

    var body: some View {
        ZStack {
            Color("Color").edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Tic Tracker")
                    .font(.system(size: 34))
                    .fontWeight(.heavy)
                Picker(selection: $pickerSelectedItem, label: Text("")) {
                    Text("Morning").tag(0)
                    Text("Afternoon").tag(1)
                    Text("Evening").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                HStack {
                    BarView(value: 10*model.arr[pickerSelectedItem][0], day: "S", height: 200)
                    BarView(value: 10*model.arr[pickerSelectedItem][1], day: "M", height: 200)
                    BarView(value: 10*model.arr[pickerSelectedItem][2], day: "T", height: 200)
                    BarView(value: 10*model.arr[pickerSelectedItem][3], day: "W", height: 200)
                    BarView(value: 10*model.arr[pickerSelectedItem][4], day: "Th", height: 200)
                    BarView(value: 10*model.arr[pickerSelectedItem][5], day: "F", height: 200)
                    BarView(value: 10*model.arr[pickerSelectedItem][6], day: "S", height: 200)
                }.padding(.top, 24)
            }
            
        }
    }
    
    init () {
        model.getData()
    }
}

struct BarView: View {
    
    var value: Int
    var day: String
    var height: Int
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                Capsule().frame(width: 30, height: CGFloat(height))
                    .foregroundColor(.gray)
                Capsule().frame(width: 30, height: CGFloat(value)) // change values here
                    .foregroundColor(.white)
            }
            Text(day).padding(.top, 8)
        }
    }
}

struct AttackView: View {
    var body: some View {
        Text("attack view")
    }
}

struct AboutView: View{
    var body: some View {
        VStack {
            Text("**What are Tics?**").font(.system(Font.TextStyle.title, design: .rounded)) .frame(width: 200, height: 30, alignment: .topLeading)
            Text("Tics are defined as sudden twitches, movements, or sounds that people do repeatedly. They can be classified as either vocal, or motor. As they sound, vocal tics have to do with someone making sounds with their voice, and motor tics are those which concern the movement of the body.").font(.system(Font.TextStyle.body, design: .rounded)).padding(10)
            Text("Another important classification of tics is between simple ones and complex ones. Typically, simple tics involve only a few parts of the body, whereas complex tics involve a lot more and can have a pattern. In general, tics are thought to be unintentional, but can be suppressed by will in certain scenarios.").font(.system(Font.TextStyle.body, design: .rounded)).padding(10)
            Spacer()
        }
    }
}
