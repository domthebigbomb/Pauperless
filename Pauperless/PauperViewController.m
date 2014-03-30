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

@implementation PauperViewController{
    CGPoint originalCenter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _masterButton.layer.cornerRadius = 4.0f;
    _userButton.layer.cornerRadius = 4.0f;
    _registerButton.layer.cornerRadius = 4.0f;
    
    
    UIFont *font = [UIFont fontWithName:@"Avenir Medium" size:16.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [_masterSelector setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    _masterSelector.layer.cornerRadius = 5.0f;
    _validLogin = NO;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _tap.enabled = NO;
    [self.view addGestureRecognizer:_tap];
	// Do any additional setup after loading the view, typically from a nib.
    originalCenter = _loginView.center;
}

-(void)viewDidAppear:(BOOL)animated{
    [_userButton setEnabled: YES];
    [_masterButton setEnabled: YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _tap.enabled = YES;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _loginView.center = CGPointMake(originalCenter.x, originalCenter.y - 80);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:_usernameField]){
        [_passwordField becomeFirstResponder];
    }else{
        [self performSelector:@selector(Login:) withObject:self];
    }
    return YES;
}

-(void)hideKeyboard
{
    _loginView.center = originalCenter;
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];

    _tap.enabled = NO;
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
    if(![_usernameField.text isEqualToString:@""] && ![_passwordField.text isEqualToString:@""]){
        [_masterButton setEnabled:NO];
        [_userButton setEnabled: NO];
        [_activityIndicator startAnimating];
        [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                NSNumber *isMaster = (NSNumber *)[user objectForKey: @"is_master"];
                if ([isMaster boolValue]== [_userButton isHidden]){
                    _validLogin = YES;
                    [[NSUserDefaults standardUserDefaults] setObject:user.username forKey:@"username"];
                    if([isMaster boolValue]){
                        [self performSegueWithIdentifier:@"GoMaster" sender:self];
                        [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"organization_name"] forKey:@"nonprofit"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_master"];
                        [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"listId"] forKey:@"objectId"];
                        [_activityIndicator stopAnimating];
                    }else{
                        [self performSegueWithIdentifier:@"GoUser" sender:self];
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"is_master"];
                        [[NSUserDefaults standardUserDefaults] setObject:[user objectForKey:@"listId"] forKey:@"subscription"];
                        [_activityIndicator stopAnimating];
                    }
                }else{
                    NSLog(@"Type of account did not match credentials");
                    _alertMsg = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Invalid Login Credentials" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [_alertMsg show];
                    [_masterButton setEnabled: YES];
                    [_userButton setEnabled: YES];
                    [_activityIndicator stopAnimating];
                }
            } else {
                _alertMsg = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Invalid Login Credentials" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [_alertMsg show];
                [_masterButton setEnabled: YES];
                [_userButton setEnabled: YES];
                [_activityIndicator stopAnimating];
                _validLogin = NO;
            }
        }];
    }else{
        _alertMsg = [[UIAlertView alloc] initWithTitle:@"User Error" message:@"Please fill out both username and password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [_alertMsg show];
    }
    
}
@end
