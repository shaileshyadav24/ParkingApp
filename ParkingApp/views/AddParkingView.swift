//
//  AddParkingView.swift
//  ParkingApp
//
//  Created by Nathan Kennedy on 2021-01-24.
//

import SwiftUI
import CoreLocation

struct AddParkingView: View {
    
    @State private var email:String = ""
    @EnvironmentObject var profileController: ProfileController
    @State private var buildingCode:String = ""
    @State private var hoursSelection = 0
    @State private var carPlate = ""
    @State private var suitNo = ""
    @State private var disabledColor = Color.white
    @State private var displayLocationAlert = false
    @State private var couldFindCoords = false
    let geocoder = CLGeocoder()
    @ObservedObject var locationManager = LocationManager()
    var userLatitude: Double {
            return Double(locationManager.lastLocation?.coordinate.latitude ?? 0)
        }

        var userLongitude: Double {
            return Double(locationManager.lastLocation?.coordinate.longitude ?? 0)
        }
    @State var useLocationIsChecked:Bool = false
    
    
    @State private var parkingAddr = ""
    @State private var parkingLat:Double = 0
    @State private var parkingLon:Double = 0
    let parkingHoursList = ["1 Hour or less", "4-Hour", "12-Hour", "24-Hour"]
    
    
    func toggle(){
        useLocationIsChecked = !useLocationIsChecked
        
        if(useLocationIsChecked){
            print(#function, "LAT: \(userLatitude) LON: \(userLongitude)")
            if(userLatitude == 0 || userLongitude == 0) {
                self.displayLocationAlert = true
                useLocationIsChecked = !useLocationIsChecked
            }
            else {
                self.getAddress(location: CLLocation(latitude: CLLocationDegrees(userLatitude), longitude: CLLocationDegrees(userLongitude)))
                self.disabledColor = Color.gray
                self.parkingLat = userLatitude
                self.parkingLon = userLongitude
                self.couldFindCoords = true
            }
            
        }
        else {
            self.parkingAddr = ""
            self.disabledColor = Color.white
        }
    }
    
    @State private var parkingDateTime = Date()
    @State private var displayAddErrorAlert = false
    @State private var addErrorTitle:String?
    @State private var addErrorDesc:String?
    
    @State private var buildingCodeMissing = false
    @State private var carPlateMissing = false
    @State private var suitNoMissing = false
    @State private var parkingAddrMissing = false
    
    
    func addParkingButtonPressed() {
        print(#function, "Add Parking Button Pressed.")
        print(#function, "useLocationIsChecked: \(useLocationIsChecked)")
        print(#function, parkingHoursList[hoursSelection])
        
        buildingCodeMissing = false
        carPlateMissing = false
        suitNoMissing = false
        parkingAddrMissing = false
        
        if(buildingCode == "" || carPlate == "" || suitNo == "" || parkingAddr == ""){
            addErrorTitle = "Please fill in all information"
            addErrorDesc = "There are missing fields. We've marked the missing fields in red for you, please enter all information and try again."
            displayAddErrorAlert = true
            
            if(buildingCode == ""){
                buildingCodeMissing = true
            }
            
            if(carPlate == ""){
                carPlateMissing = true
            }
            
            if(suitNo == ""){
                suitNoMissing = true
            }
            
            if(parkingAddr == ""){
                parkingAddrMissing = true
            }
            
        }else {
            
            if(self.buildingCode.count == 5){
                if(self.carPlate.count >= 2 && self.carPlate.count <= 8){
                    
                    
                    if(self.suitNo.count >= 2 && self.suitNo.count <= 5) {
                        self.email = self.profileController.profile.email
                        
                        if(!useLocationIsChecked){
                            getLocation(address: "\(parkingAddr)")
                        }
                        
                        if(useLocationIsChecked){
                            continueUpload()
                            couldFindCoords = true
                        }
                        else{
                            print(#function, "Not using current location. now waiting for location search to come back.")
                        }
                    }
                    
                    else {
                        addErrorTitle = "Hold up!"
                        addErrorDesc = "Your car suit number is not valid. suit numbers are between 2 and 5 characters! \n\nPlease modify the suit number and try again."
                        suitNoMissing = true
                        
                        displayAddErrorAlert = true
                    }
                    
                    
                }
                else {
                    addErrorTitle = "Hold up!"
                    addErrorDesc = "Your car plate number is not valid. Car plate numbers are between 2 and 8 characters! \n\nPlease modify the plate number and try again."
                    carPlateMissing = true
                    
                    displayAddErrorAlert = true
                }
            }
            else {
                addErrorTitle = "Hold up!"
                addErrorDesc = "The building code you entered is not valid. Building codes are exactly 5 characters! \n\nPlease modify the building code and try again."
                buildingCodeMissing = true
                
                displayAddErrorAlert = true
            }
            
            
            
        }
        
        
    }
    
    
    func continueUpload(){
        if(couldFindCoords){
            let newAddedParking = Parking(email: email, buildingCode: buildingCode, hoursSelection: hoursSelection, suitNo: suitNo, carPlateNumber: carPlate, parkingAddr: parkingAddr, date: parkingDateTime, parkingLat: parkingLat, parkingLon: parkingLon)
            
            print(newAddedParking)
            
            let successfulAdd = self.profileController.addParkingToDatabase(email: email, newParking: newAddedParking)
            
            
            if(successfulAdd){
                
                self.buildingCode = ""
                self.hoursSelection = 0
                self.suitNo = ""
                self.parkingAddr = ""
                self.parkingDateTime = Date()
                self.parkingLat = 0
                self.parkingLon = 0
                
                useLocationIsChecked = !useLocationIsChecked
                
                print(#function, "reset lat lon, here they are: \(parkingLat) \(parkingLon)")
                
                self.couldFindCoords = false
                
                addErrorTitle = "Success!"
                addErrorDesc = "Successfully added a new parking to the database. \n\nYou can view this reservation under the 'View Parking' Tab."
                
                displayAddErrorAlert = true
                
            }

        }
        else {
            print(#function, "unable to find coords")
            print(#function, "coords: \(parkingLat) \(parkingLon)")
        }
    }
    
    var body: some View {
        
//        NavigationView {
            VStack{
                VStack {
                    Form {
                        
                        
                        Section(header: Text("Building Code (5 Characters)")) {
                                TextField("Enter Building Code", text: $buildingCode)
                                    .keyboardType(.default)
                                    .foregroundColor(Color.white)
                        }
                        .foregroundColor(buildingCodeMissing == true ? Color.red : Color.white)
                        
                        
                        Section(header: Text("How many hours to you intend to park?")) {
                            Picker("Hours:", selection: $hoursSelection) {
                                ForEach(0..<self.parkingHoursList.count){
                                    Text("\(self.parkingHoursList[$0])")
                                }
                            }
        //                    .pickerStyle(SegmentedPickerStyle())  // PICKER STYLE (Horizontal)
                            //Picker
                            
                        }
                        
                        Section(header: Text("Car Plate Number (2-8 Characters)")) {
                            TextField("Enter Plate Number", text: $carPlate)
                                .keyboardType(.default)
                                .foregroundColor(Color.white)
                                
                        }
                        .foregroundColor(carPlateMissing == true ? Color.red : Color.white)
                        
                        Section(header: Text("Suit Number of Host (2-5 Characters)")) {
                            TextField("Enter Suit Number", text: $suitNo)
                                .keyboardType(.default)
                                .foregroundColor(Color.white)
                                
                        }
                        .foregroundColor(suitNoMissing == true ? Color.red : Color.white)
                        
                        Section(header: Text("Parking Location (Address)")) {
                            Button(action: toggle){
                                HStack{
                                    Image(systemName: useLocationIsChecked ? "checkmark.square": "square")
                                    Text("Use Current Location?")
                                }
                                .foregroundColor(Color.blue)

                            }.alert(isPresented: $displayLocationAlert){
                                Alert(title: Text("Hold up!"), message: Text("It looks like you haven't enabled use of location services! We can't find your location until you allow us to use your location! Please enable and try again."), dismissButton: .default(Text("Okay")))
                            }
                            TextField("Enter Parking Address", text: $parkingAddr)
                                .keyboardType(.default)
                                .disabled(useLocationIsChecked)
                                .foregroundColor(disabledColor)
                                
                        }
                        .foregroundColor(parkingAddrMissing == true ? Color.red : Color.white)
                        
                        Section(header: Text("Parking Date & Time (Skip for current time & date)")) {
                            DatePicker("Parking Date & Time", selection: $parkingDateTime)
                                
                        }
                        
                        

                        
                    }
                    
                }
                
                    Spacer()
                    VStack{
                        Button(action: {
                            self.addParkingButtonPressed()
                        }, label: {
                            Text("Add Parking")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .frame(width: 300, height: 40)
                                .background(Color.green)
                                .cornerRadius(10.0)
                        })
                        
                        .alert(isPresented: $displayAddErrorAlert){
                            Alert(title: Text(addErrorTitle ?? "There was a problem"), message: Text(addErrorDesc ?? "Unfortunately we were unable to determine the problem right now. Please try again."), dismissButton: .default(Text("Okay")))
                        }
                        
                    }
                    
                    Spacer()
            }
            .ignoresSafeArea(.keyboard)
        

            
//        .navigationBarTitle("Add Parking", displayMode: .automatic)
            
        
//        }
        .onAppear() {
            self.carPlate = self.profileController.profile.carPlateNumber
        }
        
    }
    
}

struct AddParkingView_Previews: PreviewProvider {
    static var previews: some View {
        AddParkingView()
    }
}


extension AddParkingView{
    func getAddress(location : CLLocation){
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
            self.processGeoResponse(withPlacemarks: placemark, error: error)
        })
    }
    
    func processGeoResponse(withPlacemarks placemarks : [CLPlacemark]?, error : Error?){
        if error != nil{
            
        }else{
            
            if let placemarks = placemarks, let placemark = placemarks.first{
                let address = (placemark.thoroughfare! + ", " + placemark.locality! + ", " + placemark.administrativeArea! + ", " + placemark.country!)
//                lblAddress.text = address
                print(#function, "Address Found: \(address)")
                self.parkingAddr = address
                
            }else{
//                lblAddress.text = "Address is not found."
                print(#function, "Address Not Found.")
            }
        }
    }
}

extension AddParkingView{
    
    func getLocation(address : String){
        print(#function, "ADDR: \(address)")
        geocoder.geocodeAddressString(address, completionHandler: { (placemark, error) in
            self.processForGeoCoding(withPlacemarks: placemark, error: error)
        })
    }
    
    func processForGeoCoding(withPlacemarks placemarks : [CLPlacemark]?, error : Error?){
        
        
        if error != nil{
            self.addErrorTitle = "There was an issue."
            self.addErrorDesc = "The Street address you entered did not return any coords. Please try again, or enter a new address."
            self.displayAddErrorAlert = true
        }else{
            var location : CLLocation?
            
            if let placemark = placemarks, placemarks!.count > 0{
                location = placemark.first?.location
            }
            
            if let location = location{
                self.parkingLat = location.coordinate.latitude
                self.parkingLon = location.coordinate.longitude
                self.couldFindCoords = true
                print(#function, "Found coords... \(parkingLat) \(parkingLon)")
                
                self.continueUpload()
            }else{
                self.addErrorTitle = "There was an issue."
                self.addErrorDesc = "The Street address you entered did not return any coords. Please try again, or enter a new address."
                self.displayAddErrorAlert = true
            }
        }
    }
    
}
