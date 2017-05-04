//
//  MSProduct.h
//  MicroStoreTestProject
//
//  Created by Kuznetsov Aleksey on 07.03.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MSCart, MSStock;

@interface MSProduct : NSManagedObject

@end

#import "MSProduct+CoreDataProperties.h"
