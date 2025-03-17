//
//  KeychainService.swift
//  LoudAIViewModel
//
//  Created by Er Baghdasaryan on 17.03.25.
//

import Foundation
import Security

public protocol IKeychainService: AnyObject {
    var accessToken: String? { get set }
    var refreshToken: String? { get  set }
    func removeAllKeyValues()
}

final public class KeychainService: IKeychainService {

    private let uniqueServiceName = "SPEAK_IT_LAB"
    private let refreshTokenKey = "REFRESH_TOKEN_KEY"
    private let accessTokenKey = "ACCESS_TOKEN_KEY"
    private let keychainService: Keychain

    public init() {
        keychainService = Keychain(service: uniqueServiceName)
    }

    public var accessToken: String? {
        get {
            return keychainService.loadData(for: accessTokenKey)
        }
        set {
            update(key: accessTokenKey, value: newValue)
        }
    }

    public var refreshToken: String? {
        get {
            return keychainService.loadData(for: refreshTokenKey)
        }
        set {
            update(key: refreshTokenKey, value: newValue)
        }
    }

    public func removeAllKeyValues() {
        keychainService.removeValue(for: refreshTokenKey)
        keychainService.removeValue(for: accessTokenKey)
    }

    private func update(key: String, value: String?) {
        keychainService.removeValue(for: key)
        if let value = value {
            keychainService.saveData(value, for: key)
        }
    }
}

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrkeyValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

final public class Keychain: NSObject {
    private let service: String

    init(service: String) {
        self.service = service
    }

    func updateValue(for key: String, data: String) {
        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {

            let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                              service, key],
                                                                         forKeys: [kSecClassValue,
                                                                                   kSecAttrServiceValue,
                                                                                   kSecAttrkeyValue])

            let status = SecItemUpdate(keychainQuery as CFDictionary,
                                       [kSecValueDataValue: dataFromString] as CFDictionary)

            if status != errSecSuccess {
                print("\(key) update failed: \(status)")
            }
        }
    }

    func removeValue(for key: String) {

        // Instantiate a new default keychain query
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                          service,
                                                          key, kCFBooleanTrue ?? true],
                                                forKeys: [kSecClassValue,
                                                          kSecAttrServiceValue,
                                                          kSecAttrkeyValue,
                                                          kSecReturnDataValue])

        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        if status != errSecSuccess {
            print("\(key) remove failed: \(status)")
        }

    }

    func saveData(_ data: String, for key: String) {
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {

            // Instantiate a new default keychain query
            let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                              service, key, dataFromString],
                                                    forKeys: [kSecClassValue,
                                                              kSecAttrServiceValue,
                                                              kSecAttrkeyValue,
                                                              kSecValueDataValue])

            // Add the new keychain item
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)

            if status != errSecSuccess {
                print("\(key) save failed: \(status)")
            }
        }
    }

    func loadData(for key: String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery = NSMutableDictionary(objects: [kSecClassGenericPasswordValue,
                                                          service, key,
                                                          kCFBooleanTrue ?? true,
                                                          kSecMatchLimitOneValue],
                                                forKeys: [kSecClassValue,
                                                          kSecAttrServiceValue,
                                                          kSecAttrkeyValue,
                                                          kSecReturnDataValue,
                                                          kSecMatchLimitValue])

        var dataTypeRef: AnyObject?

        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?

        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }

        return contentsOfKeychain
    }
}
