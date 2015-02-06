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

@property (readwrite, nonatomic, strong) NSString *objectId;
@property (readwrite, nonatomic, strong) NSDate *createdAt;
@property (readwrite, nonatomic, strong) NSDate *updatedAt;
@property (readwrite, nonatomic, strong) NSString *parseClassName;

@end
