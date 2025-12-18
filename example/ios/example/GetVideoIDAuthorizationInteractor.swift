//
//  GetVideoIDAuthorizationInteractor.swift
//  example
//

import Foundation
import UIKit

class AuthorizationRequest: Codable {
    var tenantId: String?
    var process: String?
    var rauthorityId: String?
    var externalReference: String?
    var phone: String?
    
    init(tenantId: String?, process: String?, rauthorityId: String?, externalReference: String?, phone: String?) {
        self.tenantId = tenantId
        self.process = process
        self.rauthorityId = rauthorityId
        self.externalReference = externalReference
        self.phone = phone
    }
}

class AuthorizationResponse: Decodable {
    var id: String?
    var authorization: String?
    
    init() {
        self.id = nil
        self.authorization = nil
    }
    
    init(authorization: String) {
        self.id = nil
        self.authorization = authorization
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case authorization
    }
}

class GetVideoIDAuthorizationInteractor {
    
    func getAuthorizationFor(endpoint: String, bearer: String, rAuthority: String, onResult: @escaping (AuthorizationResponse?) -> Void, onError: @escaping (Error) -> Void) {
        
        let url = URL(string: "\(endpoint)/videoid.request")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        
        let authRequest = AuthorizationRequest(
            tenantId: "",
            process: "Unattended",
            rauthorityId: rAuthority,
            externalReference: nil,
            phone: nil
        )
        
        do {
            let jsonData = try JSONEncoder().encode(authRequest)
            request.httpBody = jsonData
        } catch {
            onError(error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                onError(error)
                return
            }
            
            guard let data = data else {
                onError(NSError(domain: "GetVideoIDAuthorizationInteractor", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
                return
            }
            
            do {
                let authResponse = try JSONDecoder().decode(AuthorizationResponse.self, from: data)
                onResult(authResponse)
            } catch {
                onError(error)
            }
        }
        
        task.resume()
    }
}
