//
//  AddItemViewController.h
//  Pauperless
//
//  Created by Dominic Ong on 3/29/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemViewController : UITableViewController<UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic)UITapGestureRecognizer *tap;
@property (strong, nonatomic) UIAlertView *alertMsg;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *totalField;
@property (weak, nonatomic) IBOutlet UITextField *availableField;
@property (weak, nonatomic) IBOutlet UITextField *detailField;
@property (weak, nonatomic) IBOutlet UIButton *selectPictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;
- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;


@end
