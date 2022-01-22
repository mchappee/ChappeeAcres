//
//  VoDController.h
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/24/21.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoDController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, SFSafariViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *VODView;
@property (weak, nonatomic) IBOutlet UIPickerView *Picker;

- (IBAction)PlayButton:(id)sender;
- (IBAction)CloseButton:(id)sender;

@property NSMutableArray *pickeroptions;
@property NSMutableArray *pickervids;
@property SFSafariViewController *svc;
@property NSString *vod;

@end

NS_ASSUME_NONNULL_END
