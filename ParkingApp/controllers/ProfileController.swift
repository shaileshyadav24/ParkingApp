//
//  ProfileController.swift
//  ParkingApp
//
//  Created by Sargam on 24/01/21.
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
    
    
    func insertProfile(newProfile: Profile){
        do{
            _ = try self.store.collection(COLLECTION_PARKING).addDocument(from: newProfile)
        } catch let error as NSError{
            print(#function, "Error inserting profile", error)
        }
    }
    
    func updateProfile(index: Int, task: Profile){
        //        self.store.collection(COLLECTION_TASK)
        //            .document(self.taskList[index].id!)
        //            .updateData(["completion" : task.completion]){ error in
        //                if let error = error{
        //                    print(#function, error)
        //                }else{
        //                    print(#function, "Document updated successfully")
        //                }
        //            }
    }
    
    
    func fetchRecordUsingEmail(email: String) {
        self.store.collection(COLLECTION_PARKING).whereField("email", isEqualTo: email)
            .addSnapshotListener({ [self] (querySnapshot, error) in
                
                guard let snapshot = querySnapshot else{
                    print(#function, "Error fetching snapshot results", error)
                    return
                }
                
                snapshot.documentChanges.forEach{ (doc) in
                    var profile = Profile()
                    
                    do{
                        profile = try doc.document.data(as: Profile.self)!
                        
                        if doc.type == .added{
                            self.profile = profile
                        }
                        
                        if doc.type == .modified{
//                                                        let docID = doc.document.documentID
//
//                                                        if (matchedTaskIndex != nil){
//                                                            self.taskList[matchedTaskIndex!] = task
//                                                        }
                        }
                        
                        if doc.type == .removed{
                            //                            let docID = doc.document.documentID
                            //
                            //                            let matchedTaskIndex = self.taskList.firstIndex(where: {
                            //                                ($0.id?.elementsEqual(docID))!
                            //                            })
                            //
                            //                            if (matchedTaskIndex != nil){
                            //                                self.taskList.remove(at: matchedTaskIndex!)
                            //                            }
                        }
                        
                    }catch let error as NSError{
                        print(#function, error)
                    }
                }
                
            })
    }
    
    
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
    
    
    //    func deleteProfile(index: Int){
    //        self.store.collection(COLLECTION_PARKING)
    //            .document(self.profileList[index].id!)
    //            .delete{error in
    //                if let error = error{
    //                    print(#function, error)
    //                }else{
    //                    print(#function, "Document successfully deleted")
    //                }
    //            }
    //    }
    
    
}
