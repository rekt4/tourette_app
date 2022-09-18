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
    @ObservedObject var welcomeTextViewModel = HomeTextViewModel()
    @State var signOutProcessing = false
    @State var isNavigationLinkActive = true
    
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Text(HomeTextViewModel.arr[0]).font(.system(Font.TextStyle.body, design: .rounded)).padding(20)
                    Text(HomeTextViewModel.arr[1]).font(.system(Font.TextStyle.body, design: .rounded)).padding(20)
                    Text(HomeTextViewModel.arr[2]).font(.system(Font.TextStyle.body, design: .rounded)).padding(20)

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

                    NavigationLink(destination: ResourcesView()) {
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
    init () {

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


struct TrackerView: View {
    
    @ObservedObject var model = TicGraphViewModel()
    @State var pickerSelectedItem = 0

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to **Tic Tracker**. Here, you can see a graphical representation of your tics as a distribution separated by day of the week. The tics are also distributed by time of day — selected between **Morning**, **Afternoon**, and **Evening**.").padding(24)
                Picker(selection: $pickerSelectedItem, label: Text("")) {
                    Text("Morning").tag(0)
                    Text("Afternoon").tag(1)
                    Text("Evening").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                HStack {
                    BarView(value: 10 * model.arr[pickerSelectedItem][0], day: "S", height: 250)
                    BarView(value: 10 * model.arr[pickerSelectedItem][1], day: "M", height: 250)
                    BarView(value: 10 * model.arr[pickerSelectedItem][2], day: "T", height: 250)
                    BarView(value: 10 * model.arr[pickerSelectedItem][3], day: "W", height: 250)
                    BarView(value: 10 * model.arr[pickerSelectedItem][4], day: "Th", height: 250)
                    BarView(value: 10 * model.arr[pickerSelectedItem][5], day: "F", height: 250)
                    BarView(value: 10 * model.arr[pickerSelectedItem][6], day: "S", height: 250)
                }.padding(.top, 24)
                Spacer()
            }
            .navigationBarHidden(true)
        }.navigationTitle("Tic Tracker")
        
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
                    .foregroundColor(.blue)
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
        NavigationView {
            ScrollView {
                VStack {
                    Text("**What are Tics?**").font(.system(Font.TextStyle.title, design: .rounded)) .frame(width: 200, height: 30, alignment: .topLeading) .padding(.top, 25)
                    Text("Tics are defined as sudden twitches, movements, or sounds that people do repeatedly. They can be classified as either vocal, or motor. As they sound, vocal tics have to do with someone making sounds with their voice, and motor tics are those which concern the movement of the body. \n \n" + "Another important classification of tics is between simple ones and complex ones. Typically, simple tics involve only a few parts of the body, whereas complex tics involve a lot more and can have a pattern. In general, tics are thought to be unintentional, but can be suppressed by will in certain scenarios.").font(.system(size: 20, design: .rounded)).padding(50)
                    Text("**Are there any cures?**").font(.system(Font.TextStyle.title, design: .rounded))
                    Text("No, there are currently no direct cures for Tourette syndrome, however there are various methods to help those with Tourette’s control their tics. More information on this can be found on both the TAA and CDC website linked under “Resources”.").font(.system(size: 20, design: .rounded)).padding(50)
                    Text("**Why was this app created?**").font(.system(Font.TextStyle.title, design: .rounded))
                    Text("This app stemmed from my own tics. I originally created this app as a way to help myself deal with my tics. After being diagnosed with a chronic tic disorder at the end of elementary school, I struggled with my tics all throughout middle school, making my teachers angry and constantly disrupting class. \n \n" + "Among the numerous ways I tried to manage my tics, I found the most effective one being a tracker where I could understand when my tics would aggravate. A system where I could identify and visualize when my tics occurred was an important tool to help me manage my tics. By understanding this, I was able to figure out certain triggers that would lead to me doing certain tics. This app is meant to mimic that system for the user so that they can identify certain patterns and details to help manage their tics.").font(.system(size: 20, design: .rounded)).padding(50)
                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
        .navigationBarTitle("Learn More")
    }
}
