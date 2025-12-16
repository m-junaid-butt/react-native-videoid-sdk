// VideoIDSDKBridge.swift
import Foundation
import VideoIDSDK

@objc(VideoIDSDKBridge)
public class VideoIDSDKBridge: NSObject {
    
    @objc public static let shared = VideoIDSDKBridge()
    
    private var getVideoIDAuthorizationInteractor: GetVideoIDAuthorizationInteractor?
    
    override init() {
        super.init()
        getVideoIDAuthorizationInteractor = GetVideoIDAuthorizationInteractor()
    }
    
    @objc public func startVideoID(
        endpoint: String,
        bearer: String,
        rAuthority: String,
        documentID: NSNumber,
        language: String,
        viewController: UIViewController,
        completion: @escaping (String?, String?, String?) -> Void
    ) {
        
        getVideoIDAuthorizationInteractor?.getAuthorizationFor(
            endpoint: endpoint,
            bearer: bearer,
            rAuthority: rAuthority,
            onResult: { auth in
                
                guard let auth = auth else {
                    completion(nil, "AUTH_ERROR", "Failed to get authorization")
                    return
                }
                
                let environment = VideoIDSDK.SDKEnvironment(url: endpoint, authorization: auth)
                
                DispatchQueue.main.async {
                    let videoIDVC = VideoIDSDK.VideoIDSDKViewController(
                        environment: environment,
                        docType: documentID,
                        language: language
                    )
                    
                    videoIDVC.modalPresentationStyle = .fullScreen
                    videoIDVC.delegate = self
                    
                    viewController.present(videoIDVC, animated: true) {
                        completion("started", nil, nil)
                    }
                }
                
            }, onError: { error in
                completion(nil, "AUTHORIZATION_ERROR", error?.localizedDescription)
            }
        )
    }
}

extension VideoIDSDKBridge: VideoIDSDK.VideoIDDelegate {
    public func onComplete(videoID: String) {
        // Handle completion - you might want to send events to React Native
        print("VideoID completed: \(videoID)")
    }
    
    public func onError(code: String, message: String?) {
        // Handle error
        print("VideoID error: \(code) - \(message ?? "")")
    }
}