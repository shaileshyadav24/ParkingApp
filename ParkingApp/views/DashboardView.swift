//
//  DashboardView.swift
//  ParkingApp
//
//  Created by Shailesh Yadav, 101332535 on 24/01/21.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    @EnvironmentObject var profileController: ProfileController
    @State private var emailAddress: String = ""
    @State private var showPopover = false
    @State private var isLogout: Bool = false
    @State private var selectedTab = 0
    
    
    
    // This method is to logout user
    func onLogout() {
        print("Loggin out ised")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "emailAddress")
            self.profileController.resetProfile()
            self.isLogout.toggle()
        } catch let error as NSError {
            print("Error in logout", error.localizedDescription)
        }
        
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack {
                NavigationLink(
                    destination: LoginView().environmentObject(profileController).navigationBarHidden(true),
                    isActive: $isLogout,
                    label: {
                    })
                
                TabView(selection: $selectedTab) {
                    
                    VStack{
                        AddParkingView().environmentObject(profileController)
                    }.onTapGesture {
                        self.selectedTab = 0
                    }.tabItem {
                        Image(systemName: "plus.viewfinder")
                        Text("Add Parking")
                    }.tag(0)
                    
                    
                    VStack{
                        
                        ViewParkingView().environmentObject(profileController)
                    }.onTapGesture {
                        self.selectedTab = 1
                    }
                    .tabItem {
                        Image(systemName: "location.fill.viewfinder")
                        Text("View Parking")
                    }.tag(1)
                    
                    VStack{
                        
                        ProfileView().environmentObject(profileController)
                    }.onTapGesture {
                        self.selectedTab = 2
                    }
                    .tabItem {
                        Image(systemName: "person.fill.viewfinder")
                        Text("Profile")
                    }.tag(2)
                    
                }
            }
            .navigationBarTitle(self.selectedTab == 0 ? "Add Parking" : (self.selectedTab == 1 ? "Parking List" : "Profile"), displayMode: .automatic)
            .navigationBarItems(trailing: Button(action:{
                self.showPopover = true
            }){
                Text("Logout")
            }).alert(isPresented: $showPopover) {
                Alert(title: Text("Logout"), message: Text("Are you sure want to logout?"),  primaryButton: .default(Text("Yes"), action: {
                    onLogout()
                }), secondaryButton: .default(Text("No"), action: {
                    self.showPopover = false
                }))
            }
            
            
            
            
            
        }
        
        .onAppear() {
            
            guard let email = UserDefaults.standard.string(forKey: "emailAddress") else {return}
            self.emailAddress = email.lowercased()
            self.profileController.fetchRecordUsingEmail(email: email)

        }
        .navigationBarTitle("ParkingApp", displayMode: .inline)
        .navigationBarItems(trailing: Button(action:{
            self.showPopover = true
        }){
            Text("Logout")
        }).alert(isPresented: $showPopover) {
            Alert(title: Text("Logout"), message: Text("Are you sure want to logout?"),  primaryButton: .default(Text("Yes"), action: {
                onLogout()
            }), secondaryButton: .default(Text("No"), action: {
                self.showPopover = false
            }))
        }
        
    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
