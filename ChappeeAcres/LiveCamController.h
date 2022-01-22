//
//  LiveCamController.h
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/24/21.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <SafariServices/SafariServices.h>
#import "Cameras.h"

NS_ASSUME_NONNULL_BEGIN

@interface LiveCamController : UIViewController <SFSafariViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *LiveView;
@property SFSafariViewController *svc;
@property (weak, nonatomic) IBOutlet UIImageView *cam5;
@property (weak, nonatomic) IBOutlet UIImageView *cam4;
@property (weak, nonatomic) IBOutlet UIImageView *cam3;
@property (weak, nonatomic) IBOutlet UIImageView *cam2;
@property (weak, nonatomic) IBOutlet UIImageView *cam1;
@property NSMutableArray *cameraarray;
@property Cameras *cameras;

@end

NS_ASSUME_NONNULL_END
