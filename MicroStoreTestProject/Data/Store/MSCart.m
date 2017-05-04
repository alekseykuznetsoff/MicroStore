//
//  MSCart.m
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 07.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "MSCart.h"

@implementation MSCart

- (int32_t)cost
{
    return self.amount * self.product.price;
}

@end
