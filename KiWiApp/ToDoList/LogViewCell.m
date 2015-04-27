//
//  LogViewCell.m
//  KiWi
//
//  Created by Kapil Gowru on 4/6/15.
//  Copyright (c) 2015 Kapil Gowru. All rights reserved.
//

#import "LogViewCell.h"

@implementation LogViewCell

@synthesize nameLabel = _nameLabel;
@synthesize eventLabel = _eventLabel;
@synthesize timeLabel = _timeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
