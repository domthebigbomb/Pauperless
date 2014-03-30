//
//  PauperViewController.h
//  Pauperless
//
//  Created by Dominic Ong on 3/29/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface PauperViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>

-(IBAction)goHome:(UIStoryboardSegue *)segue;
- (IBAction)toggleMaster:(id)sender;

@property BOOL validLogin;
@property (strong, nonatomic)UITapGestureRecognizer *tap;
@property (strong, nonatomic) UIAlertView *alertMsg;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *masterSelector;
@property (weak, nonatomic) IBOutlet UIButton *masterButton;
@property (weak, nonatomic) IBOutlet UIButton *userButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)Login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
