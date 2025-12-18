// VideoIDModule.m
#import "VideoIDModule.h"
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/RCTConvert.h>
#import <UIKit/UIKit.h>
#import "VideoIDSDKBridge.h"

@implementation VideoIDModule

RCT_EXPORT_MODULE(VideoIDSdk);

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

RCT_EXPORT_METHOD(startWithCustomStyle:(NSDictionary *)params
                  styleConfig:(NSDictionary *)styleConfig
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    
    // Extract parameters
    NSString *endpoint = [RCTConvert NSString:params[@"endpoint"]];
    NSString *bearer = [RCTConvert NSString:params[@"bearer"]];
    NSString *rAuthority = [RCTConvert NSString:params[@"rAuthority"]] ?: @"";
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
    
    // Use VideoIDSDKBridge to handle VideoID SDK initialization
    [[VideoIDSDKBridge shared] startVideoIDWithEndpoint:endpoint
                                                 bearer:bearer
                                             rAuthority:rAuthority
                                             documentID:documentID
                                               language:language
                                         viewController:rootVC
                                             completion:^(NSString *videoID, NSString *error, NSString *canceled) {
        if (error) {
            reject(@"VIDEO_ID_ERROR", error, nil);
        } else if (canceled) {
            reject(@"VIDEO_ID_CANCELED", @"User canceled", nil);
        } else if (videoID) {
            resolve(@{@"videoId": videoID, @"status": @"completed"});
        } else {
            resolve(@{@"status": @"presented"});
        }
    }];
  });
}

RCT_EXPORT_METHOD(start:(NSDictionary *)params
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    
    // Extract parameters
    NSString *endpoint = [RCTConvert NSString:params[@"endpoint"]];
    NSString *bearer = [RCTConvert NSString:params[@"bearer"]];
    NSString *rAuthority = [RCTConvert NSString:params[@"rAuthority"]] ?: @"";
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
    
    // Use VideoIDSDKBridge to handle VideoID SDK initialization
    [[VideoIDSDKBridge shared] startVideoIDWithEndpoint:endpoint
                                                 bearer:bearer
                                             rAuthority:rAuthority
                                             documentID:documentID
                                               language:language
                                         viewController:rootVC
                                             completion:^(NSString *videoID, NSString *error, NSString *canceled) {
        if (error) {
            reject(@"VIDEO_ID_ERROR", error, nil);
        } else if (canceled) {
            reject(@"VIDEO_ID_CANCELED", @"User canceled", nil);
        } else if (videoID) {
            resolve(@{@"videoId": videoID, @"status": @"completed"});
        } else {
            resolve(@{@"status": @"presented"});
        }
    }];
  });
}

@end