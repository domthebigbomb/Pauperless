//
//  NonProfitViewController.h
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NonProfitViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property NSString *organizationName;
@property NSString *currItem;
@property NSString *personalizedList;
@property NSMutableDictionary *itemList;
@property NSMutableArray *items;
-(IBAction)nonprofitHome:(UIStoryboardSegue *)segue;
-(IBAction)create:(UIStoryboardSegue *)segue;

@end
