//
//  ImageManager.swift
//  roome
//
//  Created by minsong kim on 6/20/24.
//

import UIKit

class ImageManager {
    enum Identifiers: String {
        case profile = "profile"
    }
    
    class func saveImageToDirectory(identifier: Identifiers, image: UIImage?) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask).first!
        let imageName = identifier.rawValue
        let fileURL = documentsDirectory.appendingPathComponent(imageName, conformingTo: .png)
        
        print(fileURL)
        
        do {
            if let imageData = image?.pngData() {
                try imageData.write(to: fileURL)
                print("Image saved at: \(fileURL)")
            }
            
        } catch {
            print("Failed to save images: \(error)")
        }
    }
    
    class func loadImageFromDirectory(identifier: Identifiers) -> UIImage? {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent(identifier.rawValue, conformingTo: .png)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        return UIImage(contentsOfFile: fileURL.path)
    }
}
