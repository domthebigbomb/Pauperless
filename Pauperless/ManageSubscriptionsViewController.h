//
//  ManageSubscriptionsViewController.h
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ManageSubscriptionsViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property NSArray *nonprofitList;
@property NSMutableDictionary *nonprofitDict;

@end
