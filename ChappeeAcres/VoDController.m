//
//  VoDController.m
//  ChappeeAcres
//
//  Created by Matthew Chappee on 12/24/21.
//

#import "VoDController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

@interface VoDController ()

@end

@implementation VoDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"in VoD");
    NSURL *createurl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.appmonster.org/ChappeeAcres/getVods.php"]];
        
    NSData *data = [NSData dataWithContentsOfURL:createurl];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    self.Picker.delegate = self;
    self.Picker.dataSource = self;
    
    self.pickeroptions = [[NSMutableArray alloc] init];
    self.pickervids = [[NSMutableArray alloc] init];
    self.Picker.hidden = true;
    
    for (NSDictionary *vod in dict) {
        NSLog([vod description]);
        NSString *vid = [vod objectForKey:@"id"];
        NSString *name = [vod objectForKey:@"name"];
        NSLog(@"VoD name: %@", name);
        [self.pickeroptions addObject:name];
        [self.pickervids addObject:vid];
    }

    [self.Picker reloadAllComponents];
    self.Picker.hidden = false;

}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return self.pickeroptions.count;
}


- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component {
    NSLog(@"populating: %@", [self.pickeroptions objectAtIndex:row]);
    
    return [self.pickeroptions objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)GamePicker didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.vod = [self.pickervids objectAtIndex:row];
}

-(void)Startspinner {
    UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame = CGRectMake(round((self.VODView.frame.size.width) / 2), round((self.VODView.frame.size.height) / 2), 25, 25);
    av.tag  = 1;
    av.transform = CGAffineTransformMakeScale(3, 3);
    [self.VODView addSubview:av];
    [av startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Stopspinning) userInfo:nil repeats:false];
}

-(void)Stopspinning {
    UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.VODView viewWithTag:1];
    [tmpimg removeFromSuperview];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)CloseButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)PlayButton:(id)sender {
    [self Startspinner];
    NSString *address = [NSString stringWithFormat:@"https://appmonster.org:5443/LiveApp/play.html?id=%@&playOrder=vod", self.vod];
    NSURL *url = [NSURL URLWithString:address];
    SFSafariViewController *safariView = [[SFSafariViewController alloc] initWithURL:  url];
    safariView.delegate = self;
    safariView.preferredBarTintColor = UIColorFromRGB (0x175411);
    safariView.preferredControlTintColor = UIColorFromRGB (0xFFFFFF);
    [self presentViewController:safariView animated:TRUE completion:nil];
}
@end
