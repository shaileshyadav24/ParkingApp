//
//  LoginView.swift
//  ParkingApp
//
//  Created by Shailesh Yadav, 101332535 on 24/01/21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @EnvironmentObject var profileController: ProfileController
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var isLogin = false
    @State private var isRegistration = false
    @State var displayErrorMessage:String  = ""
    @State var isErrorMessage: Bool = false
    
    func onSubmitClicked() {
        self.isErrorMessage = false
        if self.emailAddress != "" && self.password != "" {
            Auth.auth().signIn(withEmail: self.emailAddress, password: self.password) { (authData, error) in
                if let e = error {
                    self.isErrorMessage = true
                    self.displayErrorMessage = e.localizedDescription
                    return
                } else {
                    if((authData?.user.isEmailVerified) != nil) {
                        self.isLogin.toggle()
                        UserDefaults.standard.set(self.emailAddress.lowercased(), forKey: "emailAddress")
                    }
                }
            }
        } else if self.emailAddress == "" {
            self.isErrorMessage = true
            self.displayErrorMessage = "Please enter email address"
        }  else if self.password == "" {
            self.isErrorMessage = true
            self.displayErrorMessage = "Please enter password"
        }
    }
    
    
    var body: some View {
        NavigationView{
            
            VStack {
                NavigationLink(
                    destination: RegistrationView().environmentObject(profileController).navigationBarTitle("", displayMode: .inline),
                    isActive: $isRegistration,
                    label: {
                    })
                NavigationLink(
                    destination: DashboardView().environmentObject(profileController).navigationBarHidden(true),
                    isActive: $isLogin,
                    label: {
                    })
                Text("ParkingApp")
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                TextField("Email", text: self.$emailAddress)
                    .border(Color.gray)
                    .padding(.bottom, 10)
                    .cornerRadius(5.0)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: self.$password)
                    .border(Color.gray)
                    .padding(.bottom, 10)
                    .cornerRadius(5.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text(self.displayErrorMessage)
                    .foregroundColor(Color.red)
                    .opacity(self.isErrorMessage ? 1 : 0)
                    .padding(.bottom, 5)
                
                
                Button(action: {
                    self.onSubmitClicked()
                }, label: {
                    Text("Login")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 40)
                        .background(Color.green)
                        .cornerRadius(10.0)
                        .padding(.bottom, 30)
                })
                
                Button(action: {
                    self.isRegistration = true
                }, label: {
                    Text("Create Account")
                })
                
                Spacer()
                
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding(.top, 50)
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
