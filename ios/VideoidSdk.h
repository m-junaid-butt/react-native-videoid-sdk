// ios/VideoidSdk.h

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTUtils.h>

// Swift umbrella header from the VideoIDSDK xcframework
#import <VideoIDSDK/VideoIDSDK-Swift.h>

@interface VideoidSdk : NSObject <NativeVideoidSdkSpec, VideoIDDelegate>
@end
