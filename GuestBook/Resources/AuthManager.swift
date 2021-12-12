//  AuthManager.swift
//  GuestBook
//
//  Created by Emily Crowl on 12/2/21.

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    //MARK: public
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
         - check if username is available
         - check if email is available
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /*
                 - create account
                 - insert account into database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        //firebase auth could not create account
                        return
                    }
                    //insert into db
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        }
                        else {
                            //failed to insert into db
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                //either username or email dne
                completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email {
            //email login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
        else if let username = username {
            //username login
            print(username)
        }
    }
    /// Attempt to log out Firebase user
    public func logOut(completion: (Bool) -> Void) {
        do {
             try Auth.auth().signOut()
            completion(true)
            return
         }
         catch {
             print(error)
             completion(false)
             return
         }
    }
}

