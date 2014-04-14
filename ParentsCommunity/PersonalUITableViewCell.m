//
//  PersonalUITableViewCell.m
//  ParentsCommunity
//
//  Created by qizhang on 14-3-21.
//  Copyright (c) 2014年 张 诗杰. All rights reserved.
//

#import "PersonalUITableViewCell.h"

@implementation PersonalUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        infoLabel = [[UILabel alloc]init];
        [self addSubview:infoLabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPersonalInfo:(NSString *)info
{
    [infoLabel setText:info];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    [infoLabel sizeToFit ];
    [infoLabel setFrame:CGRectMake(self.bounds.size.width-66-infoLabel.frame.size.width, 14, infoLabel.frame.size.width, infoLabel.frame.size.height)];
}

-(void)setChildName:(NSString *)name
{
    if(!nameLabel)
    {
        nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [nameLabel setText:name];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [nameLabel sizeToFit];
    [nameLabel setFrame:CGRectMake(self.bounds.size.width-66-nameLabel.frame.size.width, 14, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    }
}

@end
