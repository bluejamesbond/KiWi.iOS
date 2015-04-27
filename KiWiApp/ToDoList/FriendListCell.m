//
//  FriendListCell.m
//  KiWi
//
//  Created by Kapil Gowru on 4/27/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

@synthesize userName = _userName;
@synthesize userImage = _userImage;
@synthesize keyLevel = _keyLevel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
