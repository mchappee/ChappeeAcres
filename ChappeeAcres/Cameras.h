//
//  Cameras.h
//  ChappeeAcres
//
//  Created by Matthew Chappee on 1/18/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cameras : NSObject

@property NSData *mainicon;
@property NSData *blueicon;
@property NSString *url;
@property NSString *cameraname;
@property UITapGestureRecognizer *singleTap;
@property UIImageView *iv;


@end

NS_ASSUME_NONNULL_END
