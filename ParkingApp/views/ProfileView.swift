//
//  ProfileView.swift
//  ParkingApp
//
//  Created by Sargam on 24/01/21.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileController: ProfileController
    
    var body: some View {
        VStack(alignment: .leading , spacing: nil) {
            Text("Profile")
                .fontWeight(.bold)
                .font(.title)
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Name: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.name)")
            }
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Email Address: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.email)")
            }
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Phone: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.contactNumber)")
            }
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Car Plate: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.carPlateNumber)")
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
