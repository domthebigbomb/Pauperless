//
//  PauperViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/29/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "PauperViewController.h"

@interface PauperViewController ()

@end

@implementation PauperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _validLogin = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)goHome:(UIStoryboardSegue *)segue{
    
}

- (IBAction)toggleMaster:(id)sender {
    if([_masterSelector selectedSegmentIndex] == 0){
        _masterButton.hidden = NO;
        //_masterButton.enabled = YES;
        _userButton.hidden = YES;
    }else{
        _masterButton.hidden = YES;
        //_masterButton.enabled = NO;
        _userButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return (_validLogin) ? YES : NO;
}

- (IBAction)Login:(id)sender {
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                NSNumber *isMaster = (NSNumber *)[user objectForKey: @"is_master"];
                if ([isMaster boolValue]== [_masterSelector isHidden]){
                    _validLogin = YES;
                }else{
                    NSLog(@"Type of account did not match credentials");
                }
            } else {
                _validLogin = NO;
            }
        }];
    
    
}
@end
