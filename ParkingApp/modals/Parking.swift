//
//  Parking.swift
//  ParkingApp
//
//  Created by Nathan Kennedy on 2021-01-24.
//

import Foundation
import FirebaseFirestoreSwift

struct Parking : Codable, Identifiable, Hashable{
    @DocumentID var id : String? = UUID().uuidString
    var email : String = ""
    var buildingCode : String = ""
    var hoursSelection : Int = 0
    var suitNo: String = ""
    var carPlateNumber: String = ""
    var parkingAddr: String = ""
    var date: Date = Date()
    var parkingLat:Double = 0
    var parkingLon:Double = 0
    
    init() {}
    
    init(email: String, buildingCode: String, hoursSelection: Int, suitNo: String, carPlateNumber: String, parkingAddr: String, date: Date, parkingLat: Double, parkingLon: Double) {
        self.email = email
        self.buildingCode = buildingCode
        self.hoursSelection = hoursSelection
        self.suitNo = suitNo
        self.carPlateNumber = carPlateNumber
        self.parkingAddr = parkingAddr
        self.date = date
        self.parkingLat = parkingLat
        self.parkingLon = parkingLon
    }
}

extension Parking{
    init?(dictionary: [String : Any]) {
        
        guard let email = dictionary["email"] as? String else{
            return nil
        }
        
        guard let buildingCode = dictionary["buildingCode"] as? String else {
            return nil
        }
        
        guard let hoursSelection = dictionary["hoursSelection"] as? Int else {
            return nil
        }
        
        guard let suitNo = dictionary["suitNo"] as? String else{
            return nil
        }
        
        guard let carPlateNumber = dictionary["carPlateNumber"] as? String else {
            return nil
        }
        
        guard let parkingAddr = dictionary["parkingAddr"] as? String else {
            return nil
        }
        
        guard let date = dictionary["date"] as? Date else {
            return nil
        }
        
        guard let parkingLat = dictionary["parkingLat"] as? Double else {
            return nil
        }
        
        guard let parkingLon = dictionary["parkingLon"] as? Double else {
            return nil
        }
        
        self.init(email: email, buildingCode: buildingCode, hoursSelection: hoursSelection, suitNo: suitNo, carPlateNumber: carPlateNumber, parkingAddr: parkingAddr, date: date, parkingLat: parkingLat, parkingLon: parkingLon)
    }
}
