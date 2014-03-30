//
//  NonprofitCell.h
//  Pauperless
//
//  Created by Dominic Ong on 3/30/14.
//  Copyright (c) 2014 DTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NonprofitCell : UITableViewCell

@property NSString *name;
@property (weak, nonatomic) IBOutlet UIImageView *nonprofitImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
