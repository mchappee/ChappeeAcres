//
//  PicController.h
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *Pic;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *working;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *Next;
@property (strong, nonatomic) IBOutlet UIView *PicView;
@property (weak, nonatomic) IBOutlet UIImageView *BigView;
@property (weak, nonatomic) IBOutlet UIButton *CloseButton;
@property NSTimer *statustimer;

- (IBAction)NextDown:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Back;
- (IBAction)BackDown:(id)sender;
- (IBAction)CloseDown:(id)sender;

@property NSArray *filearray;
@property NSInteger filenum;
@end

NS_ASSUME_NONNULL_END
