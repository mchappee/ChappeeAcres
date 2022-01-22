//
//  ViewController.m
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/23/21.
//

#import "ViewController.h"
#import "Cell.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(CheckPush) userInfo:nil repeats:true];
        
    // Do any additional setup after loading the view.
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (void) CheckPush {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (ad.notification != nil) {
        //NSLog(ad.notification.description);
        self.pushurl = [[ad.notification objectForKey:@"aps"] objectForKey:@"url"];
        //NSString *title = [[ad.notification objectForKey:@"aps"] objectForKey:@"title"];
        NSString *type = [[ad.notification objectForKey:@"aps"] objectForKey:@"type"];
        
        ad.notification = nil;
        
        if ([type isEqualToString:@"showurl"])
            [self showURL:self.pushurl];
        if ([type isEqualToString:@"newnews"])
            [self showNews];
        
        
        
        NSLog(@"Notification URL is %@", self.pushurl);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([[segue identifier] isEqualToString:@"Pushseg"]) {
        ViewController *vc = [segue destinationViewController];
        vc.pushurl = self.pushurl;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.item) {
            
        case 0:
            cell.image.image = [UIImage imageNamed:@"Goat.png"];
            cell.label.text = @"Critters";
            cell.image.tag = 1;
            break;
        case 1:
            cell.image.image = [UIImage imageNamed:@"Camera.png"];
            cell.label.text = @"Live Cams";
            cell.image.tag = 2;
            break;
        case 2:
            cell.image.image = [UIImage imageNamed:@"VoD.png"];
            cell.label.text = @"Videos";
            cell.image.tag = 3;
            break;
        case 3:
            cell.image.image = [UIImage imageNamed:@"Pics.png"];
            cell.label.text = @"Pictures";
            cell.image.tag = 4;
            break;
        case 4:
            cell.image.image = [UIImage imageNamed:@"facebook.png"];
            cell.label.text = @"Facebook Group";
            cell.image.tag = 5;
            break;
        case 5:
            cell.image.image = [UIImage imageNamed:@"chappeeacresicon.png"];
            cell.label.text = @"News/Events";
            cell.image.tag = 6;
            break;
    }
      
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MenuTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [cell.image setUserInteractionEnabled:YES];
    [cell.image addGestureRecognizer:singleTap];
    
    return cell;
}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.MainMenu.collectionViewLayout invalidateLayout];
    
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    // best call super just in case
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.MainMenu.hidden = true;
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        // will execute during rotation
        
    } completion:^(id  _Nonnull context) {
        
        [self.MainMenu reloadData];
        self.MainMenu.hidden = false;
        [self resizeImageView:self.Tractor intoFrame:self.view.frame];
        
                
    }];
}

- (void)MenuTapped:(UITapGestureRecognizer*)sender {
    NSString *address;
    NSURL *url;
    SFSafariViewController *safariView;
    
    switch (sender.view.tag) {
        case 1:
            [self performSegueWithIdentifier:@"critterviewseg" sender:nil];
            break;
        case 2:
            [self performSegueWithIdentifier:@"LiveCamSeg" sender:nil];
            break;
        case 3:
            [self performSegueWithIdentifier:@"VoDseg" sender:nil];
            break;
        case 4:
            [self performSegueWithIdentifier:@"Picseg" sender:nil];
            break;
        case 5:
            address = [NSString stringWithFormat:@"https://www.facebook.com/groups/282861005623764"];
            url = [NSURL URLWithString:address];
            safariView = [[SFSafariViewController alloc] initWithURL:  url];
            safariView.delegate = self;
            safariView.preferredBarTintColor = UIColorFromRGB (0x175411);
            safariView.preferredControlTintColor = UIColorFromRGB (0xFFFFFF);
            [self presentViewController:safariView animated:TRUE completion:nil];
            break;
        case 6:
            [self showNews];
            break;
    }
}

- (void) showNews {
    NSString *address = [NSString stringWithFormat:@"https://www.appmonster.org/ChappeeAcres/newsevents.html"];
    NSURL *url = [NSURL URLWithString:address];
    SFSafariViewController *safariView = [[SFSafariViewController alloc] initWithURL:  url];
    safariView.delegate = self;
    safariView.preferredBarTintColor = UIColorFromRGB (0x175411);
    safariView.preferredControlTintColor = UIColorFromRGB (0xFFFFFF);
    [self presentViewController:safariView animated:TRUE completion:nil];
}

- (void) showURL:(NSString *)address {
    NSURL *url = [NSURL URLWithString:address];
    SFSafariViewController *safariView = [[SFSafariViewController alloc] initWithURL:  url];
    safariView.delegate = self;
    safariView.preferredBarTintColor = UIColorFromRGB (0x175411);
    safariView.preferredControlTintColor = UIColorFromRGB (0xFFFFFF);
    [self presentViewController:safariView animated:TRUE completion:nil];
}

- (void) resizeImageView:(UIImageView *)imageView intoFrame:(CGRect) frame {
    // resizing is not needed if the height is already the same
    if (frame.size.height == imageView.frame.size.height) {
        return;
    }

    CGFloat delta = frame.size.height / imageView.frame.size.height;
    CGFloat newWidth = imageView.frame.size.width * delta;
    CGFloat newHeight = imageView.frame.size.height * delta;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    CGFloat newX = (imageView.frame.size.width - newWidth) / 2; // recenter image with broader width
    CGRect imageViewFrame = imageView.frame;
    imageViewFrame.size.width = newWidth;
    imageViewFrame.size.height = newHeight;
    imageViewFrame.origin.x = newX;
    imageView.frame = imageViewFrame;

    // now resize the image
    assert(imageView.image != nil);
    imageView.image = [self imageWithImage:imageView.image scaledToSize:newSize];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
