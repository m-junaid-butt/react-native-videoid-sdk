// ios/VideoidSdk.mm

#import "VideoidSdk.h"
#import <React/RCTLog.h>
#import <UIKit/UIKit.h>

#import <VideoIDSDK/VideoIDSDK-Swift.h>


@implementation VideoidSdk {
  RCTPromiseResolveBlock _pendingResolve;
  RCTPromiseRejectBlock  _pendingReject;
}

+ (NSString *)moduleName
{
  return @"VideoidSdk";
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeVideoidSdkSpecJSI>(params);
}

#pragma mark - Public API (from JS)

/// startVideoID(config: { endpoint, authorization, language?, documentID })
- (void)startVideoID:(NSDictionary *)config
             resolve:(RCTPromiseResolveBlock)resolve
              reject:(RCTPromiseRejectBlock)reject
{
  _pendingResolve = resolve;
  _pendingReject  = reject;

  NSString *endpoint      = config[@"endpoint"];
  NSString *authorization = config[@"authorization"];   // <-- IMPORTANT
  NSString *language      = config[@"language"] ?: @"en";
  NSNumber *documentID    = config[@"documentID"];      // NSNumber expected by SDK

  if (!endpoint || !authorization || !documentID) {
    if (_pendingReject) {
      _pendingReject(
        @"INVALID_CONFIG",
        @"endpoint, authorization and documentID are required",
        nil
      );
    }
    [self clearPending];
    return;
  }

  UIViewController *rootVC = RCTPresentedViewController();
  if (!rootVC) {
    if (_pendingReject) {
      _pendingReject(
        @"NO_ROOT_VC",
        @"Unable to find root view controller",
        nil
      );
    }
    [self clearPending];
    return;
  }

  // Build SDK environment (from VideoIDSDK-Swift.h)
  // - (instancetype)initWithUrl:(NSString *)url authorization:(NSString *)authorization
  SDKEnvironment *env =
    [[SDKEnvironment alloc] initWithUrl:endpoint authorization:authorization];

    dispatch_async(dispatch_get_main_queue(), ^{
  VideoIDSDKViewController *vc =
    [[VideoIDSDKViewController alloc] initWithEnvironment:env
                                                  docType:documentID
                                                 language:language
                                                 docTypes:nil
                                         biometricConsent:OptionalBoolNone];

  vc.modalPresentationStyle = UIModalPresentationFullScreen;
  vc.delegate = self;

  [rootVC presentViewController:vc animated:YES completion:nil];
});


}

#pragma mark - VideoIDDelegate

- (void)onCompleteWithVideoID:(NSString *)videoID
{
  if (_pendingResolve) {
    _pendingResolve(@{
      @"status": @"success",
      @"videoId": videoID ?: @""
    });
  }
  [self clearPending];
}

- (void)onErrorWithCode:(NSString *)code
                message:(NSString * _Nullable)message
{
  if (_pendingResolve) {
    _pendingResolve(@{
      @"status": @"error",
      @"code": code ?: @"ERROR",
      @"message": message ?: @"Unknown error"
    });
  }
  [self clearPending];
}

#pragma mark - Helpers

- (void)clearPending
{
  _pendingResolve = nil;
  _pendingReject  = nil;
}

@end

