//
//  NonProfitViewController.h
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NonProfitViewController : UITableViewController

@property NSString *personalizedList;
-(IBAction)nonprofitHome:(UIStoryboardSegue *)segue;
-(IBAction)create:(UIStoryboardSegue *)segue;

@end
