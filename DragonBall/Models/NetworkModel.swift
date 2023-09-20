import Foundation

final class NetworkModel {
    
    enum NetworkError: Error {
        case unknown
        case malFormedUrl
        case decodingFailed
        case encodingFailed
        case noData
        case statusCode(code: Int?)
        case noToken
    }
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private var token: String? {
        get {
            if let token = LocalDataModel.getToken() {
                return token
            }
            return nil
        }
        
        // newValue es un valor interno
        set {
            if let token = newValue {
                LocalDataModel.save(token: token)
            }
        }
    }
    
    // MARK: - Login
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        
        var component = baseComponents
        component.path = "/api/auth/login"
        
        guard let url = component.url else {
            completion(.failure(.malFormedUrl))
            return
        }
        
        let loginString: String = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.decodingFailed))
            return
        }
        
        let base64EncodedString = loginData.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64EncodedString)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let urlResponse = (response as? HTTPURLResponse)
            let statusCode = urlResponse?.statusCode
            
            guard statusCode == 200 else {
                completion(.failure(.statusCode(code: statusCode)))
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            self?.token = token
            completion(.success(token))
        }
        
        task.resume()
    }
    
    // MARK: - Get Heroes
    func getHeroes(
        completion: @escaping (Result<[Hero], NetworkError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/heros/all"
        
        guard let url = components.url else {
            completion(.failure(.malFormedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        var bodyUrl = URLComponents()
        bodyUrl.queryItems = [
            URLQueryItem(name: "name", value: "")
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyUrl.query?.data(using: .utf8)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        createTask(for: request, completion: completion, using: [Hero].self)
    }
    
    // MARK: - Get Transformations
    func getTransformations(
        for hero: Hero,
        completion: @escaping (Result<[Transformation], NetworkError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        guard let url = components.url else {
            completion(.failure(.malFormedUrl))
            return
        }
        
        guard let token else {
            completion(.failure(.noToken))
            return
        }
        
        var bodyUrl = URLComponents()
        bodyUrl.queryItems = [
            URLQueryItem(name: "id", value: hero.id)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = bodyUrl.query?.data(using: .utf8)
        
        
        createTask(for: request, completion: completion, using: [Transformation].self)
    }
    
    // MARK: - Global Functions
    func createTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, NetworkError>) -> Void,
        using type: T.Type
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError>
            
            defer {
                completion(result)
            }
            
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            guard let resource = try? JSONDecoder().decode(type, from: data) else {
                result = .failure(.decodingFailed)
                return
            }
            
            result = .success(resource)
        }
        
        task.resume()
    }
}
