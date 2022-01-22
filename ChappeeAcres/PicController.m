//
//  PicController.m
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/24/21.
//

#import "PicController.h"

@interface PicController ()

@end

@implementation PicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollview.minimumZoomScale=0.5;
    self.scrollview.maximumZoomScale=6.0;
    self.scrollview.contentSize=CGSizeMake(1280, 960);
    self.scrollview.delegate=self;
    self.BigView.hidden = true;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
       addObserver:self selector:@selector(orientationChanged:)
       name:UIDeviceOrientationDidChangeNotification
       object:[UIDevice currentDevice]];
    
    NSURL *createurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.appmonster.org/ChappeeAcres/getpics.php"]];
        
    NSData *data = [NSData dataWithContentsOfURL:createurl];
    self.filearray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.filenum = 0;
    
    [self LoadPic:self.filenum];
    [self RotatePic];

    UISwipeGestureRecognizer *swipedown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeDown)];
    swipedown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.BigView addGestureRecognizer:swipedown];
    
    
    
    
}

- (void) SwipeDown {
    NSLog(@"Here");
    [self dismissViewControllerAnimated:true completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.Pic;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    // best call super just in case
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        // will execute during rotation
        
    } completion:^(id  _Nonnull context) {
        
        NSLog(@"ROTATED in Pics");
        
        [self RotatePic];
        
        
        
    }];
}

- (void) RotatePic {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    NSLog(@"Orientation: %ld", orientation);
    
    if (orientation == 1 || orientation == 2) {
        self.BigView.hidden = true;
        self.Back.hidden = false;
        self.Next.hidden = false;
        self.Pic.hidden = false;
    } else {
        self.BigView.hidden = false;
        self.Back.hidden = true;
        self.Next.hidden = true;
        self.Pic.hidden = true;
    }
}

-(void) LoadPic:(long) picnum {
    self.statustimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(HideWait) userInfo:nil repeats:NO];
    
    NSString *path = [[NSString alloc] initWithFormat:@"https://www.appmonster.org/ChappeeAcres/farmpics/%@",self.filearray[picnum]];
    NSURL *url = [NSURL URLWithString:path];

    NSData *imgdata = [NSData dataWithContentsOfURL:url];
    self.Pic.image = [[UIImage alloc] initWithData:imgdata];
    self.BigView.image = self.Pic.image;
    self.Next.enabled = true;
    
    //CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    [self.scrollview setContentSize:CGSizeMake(self.Pic.image.size.width, self.Pic.image.size.height)];
    NSLog(@"scrollview: %f x %f",self.scrollview.contentSize.width, self.scrollview.contentSize.height);
    self.Pic.frame = CGRectMake(0, 0, self.PicView.frame.size.width, self.PicView.frame.size.height);
    
    NSLog(@"image: %f x %f",self.Pic.image.size.width, self.Pic.image.size.height);
    NSLog(@"imageview: %f x %f",self.Pic.frame.size.width, self.Pic.frame.size.height);
    
    self.scrollview.contentOffset = CGPointMake(0, 0);
}

-(void)HideWait {
    self.Next.enabled = true;
    self.Back.enabled = true;
}

-(void)orientationChanged:(NSNotification *)note {
    UIDevice * device = note.object;
    switch(device.orientation) {
      case UIDeviceOrientationPortrait:
            NSLog(@"Portrait");
      break;

      case UIDeviceOrientationLandscapeLeft:
      case UIDeviceOrientationLandscapeRight:
            NSLog(@"Landscape");
      break;

      default:
      break;
       };
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)Startspinner {
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame = CGRectMake(round((self.PicView.frame.size.width) / 2), round((self.PicView.frame.size.height) / 2), 25, 25);
    av.tag  = 1;
    av.transform = CGAffineTransformMakeScale(3, 3);
    [self.PicView addSubview:av];
    [av startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Stopspinning) userInfo:nil repeats:false];
}

-(void)Stopspinning {
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.PicView viewWithTag:1];
    [tmpimg removeFromSuperview];
}


- (IBAction)NextDown:(id)sender {
    if (self.filenum != self.filearray.count) {
        self.filenum++;
        [self Startspinner];
        [self LoadPic:self.filenum];
    }
}
- (IBAction)CloseDown:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)BackDown:(id)sender {
    if (self.filenum > 0) {
        self.filenum--;
        [self Startspinner];
        [self LoadPic:self.filenum];
    }
    
}
@end
