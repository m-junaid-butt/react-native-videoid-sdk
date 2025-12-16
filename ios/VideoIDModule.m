// VideoIDModule.m - UPDATED
#import "VideoIDModule.h"
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <UIKit/UIKit.h>

// Import the Swift bridge header (auto-generated)
#import "react-native-videoid-sdk-Swift.h"

@implementation VideoIDModule

RCT_EXPORT_MODULE(VideoIDSdk);

RCT_EXPORT_METHOD(start:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    
    // Extract parameters
    NSString *endpoint = [RCTConvert NSString:params[@"endpoint"]];
    NSString *bearer = [RCTConvert NSString:params[@"bearer"]];
    NSString *rAuthority = [RCTConvert NSString:params[@"rAuthority"]];
    NSNumber *documentID = [RCTConvert NSNumber:params[@"documentID"]];
    NSString *language = [RCTConvert NSString:params[@"language"]];
    
    // Validate
    if (!endpoint || !bearer || !documentID || !language) {
      reject(@"INVALID_PARAMS", @"Missing required parameters", nil);
      return;
    }
    
    // Get the view controller
    UIViewController *rootVC = RCTPresentedViewController();
    if (!rootVC) {
      rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    
    if (!rootVC) {
      reject(@"NO_VIEW_CONTROLLER", @"No view controller available", nil);
      return;
    }
    
    // Use the Swift bridge
    [VideoIDSDKBridge.shared startVideoIDWithEndpoint:endpoint
                                               bearer:bearer
                                           rAuthority:rAuthority ?: @""
                                           documentID:documentID
                                             language:language
                                       viewController:rootVC
                                           completion:^(NSString * _Nullable result, NSString * _Nullable errorCode, NSString * _Nullable errorMessage) {
      
      if (errorCode) {
        reject(errorCode, errorMessage, nil);
      } else {
        resolve(@{@"status": @"started", @"result": result ?: @""});
      }
    }];
    
  });
}

@end