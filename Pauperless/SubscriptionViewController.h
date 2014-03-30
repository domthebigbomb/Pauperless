//
//  SubscriptionViewController.h
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SubscriptionViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property NSString *subscriptionID;
@property NSArray *nonprofitList;
@property NSDictionary *subscriptions;
@end
