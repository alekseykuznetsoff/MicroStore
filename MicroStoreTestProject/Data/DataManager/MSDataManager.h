//
//  MSDataManager.h
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 06.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MSProduct.h"
#import "MSStock.h"
#import "MSCart.h"

@interface MSDataManager : NSObject

+ (instancetype)sharedInstance;

- (void)createDummyData;

@end
