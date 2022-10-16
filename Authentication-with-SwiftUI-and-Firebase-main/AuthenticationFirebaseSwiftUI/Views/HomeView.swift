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

                    NavigationLink(destination: TicsListView()) {
                        Text("My Tic Records")
                    }.frame(width: 360, height: 75, alignment: .center)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    NavigationLink(destination: TrackerView()) {
                        Text("My Tic Graph")
                    }.frame(width: 360, height: 75, alignment: .center)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    NavigationLink(destination: ResourcesView()) {
                        Text("Resources")
                    }.frame(width: 360, height: 75, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    NavigationLink(destination: AboutView()) {
                        Text("Learn More")
                    }.frame(width: 360, height: 75, alignment: .center)
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
                Text("Welcome to **My Tic Graph**. Use this graph to understand when your tics are the most active.").padding(24)
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
        }.navigationTitle("My Tic Graph")
        
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

struct AboutView: View{
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("**How do I use this app?**").font(.system(Font.TextStyle.title, design: .rounded)) .frame(width: 330, height: 30, alignment: .topLeading) .padding(.top, 25)
                    Text("To record a tic attack, go to “My Tic Records” and click on the '+' button on the top right of the page. Add the requested information. Once added, you can see a representation of the data in the “My Tic Graph” tab. You can find more information about Tourette's and tics under “Resources”.").font(.system(size: 20, design: .rounded)).padding(50)
                    Text("**What are Tics?**").font(.system(Font.TextStyle.title, design: .rounded)) .frame(width: 200, height: 30, alignment: .topLeading) .padding(.top, 25)
                    Text("Tics are sudden twitches, movements, or sounds that happen repeatedly. They are classified between vocal and motor tics or simple and complex tics. Vocal tics include someone making repeated sounds, while motor tics involve uncontrolled body movement. \n \n" + "Typically, simple tics involve only a few body parts, whereas complex tics involve a lot more and can have a pattern. Tics are unintentional and uncontrollable but can be suppressed by will in some scenarios.").font(.system(size: 20, design: .rounded)).padding(50)
                    Text("**Are there any cures?**").font(.system(Font.TextStyle.title, design: .rounded))
                    Text("No, there are currently no cures for Tourette syndrome. However, there are methods to help those with Tourette syndrome manage their tics. You can find more information on the TAA and CDC websites (under “Resources”).").font(.system(size: 20, design: .rounded)).padding(50)
                    Text("**Why was this app created?**").font(.system(Font.TextStyle.title, design: .rounded))
                    Text("This app stemmed from my tics. I created this app to help myself deal with my tics. After being diagnosed with a chronic tic disorder at the end of elementary school, I struggled with my tics throughout middle school, making my teachers angry and constantly disrupting class. \n \n" + "Among the numerous ways I tried to manage my tics, the most effective one was a tracker where I could understand when my tics would aggravate. A system where I could identify and visualize when my tics occurred was critical in helping me manage my tics. By understanding this, I figured out triggers that would lead to me doing certain tics. This app is meant to mimic that system for the user so that they can identify patterns and details to help manage their tics.").font(.system(size: 20, design: .rounded)).padding(50)
                    Spacer()
                }
                .navigationBarHidden(true)
            }
        }
        .navigationBarTitle("Learn More")
    }
}
