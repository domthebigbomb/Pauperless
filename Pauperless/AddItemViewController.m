//
//  AddItemViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/29/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "AddItemViewController.h"
#import <Parse/Parse.h>
@implementation AddItemViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _takePictureButton.layer.cornerRadius = 4.0f;
    _selectPictureButton.layer.cornerRadius = 4.0f;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _tap.enabled = NO;
    [self.view addGestureRecognizer:_tap];
    //Check for camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _alertMsg = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [_alertMsg show];
    }
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _itemImage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([_totalField.text integerValue] < [_availableField.text integerValue]){
        _alertMsg = [[UIAlertView alloc] initWithTitle:@"Info Error" message:@"Amount available cannot exceed total amount!" delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles: nil];
        [_alertMsg show];
        return NO;
    }
    if([_nameField.text isEqualToString:@""] || [_totalField.text isEqualToString:@""] || [_availableField.text isEqualToString:@""]){
        _alertMsg = [[UIAlertView alloc] initWithTitle:@"Info Error" message:@"Please fill out Item Name, Total Amount, and Available Amount." delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles: nil];
        [_alertMsg show];
    }
    if([identifier isEqualToString:@"cancel"]){
        return YES;
    }
    return YES;
}

@end
