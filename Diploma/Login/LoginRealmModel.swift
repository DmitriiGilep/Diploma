//
//  LoginRealmModel.swift
//  Industrial
//
//  Created by DmitriiG on 17.12.2022.
//

import Foundation
import RealmSwift

final class LoginModel: Object {
    
    @Persisted var login: String = ""
    @Persisted var password: String = ""
    
}

final class Status: Object {
    
    @Persisted var status: Bool = false
    @Persisted var login: String?
    
}

final class LoginRealmModel: CheckerServiceRealmModelProtocol {
    
    static let shared = LoginRealmModel()
    
    lazy var config = Realm.Configuration(encryptionKey: getKey())
    
    var status = Status()
    
    var loginPairArray: [LoginModel] = []
    
    init() {
        migrate()
        refreshData()
    }
    
    
    func addLoginModel(login: String, password: String) {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                let loginPair = LoginModel()
                loginPair.login = login
                loginPair.password = password
                realm.add(loginPair)
                refreshData()
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func refreshData() {
        do {
            let realm = try Realm(configuration: config)
            loginPairArray = Array(realm.objects(LoginModel.self))
            if let statusNew = realm.objects(Status.self).first {
                status = statusNew
            }
        } catch {
            
            print(error.localizedDescription)
            
        }
        
        
    }
    
    func statusLoggedIn(login: String) {
        do {
            let realm = try Realm(configuration: config)
            if let statusUpdate = realm.objects(Status.self).first {
                try realm.write {
                    statusUpdate.status = true
                    statusUpdate.login = login
                }
            } else {
                try realm.write {
                    let statusUpdate = Status()
                    statusUpdate.status = true
                    statusUpdate.login = login
                    realm.add(statusUpdate)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        refreshData()
    }
    
    func statusLoggedOut() {
        do {
            let realm = try Realm(configuration: config)
            if let statusUpdate = realm.objects(Status.self).first {
                try realm.write {
                    statusUpdate.status = false
                    statusUpdate.login = nil
                    refreshData()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //    func deleteData(login: String, password: String) {
    //        let realm = try! Realm()
    //        try! realm.write {
    //            for i in realm.objects(LoginModel.self) {
    //                if i.login == login, i.password == password {
    //                    realm.delete(i)
    //                }
    //            }
    //        }
    //        refreshData()
    //    }
    
    private func migrate() {
        let config = Realm.Configuration(schemaVersion: 4) // update the scheme number after the model has been changed
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    func getKey() -> Data {
        
        let keychainIdentifier = "com.Dmitry.Gilep"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        
        // получили key
        if status == errSecSuccess {
            return dataTypeRef as! Data
        } else {
            // не получили key => generate a random encryption key
            var key = Data(count: 64)
            key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
                let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
                assert(result == 0, "Failed to get random bytes")
            })
            
            // Store the key in the keychain
            query = [
                kSecClass: kSecClassKey,
                kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
                kSecAttrKeySizeInBits: 512 as AnyObject,
                kSecValueData: key as AnyObject
            ]
            status = SecItemAdd(query as CFDictionary, nil)
            assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
            return key
        }
    }
    
    func checkLoginForUnique(login: String) -> Bool {
        var isUnique = true
        for i in loginPairArray {
            if i.login == login {
                isUnique = false
            }
        }
        return isUnique
    }
    
    func addProfileToRealm(login: String, password: String) {
        addLoginModel(login: login, password: password)
    }
    
    func checkAuthorizationWithRealm(login: String, password: String) -> Bool {
        var isPassed = false
        for i in LoginRealmModel.shared.loginPairArray {
            if i.login == login, i.password == password {
                isPassed = true
            }
        }
        return isPassed
    }
    
    func toogleStatusToLogIn(login: String) {
        statusLoggedIn(login: login)
    }
    
}
