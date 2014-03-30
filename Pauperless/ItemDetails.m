//
//  ItemDetails.m
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "ItemDetails.h"
#import "AddItemViewController.h"

@implementation ItemDetails

-(void)viewDidLoad{
    
    [_quantityLabel setText: _quantity];
    [_detailLabel setText:_details];
    //_itemImage = [UIImageView alloc];
    PFQuery *imageQuery = [[PFQuery alloc] initWithClassName:@"UserPhoto"];
    [imageQuery getObjectInBackgroundWithId:_imageId block:^(PFObject *object, NSError *error) {
        if(!error){
            PFFile *theImage = [object objectForKey:@"imageFile"];
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            _itemImage.image = image;
        }
    }];
    if(_reserveButton){
        _reserveButton.layer.cornerRadius = 5.0f;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    UINavigationBar *bar = [self navigationController].navigationBar;
    bar.topItem.title = _itemName;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"editItem"]){
        
    }
}

- (IBAction)editItem:(id)sender {
    [self performSegueWithIdentifier:@"editItem" sender:self];
}

@end
