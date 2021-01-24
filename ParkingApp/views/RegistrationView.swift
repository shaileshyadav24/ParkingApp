//
//  RegistrationView.swift
//  ParkingApp
//
//  Created by Sargam on 24/01/21.
//

import SwiftUI
import Firebase

struct RegistrationView: View {
    
    @State private var name: String = ""
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var carPlateNumber: String = ""
    @State private var phoneNumber: String = ""
    @State private var isErrorMessage: Bool = true
    @State private var isMessageAvailable: Bool = false
    @State private var displayMessageString: String = ""
    @EnvironmentObject var profileController: ProfileController
    
    
    func textFieldValidatorEmail(email : String) -> Bool {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func validateAndRegisterUser() {
        self.isErrorMessage = true
        self.isMessageAvailable = false
        if(self.name != "" && self.emailAddress != "" && self.password != "" && self.confirmPassword != "" &&
            self.carPlateNumber != "" && self.phoneNumber != "") {
            if(textFieldValidatorEmail(email: self.emailAddress)) {
                if(self.password.count >= 6) {
                    if(self.password == self.confirmPassword) {
                        self.saveUserInFirebase()
                    } else {
                        self.isMessageAvailable = true
                        self.displayMessageString = "Password does not match"
                    }
                } else {
                    self.isMessageAvailable = true
                    self.displayMessageString = "Password must be more than 5 characters"
                }
            } else {
                self.isMessageAvailable = true
                self.displayMessageString = "Please enter correct email address"
            }
        } else {
            self.isMessageAvailable = true
            self.displayMessageString = "Please enter all details"
        }
    }
    
    func saveUserInFirebase() {
        self.profileController.searchIfEmailExit(email: self.emailAddress.lowercased()) { success in
            if(success) {
                self.isMessageAvailable = true
                self.displayMessageString = "Email address already exist. Please enter new one"
            } else {
                Auth.auth().createUser(withEmail: self.emailAddress.lowercased(), password: self.password) { authResult, error in
                    if let e = error {
                        print("Error while authenticate", e.localizedDescription)
                        self.isMessageAvailable = true
                        self.displayMessageString = e.localizedDescription
                    } else {
                        self.profileController.insertProfile(newProfile: Profile(email: self.emailAddress.lowercased(), name: self.name, contactNumber: self.phoneNumber, carPlateNumber: self.carPlateNumber))
                        self.isErrorMessage = false
                        self.isMessageAvailable = true
                        self.displayMessageString = "Account created successfully. Please try login"
                    }
                }
                print("Value of succes", success)
            }
        }
    }
    
    var body: some View {
        Text("Registration")
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
                
                Section(header: Text("Password"), content: {
                    SecureField("Please enter password",text: self.$password)
                })
                Section(header: Text("Confirm Password"), content: {
                    SecureField("Please re-enter password",text: self.$confirmPassword)
                })
                Section(header: Text("Contact Number"), content: {
                    TextField("Please enter phone number",text: self.$phoneNumber)
                        .keyboardType(.phonePad)
                })
                Section(header: Text("Car Plate Number"), content: {
                    TextField("Please enter car number",text: self.$carPlateNumber)
                })
            }
        }
        
        Text(self.displayMessageString)
            .foregroundColor(self.isErrorMessage ? Color.red: Color.green)
            .opacity(self.isMessageAvailable ? 1 : 0)
        
        Button(action: {
            self.validateAndRegisterUser()
        }, label: {
            Text("Register")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .frame(width: 200, height: 40)
                .background(Color.green)
                .cornerRadius(15.0)
        })
        Spacer()
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
