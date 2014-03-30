//
//  RegistrationViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/29/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "RegistrationViewController.h"
#import <Parse/Parse.h>

@implementation RegistrationViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _isMaster = ([self.restorationIdentifier isEqualToString:@"master"]) ? @YES : @NO;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _tap.enabled = NO;
    [self.view addGestureRecognizer:_tap];
}

// Keyboard Related Methods
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _tap.enabled = YES;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //_visualView.center = CGPointMake(_originalCenter.x, _originalCenter.y - 120);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:_usernameTextField]){
        [_passwordTextField becomeFirstResponder];
    }else{
        [self performSelector:@selector(Register:) withObject:self];
    }
    return YES;
}

-(void)hideKeyboard
{
    //_visualView.center = _originalCenter;
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_confirmPwTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_organizationTextField resignFirstResponder];
    [_websiteTextField resignFirstResponder];
    [_locationTextField resignFirstResponder];
    _tap.enabled = NO;
}

-(BOOL)checkFields{
    if(![_passwordTextField.text isEqualToString:_confirmPwTextField.text]){
        return NO;
    }else if([_passwordTextField.text isEqualToString:@""]){
        return NO;
    }else if([_usernameTextField.text isEqualToString:@""]){
        return NO;
    }else if([_emailTextField.text isEqualToString:@""]){
        return NO;
    }
    
    return YES;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return [self checkFields];
}

- (IBAction)Register:(id)sender {
    if(![self checkFields]){
        _alertMsg = [[UIAlertView alloc] initWithTitle:@"Password Mismatch" message:@"Make sure both passwords match!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [_alertMsg show];
    }else{
        PFUser *user = [PFUser user];
        user.username = _usernameTextField.text;
        user.password = _passwordTextField.text;
        user.email = _emailTextField.text;
    
        // other fields can be set if you want to save more information
        user[@"is_master"] = _isMaster;
        user[@"website"] = (_websiteTextField == nil) ? [NSNull null]: _websiteTextField.text;
        user[@"organization_name"] = (_organizationTextField == nil) ? [NSNull null] : _organizationTextField.text;
        user[@"location"] = (_locationTextField == nil) ? [NSNull null] : _locationTextField.text;
        user[@"listId"] = @"n/a";
        
        NSMutableDictionary *itemList = [[NSMutableDictionary alloc] init];
        PFObject *newItem = [PFObject objectWithClassName:@"itemList"];
        newItem[@"properties"] = itemList;
        
        [newItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSString *listId = [newItem objectId];
                user[@"listId"] = [NSString stringWithString:listId];
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        _alertMsg = [[UIAlertView alloc] initWithTitle:@"ObjectId" message:[user objectForKey:@"listId"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                        [_alertMsg show];
                    } else {
                        NSString *errorString = [error userInfo][@"error"];
                        _alertMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                        [_alertMsg show];
                    }
                }];
            }
        }];
        
        
    }
}
@end
