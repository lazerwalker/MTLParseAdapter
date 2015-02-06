//
//  TestObject.h
//  MTLParseAdapter
//
//  Created by Michael Walker on 2/6/15.
//  Copyright (c) 2015 Mike Walker. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TestObject : MTLModel<MTLJSONSerializing>

@property (readwrite, nonatomic, strong) NSString *name;

@property (readwrite, nonatomic, strong) NSNumber *number;

@property (readwrite, nonatomic, assign) NSInteger integerNumber;

@property (readwrite, nonatomic, strong) TestObject *nestedObject;

@end
