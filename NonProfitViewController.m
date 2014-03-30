//
//  NonProfitViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "NonProfitViewController.h"
#import "AddItemViewController.h"

@implementation NonProfitViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _personalizedList = [[NSUserDefaults standardUserDefaults] stringForKey:@"objectId"];
}

-(IBAction)nonprofitHome:(UIStoryboardSegue *)segue{
    
}


-(IBAction)create:(UIStoryboardSegue *)segue{
    AddItemViewController *addView = [segue sourceViewController];
    NSMutableDictionary *newProperties = [[NSMutableDictionary alloc] init];
    
    [newProperties setObject:addView.nameField.text forKey:@"itemName"];
    [newProperties setObject:addView.totalField.text forKey:@"totalAmt"];
    [newProperties setObject:addView.availableField.text forKey:@"available"];
    [newProperties setObject:addView.detailField.text forKey:@"details"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"itemList"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:_personalizedList block:^(PFObject *itemList, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        NSMutableDictionary *oldProperties = [[NSMutableDictionary alloc] initWithDictionary:[itemList objectForKey:@"properties"]];
        [oldProperties setObject:newProperties forKey:addView.nameField.text];
        itemList[@"properties"] = oldProperties;
        [itemList saveInBackground];
        
    }];
}


@end
