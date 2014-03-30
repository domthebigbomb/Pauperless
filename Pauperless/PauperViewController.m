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

- (IBAction)Login:(id)sender {
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                NSNumber *isMaster = (NSNumber *)[user objectForKey: @"is_master"];
                if ([isMaster boolValue]== [_userButton isHidden]){
                    _validLogin = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"username"];
                    if(isMaster){
                        [self performSegueWithIdentifier:@"GoMaster" sender:self];
                        [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"listId"] forKey:@"objectId"];
                        _alertMsg = [[UIAlertView alloc] initWithTitle:@"ObjectId" message:[user objectForKey:@"listId"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        [_alertMsg show];
                    }else{
                        [self performSegueWithIdentifier:@"GoUser" sender:self];
                    }
                }else{
                    NSLog(@"Type of account did not match credentials");
                }
            } else {
                _validLogin = NO;
            }
        }];
    
    
}
@end
