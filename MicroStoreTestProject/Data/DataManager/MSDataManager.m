//
//  MSDataManager.h
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 06.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "MSDataManager.h"

@implementation MSDataManager

#pragma mark - --Init
+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

#pragma mark - --Dummy Data

- (void)createDummyData
{
    for (int i=0; i<20; i++) {
        NSString *name;
        if (i == 0) {
            name = @"Product 0 long name, long long long long long long";
        } else {
            name = [NSString stringWithFormat:@"Product %i", i];
        }
        MSProduct *product = [MSProduct MR_createEntity];
        product.name = name;
        product.price = 1+arc4random_uniform(999);
        MSStock *productAtStock = [MSStock MR_createEntity];
        productAtStock.product = product;
        productAtStock.amount = 1+arc4random_uniform(19);
    }
}

@end
