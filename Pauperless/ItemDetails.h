//
//  ItemDetails.h
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetails : UIViewController
@property (strong,nonatomic) NSString *itemName;
@property (strong,nonatomic) NSString *quantity;
@property (strong,nonatomic) NSString *details;
@property (strong,nonatomic) UIImage *itemPicture;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
- (IBAction)editItem:(id)sender;

@end
