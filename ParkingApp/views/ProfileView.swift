//
//  ProfileView.swift
//  ParkingApp
//
//  Created by Shailesh Yadav, 101332535 on 24/01/21.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var profileController: ProfileController
    @State private var showEditProfileView = false
    @State private var showDeleteProfilePopup = false
    @State private var showPasswordChangeView = false
    @State private var showPasswordVerifyPopup = false
    @State private var isLogout = false
    @State private var currentPassword: String = ""
    @State private var isErrorMessage: Bool = true
    @State private var isMessageAvailable: Bool = false
    @State private var displayMessageString: String = ""
    @State private var loggingOut = false
    @State private var showPopover = false
    @State private var currentActiveSheet: ActiveSheet? = nil
    
    // New logout function
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
    
    // THis method will reautheticate user and then delete entry from Firebase Authenticator and FIrebase DB
    func initiateDeleteUser() {
        self.isErrorMessage = true
        self.isMessageAvailable = false
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: self.profileController.profile.email, password: self.currentPassword)
        user?.reauthenticate(with: credential) { success, error in
            if let error = error {
                print("Error while re-authenticate", error.localizedDescription)
                self.isMessageAvailable = true
                self.displayMessageString = error.localizedDescription
            } else {
                self.currentActiveSheet = nil
                user?.delete { error in
                    if let error = error {
                        print("Error occurred", error)
                    } else {
                        self.isLogout.toggle()
                        UserDefaults.standard.removeObject(forKey: "emailAddress")
                        self.profileController.deleteProfile(id: self.profileController.profile.id!, email: self.profileController.profile.email)
                        self.profileController.resetProfile()
                    }
                }
            }
        }
    }
    
    var body: some View {
        
        VStack(alignment: .leading , spacing: nil) {
            
            NavigationLink(
                destination: LoginView().environmentObject(profileController).navigationBarHidden(true),
                isActive: $loggingOut,
                label: {
                })
            
            
            
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Name: ")
                    .fontWeight(.bold)
                Text("\(self.profileController.profile.name)")
            }.padding(.bottom, 10)
            .padding(.top, 10)
            HStack(alignment: .firstTextBaseline , spacing: 1) {
                Text("Email: ")
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
                    //                    self.showEditProfileView = true
                    self.currentActiveSheet = .updateProfile
                }, label: {
                    Text("Edit Profile")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color.yellow)
                        .cornerRadius(10.0)
                })
                Button(action: {
                    self.currentActiveSheet = .updatePassword
                }, label: {
                    Text("Change password")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color.yellow)
                        .cornerRadius(10.0)
                })
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
                })
                
            }
        }
        .alert(isPresented: $showDeleteProfilePopup) {
            Alert(title: Text("Delete"), message: Text("Are you sure want to delete your account? All details will be removed."),  primaryButton: .destructive(Text("Yes"), action: {
                self.currentActiveSheet = .deleteAccount
            }), secondaryButton: .default(Text("No"), action: {
                self.showDeleteProfilePopup = false
            }))
        }
        .sheet(item: self.$currentActiveSheet){ item in
            switch item {
            case .updatePassword:
                UpdatePasswordView().environmentObject(profileController)
            case .updateProfile:
                EditProfileView().environmentObject(profileController)
            case .deleteAccount:
                Text("Verify User")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.top, 10)
                VStack{
                    Form {
                        Section(header: Text("Password"), content: {
                            SecureField("Please enter password",text: self.$currentPassword)
                        })
                    }
                    Text(self.displayMessageString)
                        .foregroundColor(self.isErrorMessage ? Color.red: Color.green)
                        .opacity(self.isMessageAvailable ? 1 : 0)
                    
                    HStack {
                        Button(action: {
                            self.initiateDeleteUser()
                        }, label: {
                            Text("Submit")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 150, height: 40)
                                .background(Color.green)
                                .cornerRadius(15.0)
                        })
                        Button(action: {
                            self.currentActiveSheet = nil
                            self.currentPassword = ""
                        }, label: {
                            Text("Cancel")
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
    }
    
    
}

enum ActiveSheet: Identifiable {
    case updatePassword
    case updateProfile
    case deleteAccount
    
    
     var id: Int {
         hashValue
     }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
