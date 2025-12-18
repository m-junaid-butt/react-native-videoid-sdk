//
//  VideoIDSDKSwiftBridge.swift
//  example
//

import Foundation

@objc public class VideoIDSDKSwiftBridge: NSObject {
    
    @objc public static let shared = VideoIDSDKSwiftBridge()
    
    private override init() {
        super.init()
    }
    
    @objc public func fetchVideoIDAuthorization(
        endpoint: String,
        bearer: String,
        rAuthority: String,
        completion: @escaping (String?, NSError?) -> Void
    ) {
        let interactor = GetVideoIDAuthorizationInteractor()

        interactor.getAuthorizationFor(
            endpoint: endpoint,
            bearer: bearer,
            rAuthority: rAuthority,
            onResult: { authResponse in
                guard let authToken = authResponse?.authorization, !authToken.isEmpty else {
                    let error = NSError(
                        domain: "VideoIDSDKSwiftBridge",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No authorization received"]
                    )
                    completion(nil, error)
                    return
                }
                completion(authToken, nil)
            },
            onError: { error in
                completion(nil, error as NSError)
            }
        )
    }
}
