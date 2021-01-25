//
//  ContentView.swift
//  ParkingApp
//
//  Created by Shailesh Yadav, 101332535 on 22/01/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var profileController: ProfileController

    var body: some View {
//        NavigationView {
            if(UserDefaults.standard.string(forKey: "emailAddress") != nil) {
                DashboardView().environmentObject(profileController).navigationBarTitle("test")
            } else{
                LoginView().environmentObject(profileController)
            }
//        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
