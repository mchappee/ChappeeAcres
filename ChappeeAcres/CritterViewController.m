//
//  CritterViewController.m
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/23/21.
//

#import "CritterViewController.h"

@interface CritterViewController ()

@end

@implementation CritterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view loaded");
    
    NSURL *createurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.appmonster.org/ChappeeAcres/getcritters.php"]];    
    NSData *data = [NSData dataWithContentsOfURL:createurl];
    
    self.critters = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //NSLog(self.critters[0][@"name"]);
    

    [self LoadCritter:0];
        
    UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(CritterSwipedRight:)];
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(CritterSwipedLeft:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:swipeleft];

    self.Counter.tag = 0;
    
    [self resizeCritter];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)resizeCritter {
    UIImage *image = self.CritterImage.image;
    
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    //CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;
    
    CGFloat newheight = self.CritterView.frame.size.height / 4;
    CGSize size = CGSizeMake (self.CritterView.frame.size.width, newheight);
    
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.CritterImage.image = newImage;
}

-(void)LoadCritter:(long) critternum {
    //NSString *snum = [NSString stringWithFormat:@"%ld", critternum];

    /*
    NSLog(@"\n\n%@",self.critters.description);
    self.CritterName.text = [self.critters[critternum] objectForKey:@"name"];
    NSLog(self.CritterName.text);
    */
    
    
    NSLog(@"%@\n%@\n%@",self.critters[critternum][@"name"],self.critters[critternum][@"desc"],self.critters[critternum][@"image"]);
    self.CritterName.text = self.critters[critternum][@"name"];
    self.CritterDesc.text = self.critters[critternum][@"desc"];
    
    NSString *path = [[NSString alloc] initWithFormat:@"https://www.appmonster.org/ChappeeAcres/images/%@",self.critters[critternum][@"image"]];
    NSURL *url = [NSURL URLWithString:path];


    NSData *imgdata = [NSData dataWithContentsOfURL:url];
    self.CritterImage.image = [[UIImage alloc] initWithData:imgdata];
    [self resizeCritter];
    
    
}

- (void)CritterSwipedRight:(UISwipeGestureRecognizer*)sender {
    
    if (self.Counter.tag > 0) {
        self.Counter.tag--;
        [self LoadCritter:self.Counter.tag];
    }
     
}

- (void)CritterSwipedLeft:(UISwipeGestureRecognizer*)sender {
    NSLog (@"tag:%ld count:%ld", self.Counter.tag, self.critters.count);
    if (self.Counter.tag != (self.critters.count - 1)) {
        self.Counter.tag++;
        [self LoadCritter:self.Counter.tag];
    }
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    // best call super just in case
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        // will execute during rotation
        
    } completion:^(id  _Nonnull context) {
        
        NSLog(@"ROTATED in critters");
        
        [self RotateCritters];
        
    }];
}

- (void) RotateCritters {
/*
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    NSLog(@"Orientation: %ld", orientation);
    
    if (orientation == 1 || orientation == 2) {
        self.BigLabel.hidden = true;
        self.CritterImage.hidden = false;
        self.CritterDesc.hidden = false;
        self.CritterName.hidden = false;
        self.CritterSwipe.hidden = false;
    } else {
        self.BigLabel.hidden = false;
        self.CritterImage.hidden = true;
        self.CritterDesc.hidden = true;
        self.CritterName.hidden = true;
        self.CritterSwipe.hidden = true;
    }
*/
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)NextButton:(id)sender {
    
    if (self.Counter.tag != (self.critters.count - 1)) {
        self.Counter.tag++;
        [self LoadCritter:self.Counter.tag];
    }
    
    if (self.Counter.tag == (self.critters.count - 1))
      self.NextButton.hidden = true;
    
    if (self.Counter.tag > 0)
        self.BackButton.hidden = false;
    else
        self.BackButton.hidden = true;
    
}

- (IBAction)CloseButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)BackButton:(id)sender {
    
    if (self.Counter.tag > 0) {
        self.Counter.tag--;
        [self LoadCritter:self.Counter.tag];
        self.NextButton.hidden = false;
    }
    
    if (self.Counter.tag > 0)
        self.BackButton.hidden = false;
    else
        self.BackButton.hidden = true;
    
}
@end
