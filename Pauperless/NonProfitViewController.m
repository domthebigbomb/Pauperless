//
//  NonProfitViewController.m
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import "NonProfitViewController.h"
#import "AddItemViewController.h"
#import "ItemCell.h"
#import "ItemDetails.h"

@implementation NonProfitViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    BOOL isMaster = [[NSUserDefaults standardUserDefaults] boolForKey:@"is_master"];
    if(isMaster){
        _personalizedList = [[NSUserDefaults standardUserDefaults] stringForKey:@"objectId"];
    }
    _itemList = [[NSMutableDictionary alloc] init];
    _items = [[NSMutableArray alloc] init];
    _currItem = [[NSString alloc] init];
    [[self refreshControl] addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
    [self performSelector:@selector(refreshList)];
}

-(void)refreshList{
    PFQuery *query = [PFQuery queryWithClassName:@"itemList"];
    [query getObjectInBackgroundWithId:_personalizedList block:^(PFObject *itemList, NSError *error) {
        _itemList = [NSMutableDictionary dictionaryWithDictionary:[itemList objectForKey:@"properties"]];
        _items = [[NSMutableArray alloc] initWithArray:[_itemList allKeys]];
        [[self refreshControl] endRefreshing];
        [[self tableView] reloadData];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    NSString *itemName = [_items objectAtIndex:indexPath.row];
    NSDictionary *properties = [[NSDictionary alloc] initWithDictionary:[_itemList objectForKey:itemName]];
    [cell.nameLabel setText:itemName];
    cell.details = [NSString stringWithString:[properties objectForKey:@"details"]];
    int total = [[properties objectForKey:@"totalAmt"] integerValue];
    int available = [[properties objectForKey: @"available"] integerValue];
    NSString *quantity = [NSString stringWithFormat:@"Quantity: (%d/%d)",available,total];
    [cell.quantityLabel setText: quantity];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currItem = [NSString stringWithString:[_items objectAtIndex:[indexPath row]]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showDetail"]){
    
        _currItem = [NSString stringWithString:[_items objectAtIndex:[[[self tableView] indexPathForSelectedRow] row]]];
        ItemDetails *controller = (ItemDetails *)[segue destinationViewController];
        NSString *itemName = [NSString stringWithString:_currItem];
        NSDictionary *properties = [_itemList objectForKey:itemName];
        int total = [[properties objectForKey:@"totalAmt"] integerValue];
        int available = [[properties objectForKey: @"available"] integerValue];
        NSString *quantity = [NSString stringWithFormat:@"Quantity: (%d/%d)",available,total];
        controller.itemName = [NSString stringWithString:itemName];
        controller.quantity = [NSString stringWithString:quantity];
        controller.details = [NSString stringWithString:[properties objectForKey:@"details"]];
    }
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
