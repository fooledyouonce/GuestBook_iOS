//  DatabaseManager.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/2/21.

import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    //MARK: public
    
    /// Check to see if username and email are available
    /// - Parameters:
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    /// Inserts new user data into database
    /// - Parameters:
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - completion: Async callback for result if database entry succeeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, _ in
            if error == nil {
                //succeeded
                completion(true)
                return
            }
            else {
                //failed
                completion(false)
                return
            }
        }
    }
}
