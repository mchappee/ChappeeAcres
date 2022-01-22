//
//  CritterViewController.h
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/23/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CritterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *CritterImage;
@property (weak, nonatomic) IBOutlet UILabel *CritterName;
@property (weak, nonatomic) IBOutlet UILabel *CritterDesc;
@property (weak, nonatomic) IBOutlet UILabel *Counter;
@property (strong, nonatomic) IBOutlet UIView *CritterView;
@property (weak, nonatomic) IBOutlet UILabel *CritterSwipe;
@property (weak, nonatomic) IBOutlet UIButton *BackButton;
@property (weak, nonatomic) IBOutlet UIButton *CloseButton;
@property (weak, nonatomic) IBOutlet UIButton *NextButton;

@property NSArray *critters;
- (IBAction)BackButton:(id)sender;
- (IBAction)CloseButton:(id)sender;
- (IBAction)NextButton:(id)sender;


@end

NS_ASSUME_NONNULL_END
