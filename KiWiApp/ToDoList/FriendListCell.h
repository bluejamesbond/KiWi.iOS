//
//  FriendListCell.h
//  KiWi
//
//  Created by Kapil Gowru on 4/27/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *keyLevel;

@end
