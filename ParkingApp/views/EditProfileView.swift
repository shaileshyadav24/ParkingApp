//
//  EditProfileView.swift
//  ParkingApp
//
//  Created by Shailesh Yadav, 101332535 on 24/01/21.
//

import SwiftUI
import Firebase

struct EditProfileView: View {
    @EnvironmentObject var profileController : ProfileController
    @State private var name: String = ""
    @State private var emailAddress: String = ""
    @State private var carPlateNumber: String = ""
    @State private var phoneNumber: String = ""
    @State private var isErrorMessage: Bool = true
    @State private var isMessageAvailable: Bool = false
    @State private var displayMessageString: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    
    func textFieldValidatorEmail(email : String) -> Bool {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateAndUpdateUser() {
        self.isErrorMessage = true
        self.isMessageAvailable = false
        if(self.name != "" && self.emailAddress != "" &&
            self.carPlateNumber != "" && self.phoneNumber != "") {
            if(textFieldValidatorEmail(email: self.emailAddress)) {
                self.updateUserInProfile()
            } else {
                self.isMessageAvailable = true
                self.displayMessageString = "Please enter correct email address"
            }
        } else {
            self.isMessageAvailable = true
            self.displayMessageString = "Please enter all details"
        }
    }
    
    func updateUserInProfile() {
        self.profileController.searchIfEmailExitForExistingUser(email: self.emailAddress.lowercased(), id: self.profileController.profile.id!) { success in
            if(success) {
                self.isMessageAvailable = true
                self.displayMessageString = "Email address already exist. Please enter new"
            } else {
                Auth.auth().currentUser?.updateEmail(to: self.emailAddress.lowercased()) { error in
                    if let e = error {
                        self.isMessageAvailable = true
                        self.displayMessageString = e.localizedDescription
                    } else {
                        UserDefaults.standard.set(self.emailAddress.lowercased(), forKey: "emailAddress")
                        self.profileController.updateProfile(id: self.profileController.profile.id!,
                                                             profile: Profile(email: self.emailAddress, name: self.name, contactNumber: self.phoneNumber, carPlateNumber: self.carPlateNumber))
                        self.profileController.fetchRecordUsingEmail(email: self.emailAddress.lowercased())
                        self.isErrorMessage = false
                        self.isMessageAvailable = true
                        self.displayMessageString = "Account updated successfully"
                    }
                }
            }
        }
    }
    
    
    var body: some View {
        Text("Update Profile")
            .fontWeight(.bold)
            .font(.title)
            .padding(.top, 10)
        VStack{
            Form {
                Section(header: Text("Name"), content: {
                    TextField("Please enter name",text: self.$name)
                })
                Section(header: Text("Email Address"), content: {
                    TextField("Please enter email address",text: self.$emailAddress)
                        .keyboardType(.emailAddress)
                })
                Section(header: Text("Contact Number"), content: {
                    TextField("Please enter phone number",text: self.$phoneNumber)
                        .keyboardType(.phonePad)
                })
                Section(header: Text("Car Plate Number"), content: {
                    TextField("Please enter car number",text: self.$carPlateNumber)
                })
            }
        }.onAppear() {
            let profile = self.profileController.profile
            self.name = profile.name
            self.emailAddress = profile.email
            self.carPlateNumber = profile.carPlateNumber
            self.phoneNumber = profile.contactNumber
        }
        
        Text(self.displayMessageString)
            .foregroundColor(self.isErrorMessage ? Color.red: Color.green)
            .opacity(self.isMessageAvailable ? 1 : 0)
        
        HStack {
            Button(action: {
                self.validateAndUpdateUser()
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

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
