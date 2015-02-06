//
//  MTLParseAdapterTests.m
//  MTLParseAdapterTests
//
//  Created by Mike Walker on 02/06/2015.
//  Copyright (c) 2014 Mike Walker. All rights reserved.
//

#import <MTLParseAdapter/MTLParseAdapter.h>
#import <Parse/Parse.h>

#import "TestObject.h"

SpecBegin(MTLParseAdapter)

describe(@"MTLParseAdapter", ^{
    describe(@"converting a single object", ^{
        describe(@"converting from a domain object to a Parse object", ^{
            __block TestObject *object;
            __block PFObject *parseObject;

            beforeEach(^{
                object = [[TestObject alloc] init];
                object.name = @"name";
                object.number = @5;
                object.integerNumber = 10;
                object.nestedObject = [[TestObject alloc] init];
                object.nestedObject.name = @"name2";

                parseObject = [MTLParseAdapter parseObjectFromModel:object];
            });

            it(@"should have the same values for core Obj-C datatypes", ^{
                expect(parseObject[@"name"]).to.equal(@"name");
            });

            it(@"should respect +JSONKeyPathsByPropertyKey", ^{
                expect(parseObject[@"number"]).to.beNil;
                expect(parseObject[@"numberWithDifferentJSONKey"]).to.equal(@5);
            });

            it(@"should auto-box non-object types", ^{
                expect(parseObject[@"integerNumber"]).to.equal(@10);
            });

            it(@"should properly use value transformers", ^{
                expect(parseObject[@"nestedObject"]).to.beInstanceOf(PFObject.class);
                expect(parseObject[@"nestedObject"][@"name"]).to.equal(@"name2");
            });
        });
    });
});

SpecEnd
