//
//  ContentView.swift
//  ParkingApp
//
//  Created by Sargam on 22/01/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var profileController: ProfileController

    var body: some View {
        if(UserDefaults.standard.string(forKey: "emailAddress") != nil) {
            DashboardView().environmentObject(profileController)
        } else{
            LoginView().environmentObject(profileController)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
