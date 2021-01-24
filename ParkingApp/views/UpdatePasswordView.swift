//
//  UpdatePasswordView.swift
//  ParkingApp
//
//  Created by Sargam on 24/01/21.
//

import SwiftUI
import Firebase
struct UpdatePasswordView: View {
    @EnvironmentObject var profileController : ProfileController
    @Environment(\.presentationMode) var presentationMode
    @State private var isErrorMessage: Bool = true
    @State private var isMessageAvailable: Bool = false
    @State private var displayMessageString: String = ""
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    
    func validateAndUpdatePassword() {
        self.isErrorMessage = true
        self.isMessageAvailable = false
        if(self.newPassword != "" && self.currentPassword != "" && self.newPassword.count >= 6 && self.newPassword != self.currentPassword) {
            self.revalidateUserAndUpdatePassword()
        } else if(self.newPassword == self.currentPassword) {
            self.isMessageAvailable = true
            self.displayMessageString = "Both passwords are same. Please enter unique new password"
        } else if(self.newPassword.count < 6) {
            self.isMessageAvailable = true
            self.displayMessageString = "Password must be more than 5 characters"
        }else {
            self.isMessageAvailable = true
            self.displayMessageString = "Please enter password"
        }
    }
    
    func revalidateUserAndUpdatePassword() {
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: self.profileController.profile.email, password: self.currentPassword)
        user?.reauthenticate(with: credential) { success, error in
          if let error = error {
            print("Error while re-authenticate", error.localizedDescription)
            self.isMessageAvailable = true
            self.displayMessageString = error.localizedDescription
          } else {
            user?.updatePassword(to: self.newPassword) { (error) in
                if let error = error {
                    print("Error while update password", error.localizedDescription)
                    self.isMessageAvailable = true
                    self.displayMessageString = error.localizedDescription
                } else {
                    self.isErrorMessage = false
                    self.isMessageAvailable = true
                    self.displayMessageString = "Password updated successfully"
                }
            }
          }
        }
    }
    
    var body: some View {
        Text("Update Password")
            .fontWeight(.bold)
            .font(.title)
            .padding(.top, 10)
        VStack{
            Form {
                Section(header: Text("Current Password"), content: {
                    SecureField("Please enter current password",text: self.$currentPassword)
                })
                Section(header: Text("New Password"), content: {
                    SecureField("Please enter new password",text: self.$newPassword)
                        .keyboardType(.emailAddress)
                })
            }
            Text(self.displayMessageString)
                .foregroundColor(self.isErrorMessage ? Color.red: Color.green)
                .opacity(self.isMessageAvailable ? 1 : 0)
            
            HStack {
                Button(action: {
                    self.validateAndUpdatePassword()
                }, label: {
                    Text("Update")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.green)
                        .cornerRadius(15.0)
                })
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text(self.isErrorMessage ? "Cancel" :"Close")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.red)
                        .cornerRadius(15.0)
                })
            }
            Spacer()
        }
    }
}

struct UpdatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        UpdatePasswordView()
    }
}
