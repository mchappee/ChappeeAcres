//
//  LiveCamController.m
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/24/21.
//

#import "LiveCamController.h"
#import "Cameras.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

@interface LiveCamController ()

@end

@implementation LiveCamController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraarray = [[NSMutableArray alloc] init];
    
    NSURL *createurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.appmonster.org/ChappeeAcres/configs/livecams.json"]];
    NSData *data = [NSData dataWithContentsOfURL:createurl];
    
    NSMutableArray *cams = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    int a = 0;
    
    for (id camera in cams) {
        NSNumber *camenable = [camera objectForKey:@"camenable"];
        if ([camenable integerValue] && a < 4) {
            a++;
            Cameras *cam = [[Cameras alloc] init];
            cam.cameraname = [camera objectForKey:@"camname"];
            cam.url = [camera objectForKey:@"camurl"];
            NSString *camicon1 = [camera objectForKey:@"camicon1"];
            NSString *camicon2 = [camera objectForKey:@"camicon2"];
            NSURL *url = [NSURL URLWithString:camicon1];
            cam.mainicon = [NSData dataWithContentsOfURL:url];
            url = [NSURL URLWithString:camicon2];
            cam.blueicon = [NSData dataWithContentsOfURL:url];
            
            UIImage *img = [UIImage imageWithData:cam.mainicon];
            UILabel *label = [self.LiveView viewWithTag:a+5];
            [label setText:cam.cameraname];
            label.hidden = false;
            cam.iv = [self.LiveView viewWithTag:a];
            [cam.iv setImage:img];
            cam.iv.tag = a;
            cam.iv.hidden = false;
            
            cam.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CameraTap:)];
            cam.singleTap.numberOfTapsRequired = 1;
            [cam.iv setUserInteractionEnabled:YES];
            [cam.iv addGestureRecognizer:cam.singleTap];
            
            [self.cameraarray addObject:cam];
        } else {
            NSLog(@"Camera Disabled: %@",[camera objectForKey:@"camname"]);
        }
    }
    
    // Do any additional setup after loading the view from its nib.
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
    av.frame = CGRectMake(round((self.LiveView.frame.size.width) / 2), round((self.LiveView.frame.size.height) / 2), 25, 25);
    av.tag  = 50;
    av.transform = CGAffineTransformMakeScale(3, 3);
    [self.LiveView addSubview:av];
    [av startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(Stopspinning) userInfo:nil repeats:false];
}

-(void)Stopspinning {
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.LiveView viewWithTag:50];
    [tmpimg removeFromSuperview];
}

-(void)CameraTap: (UITapGestureRecognizer *)gestureRecognizer {
    long a = (long)gestureRecognizer.view.tag;
    Cameras *thiscam = self.cameraarray[a-1];
    UIImage *img;
    
    [self Startspinner];
    
    
    for (id camera in self.cameraarray) {
        Cameras *c = camera;
        img = [UIImage imageWithData:c.mainicon];
        [c.iv setImage:img];
        
    }
    
    NSURL *url = [NSURL URLWithString:thiscam.url];
    SFSafariViewController *safariView = [[SFSafariViewController alloc] initWithURL:  url];
    safariView.delegate = self;
    safariView.preferredBarTintColor = UIColorFromRGB (0x175411);
    safariView.preferredControlTintColor = UIColorFromRGB (0xFFFFFF);
    [self presentViewController:safariView animated:TRUE completion:nil];
    
    img = [UIImage imageWithData:thiscam.blueicon];
    [thiscam.iv setImage:img];
    
  }

@end
