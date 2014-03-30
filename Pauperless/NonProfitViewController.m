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
    _organizationName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"nonprofit"]];
    UINavigationBar *bar = [self navigationController].navigationBar;
    bar.topItem.title = _organizationName;
    if([_organizationName length] > 20){
        UIFont *font = [UIFont fontWithName:@"Avenir Medium" size:16.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [UIColor whiteColor],NSForegroundColorAttributeName, nil];
        [bar setTitleTextAttributes:attributes];
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
    NSString *photoId = [properties objectForKey:@"photoId"];
    if(photoId != nil){
        PFQuery *imageQuery = [[PFQuery alloc] initWithClassName:@"UserPhoto"];
        [imageQuery getObjectInBackgroundWithId: photoId block:^(PFObject *object, NSError *error) {
            if(!error){
                PFFile *theImage = [object objectForKey:@"imageFile"];
                NSData *imageData = [theImage getData];
                UIImage *image = [UIImage imageWithData:imageData];
                cell.itemImage.image = image;
            }
        }];
    }
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
        controller.imageId = [properties objectForKey: @"photoId"];
    }
}

-(IBAction)nonprofitHome:(UIStoryboardSegue *)segue{
    
}

-(IBAction)create:(UIStoryboardSegue *)segue{
    AddItemViewController *addView = [segue sourceViewController];
    NSMutableDictionary *newProperties = [[NSMutableDictionary alloc] init];
    UIImage *itemPic = addView.itemImage.image;
    NSData *imageData = UIImageJPEGRepresentation(itemPic , 0.05f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            //userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSString *photoId = [userPhoto objectId];
                    [newProperties setObject:addView.nameField.text forKey:@"itemName"];
                    [newProperties setObject:addView.totalField.text forKey:@"totalAmt"];
                    [newProperties setObject:addView.availableField.text forKey:@"available"];
                    [newProperties setObject:addView.detailField.text forKey:@"details"];
                    [newProperties setObject:photoId forKey:@"photoId"];
                    PFQuery *query = [PFQuery queryWithClassName:@"itemList"];
                    
                    // Retrieve the object by id
                    [query getObjectInBackgroundWithId:_personalizedList block:^(PFObject *itemList, NSError *error) {
                        
                        NSMutableDictionary *oldProperties = [[NSMutableDictionary alloc] initWithDictionary:[itemList objectForKey:@"properties"]];
                        [oldProperties setObject:newProperties forKey:addView.nameField.text];
                        itemList[@"properties"] = oldProperties;
                        [itemList saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            [self refreshList];
                        }];
                    }];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        
    }];

    
    }


@end
