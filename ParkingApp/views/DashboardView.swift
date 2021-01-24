//
//  DashboardView.swift
//  ParkingApp
//
//  Created by Sargam on 24/01/21.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    @EnvironmentObject var profileController: ProfileController
    @State private var emailAddress: String = ""
    @State private var showPopover = false
    
    func onLogout() {
        print("Loggin out ised")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removeObject(forKey: "emailAddress")
            //            self.isLogout.toggle()
        } catch let error as NSError {
            
        }
        
    }
    
    var body: some View {
        NavigationView {
            TabView {
                ProfileView().environmentObject(profileController)
                    .tabItem {
                        Image(systemName: "contacts.fill")
                        Text("Profile")
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
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
