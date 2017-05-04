//
//  CartCell.h
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 06.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSCartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end
