//
//  landmarkDataService.swift
//  FinalProject
//
//  Created by Yang Gao on 10/18/17.
//  Copyright © 2017 udacity. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData
import GoogleMaps
import GooglePlaces

class LandmarkDataService {
    static let sharedInstance : LandmarkDataService = LandmarkDataService()

    var ref: DatabaseReference!

    var persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    func loadData() {
        ref = Database.database().reference()
        ref.observe(DataEventType.value, with: { (snapshot) in
            let landmarks = snapshot.childSnapshot(forPath: "landmarks")
            let landmarksArray = landmarks.children.allObjects as? [DataSnapshot] ?? []
            for i in 0..<landmarksArray.count {
                let landmark = landmarksArray[i]
                let name = (landmark.value as! NSDictionary)["name"] as! String
                let wikiPage = (landmark.value as! NSDictionary)["wikiPage"] as! String
                let lat = (landmark.value as! NSDictionary)["lat"] as! Double
                let lon = (landmark.value as! NSDictionary)["lon"] as! Double
                let description = (landmark.value as! NSDictionary)["description"] as! String
                let managedContext = self.persistentContainer?.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Landmark", in: managedContext!)!
                let landmarkObject = NSManagedObject(entity:entity, insertInto:managedContext)
                landmarkObject.setValue(name, forKeyPath:"name")
                landmarkObject.setValue(wikiPage, forKeyPath:"wikiPage")
                landmarkObject.setValue(lat, forKeyPath:"lat")
                landmarkObject.setValue(lon, forKeyPath:"lon")
                landmarkObject.setValue(description, forKeyPath:"desc")
                do {
                    try managedContext?.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        })
    }
}
