//
//  SubscriptionViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "NonprofitCell.h"
#import "ManageSubscriptionsViewController.h"
#import "NonProfitViewController.h"

@implementation SubscriptionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _nonprofitList = [[NSArray alloc] init];
    _subscriptions = [[NSDictionary alloc] init];
    _subscriptionID = [[NSUserDefaults standardUserDefaults] stringForKey:@"subscription"];
    [[self refreshControl] addTarget:self action:@selector(refreshSubscriptions) forControlEvents:UIControlEventValueChanged];
    [self performSelector:@selector(refreshSubscriptions)];
    
}

-(void)refreshSubscriptions{
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"subscriptions"];
    [query getObjectInBackgroundWithId:_subscriptionID block:^(PFObject *subs, NSError *error) {
        _subscriptions = [NSDictionary dictionaryWithDictionary: [subs objectForKey:@"nonprofits"]];
        _nonprofitList = [NSArray arrayWithArray:[_subscriptions allKeys]];
        [[self refreshControl] endRefreshing];
        [[self tableView] reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NonprofitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NonprofitCell"];
    NSString *nonprofitName = [_nonprofitList objectAtIndex:indexPath.row];
    [cell.nameLabel setText: nonprofitName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nonprofitList count];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"nonprofitItems"]){
        NonProfitViewController *nonprofit = (NonProfitViewController *)[segue destinationViewController];
        NSString *nonprofitName = [_nonprofitList objectAtIndex: [[self tableView] indexPathForSelectedRow].row];
        NSString *objectId = [_subscriptions objectForKey:nonprofitName];
        nonprofit.personalizedList = objectId;
    }
}

-(IBAction)subscriptionHome:(UIStoryboardSegue *)segue{
    
}

-(IBAction)updateSubscription:(UIStoryboardSegue *)segue{
    ManageSubscriptionsViewController *controller = (ManageSubscriptionsViewController *)[segue sourceViewController];
    NSDictionary *newSubs = [[NSDictionary alloc] initWithDictionary:controller.personalSub];
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"subscriptions"];
    [query getObjectInBackgroundWithId:_subscriptionID block:^(PFObject *oldSubs, NSError *error) {
        if(!error){
            oldSubs[@"nonprofits"] = newSubs;
            [oldSubs saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    [self refreshSubscriptions];
                }
            }];
        }
    }];
    
}


@end
