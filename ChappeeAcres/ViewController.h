//
//  ViewController.h
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/23/21.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *MainMenu;
@property (weak, nonatomic) IBOutlet UIImageView *Tractor;
@property NSString *pushurl;

@end

