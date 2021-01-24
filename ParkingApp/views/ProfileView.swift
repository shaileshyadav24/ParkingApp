//
//  ProfileView.swift
//  ParkingApp
//
//  Created by Sargam on 24/01/21.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var profileController: ProfileController
    @State private var showEditProfileView = false
    @State private var showDeleteProfilePopup = false
    @State private var isLogout = false
    
    
    func initiateDeleteUser() {
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error occurred", error)
            } else {
                self.isLogout.toggle()
                UserDefaults.standard.removeObject(forKey: "emailAddress")
                self.profileController.deleteProfile(id: self.profileController.profile.id!)
                self.profileController.resetProfile()
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading , spacing: nil) {
            NavigationLink(
                destination: LoginView().environmentObject(profileController).navigationBarHidden(true),
                isActive: $isLogout,
                label: {
                })
            Text("Profile")
                .fontWeight(.bold)
                .font(.title)
                .padding(.bottom, 30)
                .padding(.top, 30)
            
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Name: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.name)")
            }.padding(.bottom, 10)
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Email Address: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.email)")
            }.padding(.bottom, 10)
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Phone: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.contactNumber)")
            }.padding(.bottom, 10)
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Car Plate: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.carPlateNumber)")
            }.padding(.bottom, 10)
            Spacer()
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                Button(action: {
                    self.showEditProfileView = true
                }, label: {
                    Text("Edit Profile")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color.yellow)
                        .cornerRadius(10.0)
                })
//                Button(action: {
//                    self.showDeleteProfilePopup = true
//                }, label: {
//                    Text("Change password")
//                        .font(.title)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 300, height: 40)
//                        .background(Color.yellow)
//                        .cornerRadius(10.0)
//                }).alert(isPresented: $showDeleteProfilePopup) {
//                    Alert(title: Text("Delete"), message: Text("Are you sure want to delete your account?"),  primaryButton: .destructive(Text("Yes"), action: {
//                        initiateDeleteUser()
//                    }), secondaryButton: .default(Text("No"), action: {
//                        self.showDeleteProfilePopup = false
//                    }))
//                }
                Button(action: {
                    self.showDeleteProfilePopup = true
                }, label: {
                    Text("Delete Profile")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color.red)
                        .cornerRadius(10.0)
                        .padding(.bottom, 30)
                }).alert(isPresented: $showDeleteProfilePopup) {
                    Alert(title: Text("Delete"), message: Text("Are you sure want to delete your account? All details will be removed."),  primaryButton: .destructive(Text("Yes"), action: {
                        initiateDeleteUser()
                    }), secondaryButton: .default(Text("No"), action: {
                        self.showDeleteProfilePopup = false
                    }))
                }
            }.sheet(isPresented: self.$showEditProfileView){
                EditProfileView().environmentObject(profileController)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
