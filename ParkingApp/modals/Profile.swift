//
//  Profile.swift
//  ParkingApp
//
//  Created by Shailesh Yadav, 101332535 on 24/01/21.
//

import Foundation
import Foundation
import FirebaseFirestoreSwift

struct Profile : Codable, Identifiable, Hashable{
    @DocumentID var id : String? = UUID().uuidString
    var email : String = ""
    var name : String = ""
    var contactNumber: String = ""
    var carPlateNumber: String = ""
    
    init() {}
    
    init(email: String, name: String, contactNumber: String, carPlateNumber: String) {
        self.email = email
        self.name = name
        self.contactNumber = contactNumber
        self.carPlateNumber = carPlateNumber
    }
}

extension Profile{
    init?(dictionary: [String : Any]) {
        
        guard let email = dictionary["email"] as? String else{
            return nil
        }
        
        guard let name = dictionary["name"] as? String else {
            return nil
        }
        
        guard let contactNumber = dictionary["contactNumber"] as? String else{
            return nil
        }
        
        guard let carPlateNumber = dictionary["carPlateNumber"] as? String else {
            return nil
        }
        
        self.init(email: email, name: name, contactNumber: contactNumber, carPlateNumber: carPlateNumber)
    }
}
