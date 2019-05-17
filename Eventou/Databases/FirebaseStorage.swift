//
//  FirebaseStorage.swift
//  Jardim Apura
//
//  Created by Bruno Rocca on 09/10/2018.
//  Copyright © 2018 Bruno Rocca. All rights reserved.
//

import UIKit
import FirebaseStorage

class FirebaseStorage: UIViewController{
    var imageReference: StorageReference{
        return Storage.storage().reference().child("images")
    }
    
    // Faz upload da foto no Firebase Storage
    func uploadPhoto(path: String, photo: UIImage){
        guard let photoData = photo.jpegData(compressionQuality: 0.1) else {return}
        let uploadPhotoRef = imageReference.child(path)
        let uploadTask = uploadPhotoRef.putData(photoData, metadata: nil) { (metadata, error) in
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
        }
        uploadTask.observe(.progress){ (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        uploadTask.resume()
    }
    
    // Baixa a foto no Firebase Storage pelo seu path
    func downloadPhoto(path: String, completion: @escaping (_ image : UIImage)  -> Void){
        let downloadImageRef = imageReference.child(path)
        var image: UIImage? = nil
        let downloadTask = downloadImageRef.getData(maxSize: 1024 * 1024 * 1024){ (data, error) in
            if let data = data{
                image = UIImage(data: data)
                completion(image!)
            }
            print(error ?? "NO ERROR")
        }
        
        downloadTask.observe(.progress){ (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
    }
}
