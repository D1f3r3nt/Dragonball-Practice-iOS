import Foundation

struct LocalDataModel {
    
    private static let userDefaults = UserDefaults.standard
    private static let TOKEN_KEY: String = "token_bearer"
    
    static func getToken() -> String? {
        userDefaults.string(forKey: TOKEN_KEY)
    }
    
    static func save(token: String) {
        userDefaults.set(token, forKey: TOKEN_KEY)
    }
    
    static func deleteToken() {
        userDefaults.removeObject(forKey: TOKEN_KEY)
    }
}
