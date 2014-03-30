//
//  ItemDetails.m
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "ItemDetails.h"

@implementation ItemDetails

-(void)viewDidLoad{
    [[self navigationController] setTitle:_itemName];
    [_quantityLabel setText: _quantity];
    [_detailLabel setText:_details];
    if(_reserveButton){
        _reserveButton.layer.cornerRadius = 5.0f;
    }
}

- (IBAction)editItem:(id)sender {
}

@end
