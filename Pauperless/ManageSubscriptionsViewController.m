//
//  ManageSubscriptionsViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "ManageSubscriptionsViewController.h"
#import "NonprofitCell.h"

@implementation ManageSubscriptionsViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _nonprofitList = [[NSArray alloc] init];
    _nonprofitDict = [[NSMutableDictionary alloc] init];
    _personalSub = [[NSMutableDictionary alloc] initWithDictionary:_personalSub copyItems:YES];
    [[self refreshControl] addTarget:self action:@selector(refreshNonprofits) forControlEvents:UIControlEventValueChanged];
    [self performSelector:@selector(refreshNonprofits)];
}

-(void)refreshNonprofits{
    PFQuery *query = [PFUser query];
    [query whereKey:@"is_master" equalTo: @YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            _nonprofitList = [NSArray arrayWithArray:objects];
            for (PFObject *nonprofit in _nonprofitList){
                [_nonprofitDict setObject:[nonprofit objectForKey:@"listId"] forKey:[nonprofit objectForKey:@"organization_name"]];
            }
            [[self refreshControl] endRefreshing];
            [[self tableView] reloadData];
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NonprofitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NonprofitCell"];

    NSString *nonprofitName = [[NSString alloc] initWithString:[[_nonprofitList objectAtIndex:indexPath.row] objectForKey:@"organization_name"] ];
    [cell.nameLabel setText: nonprofitName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
    PFUser *user =[_nonprofitList objectAtIndex:indexPath.row];
    if([cell accessoryType] == UITableViewCellAccessoryCheckmark){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [_personalSub removeObjectForKey:[user objectForKey:@"organization_name"]];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [_personalSub setObject:[user objectForKey:@"listId"] forKey:[user objectForKey:@"organization_name"]];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nonprofitList count];
}

@end
