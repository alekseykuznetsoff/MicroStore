//
//  MSCartCell.m
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 06.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "MSCartCell.h"

@implementation MSCartCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.button.layer.cornerRadius = 5;
    self.button.layer.borderWidth = 1 / [UIScreen mainScreen].scale;;
    self.button.layer.borderColor = self.button.currentTitleColor.CGColor;
}

@end
