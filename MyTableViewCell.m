//
//  MyTableViewCell.m
//  QuantumNews
//
//  Created by wangxinyan on 15/12/3.
//  Copyright (c) 2015年 longjiang. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.TitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 5, self.frame.size.width-17, 30)];
        self.TitleLabel.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:self.TitleLabel];
        
        self.ContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(2, 30, 375, 40)];
        self.ContentLabel.font=[UIFont systemFontOfSize:12];
        self.ContentLabel.numberOfLines=0;
        [self.contentView addSubview:self.ContentLabel];
        
        self.NumberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 12.5, 15, 15)];
        [self.contentView addSubview:self.NumberImageView];
    
    }
    return self;
}
@end
