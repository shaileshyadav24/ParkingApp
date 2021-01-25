//
//  ViewParkingDetailsView.swift
//  ParkingApp
//
//  Created by Nathan Kennedy on 2021-01-24.
//

import SwiftUI

struct ViewParkingDetailsView: View {
    
    @EnvironmentObject var profileController: ProfileController
    var ParkingInfo:Parking
    let parkingHoursList = ["1 Hour or less", "4-Hour", "12-Hour", "24-Hour"]
    
    @State var buildingCode:String = ""
    @State var plateNo:String = ""
    @State var date:String = ""
    @State var email:String = ""
    @State var hoursSelection:Int = 0
    @State var parkingAddr:String = ""
    @State var parkingLat:Double = 0
    @State var parkingLon:Double = 0
    @State var suitNo:String = ""
    @State var codeSuit:String = ""
    @State var parkingTime:String = ""
    
    @State var displayMap:Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .center , spacing: nil) {
            
            NavigationLink(
                destination: MapView(ParkingInfo: ParkingInfo).environmentObject(profileController).navigationBarTitle("Map View", displayMode: .inline),
                isActive: $displayMap,
                label: {
                })
            
            Form {
                Section(header: Text("Parking Date and Time")) {
                    TextField("Date & Time", text: $date)
                        .keyboardType(.default)
                        .foregroundColor(Color.gray)
                        .disabled(true)
                }
                .foregroundColor(Color.white)
            
            
                Section(header: Text("Parking Address")) {
                    TextField("Parking Address", text: $parkingAddr)
                        .keyboardType(.default)
                        .foregroundColor(Color.gray)
                        .disabled(true)
                }
                .foregroundColor(Color.white)
            
            
                Section(header: Text("Building Code & Suit #")) {
                    TextField("Code & Suit", text: $codeSuit)
                        .keyboardType(.default)
                        .foregroundColor(Color.gray)
                        .disabled(true)
                }
                .foregroundColor(Color.white)
            
            
                Section(header: Text("Car Plate #")) {
                    TextField("PlateNo", text: $plateNo)
                        .keyboardType(.default)
                        .foregroundColor(Color.gray)
                        .disabled(true)
                }
                .foregroundColor(Color.white)
            
            
                Section(header: Text("Parking Time")) {
                    TextField("Parking Time", text: $parkingTime)
                        .keyboardType(.default)
                        .foregroundColor(Color.gray)
                        .disabled(true)
                }
                .foregroundColor(Color.white)
            }
            
            Spacer()
            Button(action: {
                self.displayMap.toggle()
            }, label: {
                Text("View on Map")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .frame(width: 300, height: 40)
                    .background(Color.green)
                    .cornerRadius(10.0)
            })
            .ignoresSafeArea(.keyboard)
            Spacer()
            
        }
        .onAppear(){
            self.buildingCode = ParkingInfo.buildingCode
            self.plateNo = ParkingInfo.carPlateNumber
            
            
            let today = ParkingInfo.date
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            print(formatter1.string(from: today))
            
            let formatter2 = DateFormatter()
            formatter2.timeStyle = .medium
            print(formatter2.string(from: today))
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "HH:mm E, d MMM y"
            print(formatter3.string(from: today))
            let dateString = formatter3.string(from: today)
            
            self.date = dateString
            
            
            self.email = ParkingInfo.email
            self.hoursSelection = ParkingInfo.hoursSelection
            self.parkingAddr = ParkingInfo.parkingAddr
            self.parkingLat = ParkingInfo.parkingLat
            self.parkingLon = ParkingInfo.parkingLon
            self.suitNo = ParkingInfo.suitNo
            
            self.codeSuit = "Building \(self.buildingCode), Suit \(self.suitNo)"
            self.parkingTime = parkingHoursList[ParkingInfo.hoursSelection]
            
            
        }
        
    }
}

struct ViewParkingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewParkingDetailsView(ParkingInfo: Parking())
    }
}
