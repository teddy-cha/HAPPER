//
//  CloudDataManager.swift
//  Happer
//
//  Created by Theodore Cha on 2017. 8. 21..
//  Copyright © 2017년 Theodore Cha. All rights reserved.
//


import UIKit
import CloudKit
import RealmSwift

class CloudDataManager {
    
    static let sharedInstance = CloudDataManager()
    
    struct DocumentsDirectory {
        static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
        
        static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> URL {
        if isCloudEnabled()  {
            return DocumentsDirectory.iCloudDocumentsURL!
        } else {
            return DocumentsDirectory.localDocumentsURL
        }
    }
    
    // Return true if iCloud is enabled
    
    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil {
            return true
        } else {
            Alert.showAlert(title: "Error", message: "Please autorize to iCloud for using data backup")
            return false
        }
    }
    
    // Delete All files at URL
    
    func deleteFilesInDirectory(url: URL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path)
        while let file = enumerator?.nextObject() as? String {
            do {
                if (file != "Archive.zip") {
                    try fileManager.removeItem(at: url!.appendingPathComponent(file))
                    print("Files deleted", file)
                }
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
        
        autoreleasepool {
            // all Realm usage here
        }

    }
    
    
}
