//
//  ViewParkingView.swift
//  ParkingApp
//
//  Created by Nathan Kennedy on 2021-01-24.
//

import SwiftUI

struct ViewParkingView: View {
    
    @EnvironmentObject var profileController: ProfileController
    @State private var parkingList:[Parking] = []
    @State private var email:String = ""
    @State private var deletionCheck = false
    @State private var indexToDelete:Int = -1
    
    @State private var parkingListItemPressed = false
    @State private var parkingInfo:Parking = Parking(email: "", buildingCode: "", hoursSelection: -1, suitNo: "", carPlateNumber: "", parkingAddr: "", date: Date(), parkingLat: 0.0, parkingLon: 0.0)
    
    
    
    var body: some View {
        
        NavigationView {
            
        
        
        
        
        
            VStack {
                NavigationLink(
                    destination: ViewParkingDetailsView(ParkingInfo: parkingInfo).environmentObject(profileController).navigationBarTitle("Parking Details"),
                    isActive: $parkingListItemPressed,
                    label: {
                    })
                
                
                
                
                List {
                    if(self.profileController.ParkingList != []){
                        Text("Tap an item to view detailed information.")
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                    
                    
                    ForEach(self.profileController.ParkingList.enumerated().map({$0}), id: \.element.self){ idx, parkingInfo in
                        NavigationLink(
                            destination: ViewParkingDetailsView(ParkingInfo: parkingInfo).environmentObject(profileController).navigationBarTitle("Parking Details"),
                            label: {
                                VStack(alignment: .leading , spacing: nil) {
                                    
                                    Text("\(parkingInfo.parkingAddr)")
                                    Text("Plate #: \(parkingInfo.carPlateNumber)")
                                    
                                }
                                .onTapGesture {
                                    print(#function, "task tapped")
                                    
                                    self.parkingInfo = parkingInfo
                                    self.parkingListItemPressed = true
                                    
                                }
                            })
                        
                    }
                    .onDelete{indexSet in
                        for index in indexSet {
                            
                            self.indexToDelete = index
                            self.deletionCheck = true
                                
                        }
                        
                    }
                }
                
                if(self.profileController.ParkingList == []){
                    Text("You haven't added any parking yet! Add parking under the 'Add Parking' tab, and come back after!")
                        .foregroundColor(.red)
                        .padding()
                }
                
                
                
                
            }
            .navigationBarTitle("Parking List", displayMode: .automatic)
            
        }
        .alert(isPresented: $deletionCheck) {
            Alert(title: Text("Delete?"), message: Text("Are you sure want to delete this parking record? This action cannot be undone."),  primaryButton: .destructive(Text("Yes"), action: {
                self.profileController.deleteParking(index: self.indexToDelete, email: self.email)
            }), secondaryButton: .default(Text("No"), action: {
                self.deletionCheck = false
            }))
        }
        .onAppear(){
            guard let email = UserDefaults.standard.string(forKey: "emailAddress") else {return}
            self.profileController.ParkingList = []
            self.email = email
            self.profileController.fetchParkingListByEmail(email: self.email)
            
        }
    }
}

struct ViewParkingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewParkingView()
    }
}
