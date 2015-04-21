//
//  TestObject.m
//  MTLParseAdapter
//
//  Created by Michael Walker on 2/6/15.
//  Copyright (c) 2015 Mike Walker. All rights reserved.
//

#import "MTLParseAdapter.h"

#import "TestObject.h"

@implementation TestObject

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"number": @"numberWithDifferentJSONKey"};
}

+ (NSValueTransformer *)nestedObjectJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(PFObject *obj) {
        if (obj == nil) return nil;
        return [MTLParseAdapter modelOfClass:TestObject.class fromParseObject:obj error:nil];
    } reverseBlock:^id(TestObject *obj) {
        if (obj == nil) return nil;
        return [MTLParseAdapter parseObjectFromModel:obj error:nil];
    }];
}

@end
