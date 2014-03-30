//
//  AddItemViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/29/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "AddItemViewController.h"

@implementation AddItemViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _tap.enabled = NO;
    [self.view addGestureRecognizer:_tap];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _tap.enabled = YES;
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //_visualView.center = CGPointMake(_originalCenter.x, _originalCenter.y - 120);
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:_nameField]){
        [_totalField becomeFirstResponder];
    }
    return YES;
}

-(void)hideKeyboard
{
    //_visualView.center = _originalCenter;
    [_nameField resignFirstResponder];
    [_totalField resignFirstResponder];
    [_availableField resignFirstResponder];
    [_detailField resignFirstResponder];
    _tap.enabled = NO;
}



@end
