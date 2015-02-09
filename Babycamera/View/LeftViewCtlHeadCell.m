//
//  LeftViewCtlHeadCell.m
//  Babycamera
//
//  Created by bear on 15/1/29.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "LeftViewCtlHeadCell.h"

@implementation LeftViewCtlHeadCell
- (void)awakeFromNib {
    
    self.userImgButton.layer.cornerRadius = self.userImgButton.bounds.size.height / 2.0 ;
    self.userImgButton.clipsToBounds = YES ;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
