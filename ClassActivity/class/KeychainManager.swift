import Foundation
import Security

class KeychainManager {
    
    static let shared = KeychainManager()
    
    private let service = Bundle.main.bundleIdentifier ?? "com.example.app"
    
    func set(value: String, forKey key: String) {
        if let data = value.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                print("Failed to save data to keychain. Status code \(status)")
                return
            }
            print("Data saved to keychain")
        }
    }
    
    func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data else {
            print("Failed to retrieve data from keychain. Status code \(status)")
            return nil
        }
        
        return String(data: retrievedData, encoding: .utf8)
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            print("Failed to delete data from keychain. Status code \(status)")
            return
        }
        print("Data deleted from keychain")
    }
    
    func printKeychainItems() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitAll,
            kSecReturnAttributes as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            print("Failed to retrieve items from keychain. Status code \(status)")
            return
        }
        
        if let items = result as? [[String: Any]] {
            print("Keychain Items:")
            for item in items {
                if let account = item[kSecAttrAccount as String] as? String,
                   let service = item[kSecAttrService as String] as? String {
                    print("Service: \(service), Account: \(account)")
                }
            }
        } else {
            print("No items found in keychain")
        }
    }
}
