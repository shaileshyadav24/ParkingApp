//
//  ProfileController.swift
//  ParkingApp
//
//  Created by Shailesh Yadav, 101332535 on 24/01/21.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class ProfileController: ObservableObject {
    @Published var profile = Profile()
    private let COLLECTION_PARKING : String = "Parking"
    let store : Firestore
    
    
    init(database: Firestore){
        self.store = database
    }
    
    // To add new profile in DB
    func insertProfile(newProfile: Profile){
        do{
            _ = try self.store.collection(COLLECTION_PARKING).addDocument(from: newProfile)
        } catch let error as NSError{
            print(#function, "Error inserting profile", error)
        }
    }
    
    // To update profile in DB using ID
    func updateProfile(id: String, profile: Profile){
        print("ID is for")
        self.store.collection(COLLECTION_PARKING)
            .document(id)
            .updateData(
                ["email" : profile.email,
                 "carPlateNumber" : profile.carPlateNumber,
                 "contactNumber" : profile.contactNumber,
                 "name" : profile.name]
            ){ error in
                if let error = error{
                    print(#function, error)
                }else{
                    print(#function, "Document updated successfully")
                }
            }
    }
    
    // To fetch record using email
    func fetchRecordUsingEmail(email: String) {
        self.store.collection(COLLECTION_PARKING).whereField("email", isEqualTo: email)
            .getDocuments() {
                (querySnapshot, err) in
                
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshot results", err)
                    return
                }
                
                snapshot.documentChanges.forEach{ (doc) in
                    self.profile = Profile()
                    
                    do{
                        self.profile = try doc.document.data(as: Profile.self)!
                        print("Profile", self.profile)
                        
                    }catch let error as NSError{
                        print("#function", error)
                    }
                }
            }
        
    }
    
    
    // To validate if email exist
    func searchIfEmailExit(email: String, completionHndler: @escaping(_ isRecordAvailable: Bool) -> Void) {
        var isRecordAvailable = false
        self.store.collection(COLLECTION_PARKING).whereField("email", isEqualTo: email)
            .getDocuments() {
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    isRecordAvailable = true
                } else {
                    isRecordAvailable = querySnapshot!.documents.count > 0
                }
                completionHndler(isRecordAvailable)
            }
    }
    
    // To validate if email exist for logged in user
    func searchIfEmailExitForExistingUser(email: String, id: String, completionHndler: @escaping(_ isRecordAvailable: Bool) -> Void) {
        var isRecordAvailable = false
        self.store.collection(COLLECTION_PARKING).whereField("email", isEqualTo: email)
            .getDocuments() {
                (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    isRecordAvailable = true
                } else {
                    if let snapshot = querySnapshot {
                        var matchingRecords = 0
                        snapshot.documents.forEach{ (doc) in
                            do{
                                let profileData = try doc.data(as: Profile.self)!
                                
                                if(profileData.id != id) {
                                    matchingRecords = matchingRecords + 1
                                    print("Matching record", matchingRecords)
                                }
                            } catch let error as NSError{
                                print("#function", error)
                                // Added to avoid proceeding to save
                                matchingRecords = matchingRecords + 1
                            }
                        }
                        isRecordAvailable = matchingRecords > 0
                    }
                }
                completionHndler(isRecordAvailable)
            }
    }
    
    
    // To delete profile using ID
    func deleteProfile(id: String){
        self.store.collection(COLLECTION_PARKING)
            .document(id)
            .delete{error in
                if let error = error{
                    print(#function, error)
                }else{
                    print(#function, "Document successfully deleted")
                }
            }
    }
    
    // To reset profile variable after logout
    func resetProfile() {
        self.profile = Profile()
    }
    
}
