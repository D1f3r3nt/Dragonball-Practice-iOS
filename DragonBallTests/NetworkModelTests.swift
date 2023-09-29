import XCTest
@testable import DragonBall

final class NetworkModelTests: XCTestCase {
    
    private var sut: NetworkModel!
    
    // Una vez
    override class func setUp() {
        super.setUp()
    }
    
    // Una vez por metodo
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockUrlProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = NetworkModel(session: session)
    }
    
    // Una vez al final
    override class func tearDown() {
        super.tearDown()
    }

    // Una vez al final de cada metodo
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Login
    func test_login() {
        let expectedToken = "Some Token"
        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        
        MockUrlProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            
            let loginData = loginString.data(using: .utf8)!
            let base64LogingString = loginData.base64EncodedString()
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Basic \(base64LogingString)"
            )
            
            let data = try XCTUnwrap(expectedToken.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            
            return (response, data)
        }
        
        // Para codigos async
        let expect = expectation(description: "Login succes")
        
        sut.login(
            user: someUser,
            password: somePassword
        ) { result in
            guard case let .success(token) = result else {
                XCTFail("X - Expected success but recived \(result)")
                return
            }
            
            XCTAssertEqual(token, expectedToken)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1)
    }
    
    // MARK: - Get Heroes
    func test_get_heroes() {
        let heroes: [Hero] = [Hero(
            id: "A",
            name: "Marc",
            description: "DESC",
            photo: URL(string: "ZZZ")!,
            favorite: false
        )]
        
        
        MockUrlProtocol.requestHandler = { request in
            
            XCTAssertEqual(request.httpMethod, "POST")
            
            let data = try XCTUnwrap(JSONEncoder().encode(heroes))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            
            return (response, data)
        }
        
        let expect = expectation(description: "GetHeroes succes")
        
        sut.getHeroes() { result in
            guard case let .success(response) = result else {
                XCTFail("X - Expected success but recived \(result)")
                return
            }
            
            XCTAssertEqual(response, heroes)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1)
        
    }
    
    // MARK: - Get Transformations
    func test_get_transformations() {
        let transformations: [Transformation] = [Transformation(
            id: "B",
            name: "SUPER",
            description: "DESC",
            photo: URL(string: "YYY")!
        )]
        let hero = Hero(
            id: "A",
            name: "Marc",
            description: "DESC",
            photo: URL(string: "ZZZ")!,
            favorite: false
        )
        
        
        MockUrlProtocol.requestHandler = { request in
            
            XCTAssertEqual(request.httpMethod, "POST")
            
            let data = try XCTUnwrap(JSONEncoder().encode(transformations))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            
            return (response, data)
        }
        
        let expect = expectation(description: "GetTransformations succes")
        
        sut.getTransformations(for: hero) { result in
            guard case let .success(response) = result else {
                XCTFail("X - Expected success but recived \(result)")
                return
            }
            
            XCTAssertEqual(response, transformations)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1)
    }
}

// OHHTTPStubs
final class MockUrlProtocol: URLProtocol {
    static var error: NetworkModel.NetworkError?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockUrlProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockUrlProtocol.requestHandler else {
            assertionFailure("X - Recived unexpected request with no handler")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
