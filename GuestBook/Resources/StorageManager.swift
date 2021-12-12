//  StorageManager.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/2/21.

import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    //create own error
    public enum GBStorageManagerError: Error {
        case failedToDownload
    }
    
    //MARK: public
    
    public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, Error>) -> Void) {
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping (Result<URL, GBStorageManagerError>) -> Void) {
        bucket.child(reference).downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(.failedToDownload))
                return
            }
            
            completion(.success(url))
        })
    }
}
