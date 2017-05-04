//
//  MSCart.h
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 07.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MSProduct;

@interface MSCart : NSManagedObject

@property (nonatomic, readonly) int32_t cost;

@end

#import "MSCart+CoreDataProperties.h"
