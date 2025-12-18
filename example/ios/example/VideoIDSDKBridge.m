//
//  VideoIDSDKBridge.m
//  example
//

#import "VideoIDSDKBridge.h"
#import "example-Swift.h"

#if __has_include(<VideoIDSDK/VideoIDSDK-Swift.h>)
#import <VideoIDSDK/VideoIDSDK-Swift.h>
#else
@import VideoIDSDK;
#endif

@interface VideoIDSDKBridge () <VideoIDDelegate>
@property (nonatomic, copy) void (^currentCompletion)(NSString * _Nullable, NSString * _Nullable, NSString * _Nullable);
@property (nonatomic, strong) UIViewController *currentVideoIDVC;
@end

@implementation VideoIDSDKBridge

+ (instancetype)shared {
    static VideoIDSDKBridge *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startVideoIDWithEndpoint:(NSString *)endpoint
                          bearer:(NSString *)bearer
                      rAuthority:(NSString *)rAuthority
                      documentID:(NSNumber *)documentID
                        language:(NSString *)language
                  viewController:(UIViewController *)viewController
                      completion:(void (^)(NSString * _Nullable, NSString * _Nullable, NSString * _Nullable))completion {
    
    self.currentCompletion = completion;
    
    [[VideoIDSDKSwiftBridge shared] fetchVideoIDAuthorizationWithEndpoint:endpoint
                                                                   bearer:bearer
                                                               rAuthority:rAuthority
                                                               completion:^(NSString * _Nullable authorization, NSError * _Nullable error) {
        if (error || authorization.length == 0) {
            if (completion) {
                completion(nil, error ? error.localizedDescription : @"Failed to fetch authorization", nil);
            }
            return;
        }

        SDKEnvironment *environment = [[SDKEnvironment alloc] initWithUrl:endpoint authorization:authorization];

        VideoIDSDKViewController *videoIDVC = [[VideoIDSDKViewController alloc] initWithEnvironment:environment
                                                                                           docType:documentID
                                                                                         language:language
                                                                                         docTypes:nil
                                                                                                                                                                biometricConsent:OptionalBoolNone];

        videoIDVC.delegate = self;
        videoIDVC.modalPresentationStyle = UIModalPresentationFullScreen;

        self.currentVideoIDVC = videoIDVC;

        dispatch_async(dispatch_get_main_queue(), ^{
            [viewController presentViewController:videoIDVC animated:YES completion:nil];
        });
    }];
}

- (void)startVideoIDWithCustomStyle:(NSString *)endpoint
                             bearer:(NSString *)bearer
                         rAuthority:(NSString *)rAuthority
                         documentID:(NSNumber *)documentID
                           language:(NSString *)language
                        styleConfig:(NSDictionary *)styleConfig
                     viewController:(UIViewController *)viewController
                         completion:(void (^)(NSString * _Nullable, NSString * _Nullable, NSString * _Nullable))completion {
    
    // For now, just call the standard method (custom styling can be added later)
    [self startVideoIDWithEndpoint:endpoint
                            bearer:bearer
                        rAuthority:rAuthority
                        documentID:documentID
                          language:language
                    viewController:viewController
                        completion:completion];
}

#pragma mark - VideoIDDelegate

- (void)onCompleteWithVideoID:(NSString *)videoID {
    if (self.currentCompletion) {
        self.currentCompletion(videoID, nil, nil);
        self.currentCompletion = nil;
    }
}

- (void)onErrorWithCode:(NSString *)code message:(NSString *)message {
    if (self.currentCompletion) {
        NSString *errorString = message ? [NSString stringWithFormat:@"%@: %@", code, message] : (code ?: @"Unknown error");
        self.currentCompletion(nil, errorString, nil);
        self.currentCompletion = nil;
    }
}

- (void)onCancel {
    if (self.currentCompletion) {
        self.currentCompletion(nil, nil, @"true");
        self.currentCompletion = nil;
    }
}

@end
