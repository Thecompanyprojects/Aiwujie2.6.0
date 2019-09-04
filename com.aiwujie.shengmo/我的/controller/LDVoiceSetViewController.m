//
//  LDVoiceSetViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/3/28.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDVoiceSetViewController.h"

@interface LDVoiceSetViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shockSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;


@end

@implementation LDVoiceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"声音设置";
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
        
        _voiceSwitch.on = YES;
        
    }else{
    
        [RCIM sharedRCIM].disableMessageAlertSound = YES;
        
        _voiceSwitch.on = NO;
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
        
        _notificationSwitch.on = YES;
        
    }else{
        
        [RCIM sharedRCIM].disableMessageNotificaiton = YES;
        
        _notificationSwitch.on = NO;
    }

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] isEqualToString:@"no"]) {
        
        _shockSwitch.on = NO;
        
    }else{
        
        _shockSwitch.on = YES;
    }
    
    
}
- (IBAction)notificationSwitch:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageNotificaiton = YES;
        
        _notificationSwitch.on = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"notificationSwitch"];
        
    }else{
        
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
        
        _notificationSwitch.on = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"notificationSwitch"];
    }

}

- (IBAction)shockSwitch:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] isEqualToString:@"no"]) {
        
        _shockSwitch.on = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"shockSwitch"];
        
    }else{
        
        _shockSwitch.on = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"shockSwitch"];
    }
}

- (IBAction)voiceSwitch:(id)sender{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageAlertSound = YES;
        
        _voiceSwitch.on = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"voiceSwitch"];
        
    }else{
        
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
        
        _voiceSwitch.on = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"voiceSwitch"];
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
