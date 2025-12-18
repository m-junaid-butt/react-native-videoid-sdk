//
//  VideoIDSDKBridge.h
//  example
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoIDSDKBridge : NSObject

+ (instancetype)shared;

- (void)startVideoIDWithEndpoint:(NSString *)endpoint
                                                                              bearer:(NSString *)bearer
                                                                  rAuthority:(NSString *)rAuthority
                                                                  documentID:(NSNumber *)documentID
                                                                        language:(NSString *)language
                                                      viewController:(UIViewController *)viewController
                                                                  completion:(void (^)(NSString * _Nullable videoID,
                                                                                                                               NSString * _Nullable error,
                                                                                                                               NSString * _Nullable canceled))completion;

- (void)startVideoIDWithCustomStyle:(NSString *)endpoint
                                                                                     bearer:(NSString *)bearer
                                                                         rAuthority:(NSString *)rAuthority
                                                                         documentID:(NSNumber *)documentID
                                                                               language:(NSString *)language
                                                                        styleConfig:(NSDictionary *)styleConfig
                                                             viewController:(UIViewController *)viewController
                                                                         completion:(void (^)(NSString * _Nullable videoID,
                                                                                                                                          NSString * _Nullable error,
                                                                                                                                          NSString * _Nullable canceled))completion;

@end

NS_ASSUME_NONNULL_END
