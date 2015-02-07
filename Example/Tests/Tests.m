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

                object.objectId = @"id";
                object.parseClassName = @"className";
                object.createdAt = [NSDate date];
                object.updatedAt = [NSDate dateWithTimeIntervalSinceNow:-1000];

                parseObject = [MTLParseAdapter parseObjectFromModel:object error:nil];
            });

            xcontext(@"when parsing fails", ^{
                it(@"should thread the error through", ^{
                });
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

            it(@"should not affect the generated object when mutating the original object", ^{
                object.name = @"new name";
                expect(parseObject[@"name"]).to.equal(@"name");
            });

            context(@"when a property is a special Parse property", ^{
                it(@"should not be set in the object dictionary", ^{
                    expect(parseObject[@"objectId"]).to.beNil;
                    expect(parseObject[@"parseClassName"]).to.beNil;
                    expect(parseObject[@"createdAt"]).to.beNil;
                    expect(parseObject[@"updatedAt"]).to.beNil;
                });

                it(@"should set the appropriate PFObject property", ^{
                    expect(parseObject.objectId).to.equal(@"id");
                    expect(parseObject.parseClassName).to.equal(@"className");
                    expect(parseObject.createdAt).to.equal(object.createdAt);
                    expect(parseObject.updatedAt).to.equal(object.updatedAt);
                });
            });

            context(@"when there is no parseClassName set", ^{
                it(@"should default to the model class name", ^{
                    TestObject *obj = [[TestObject alloc] init];
                    PFObject *parseObj = [MTLParseAdapter parseObjectFromModel:obj error:nil];
                    expect(parseObj.parseClassName).to.equal(@"TestObject");
                });
            });
        });

        describe(@"converting from a Parse object to a domain object", ^{
            __block TestObject *object;
            __block PFObject *parseObject;

            beforeEach(^{
                NSDictionary *params = @{
                    @"name": @"Dan",
                    @"numberWithDifferentJSONKey": @8,
                    @"integerNumber": @9,
                    @"nestedObject": [PFObject objectWithClassName:@"TestParseObject"]
                };
                parseObject = [PFObject objectWithClassName:@"TestParseObject"
                                                 dictionary:params];

                parseObject.objectId = @"objectId";

                object = (TestObject *)[MTLParseAdapter modelOfClass:TestObject.class fromParseObject:parseObject error:nil];
            });

            it(@"should have the same values for core Obj-C datatypes", ^{
                expect(object.name).to.equal(@"Dan");
            });

            it(@"should respect +JSONKeyPathsByPropertyKey", ^{
                expect(object.number).to.equal(@8);
            });

            it(@"should auto-unbox non-object types", ^{
                expect(object.integerNumber).to.equal(9);
            });

            it(@"should properly use value transformers", ^{
                expect(object.nestedObject).to.beInstanceOf(TestObject.class);
            });

            it(@"should not affect the generated object when mutating the original object", ^{
                parseObject[@"name"] = @"new name";
                expect(object.name).to.equal(@"Dan");
            });

            context(@"when a property is a special Parse property", ^{
                it(@"should not be set in the object dictionary", ^{
                    expect(parseObject[@"objectId"]).to.beNil;
                    expect(parseObject[@"parseClassName"]).to.beNil;
                    expect(parseObject[@"createdAt"]).to.beNil;
                    expect(parseObject[@"updatedAt"]).to.beNil;
                });

                it(@"should set the appropriate PFObject property", ^{
                    expect(parseObject.objectId).to.equal(@"objectId");
                    expect(parseObject.parseClassName).to.equal(@"TestParseObject");
                    expect(parseObject.createdAt).to.equal(object.createdAt);
                    expect(parseObject.updatedAt).to.equal(object.updatedAt);
                });
            });

            context(@"when there is no parseClassName set", ^{
                it(@"should default to the model class name", ^{
                    TestObject *obj = [[TestObject alloc] init];
                    PFObject *parseObj = [MTLParseAdapter parseObjectFromModel:obj error:nil];
                    expect(parseObj.parseClassName).to.equal(@"TestObject");
                });
            });

            context(@"when there is no model class given", ^{
                it(@"should infer class name from Parse class name", ^{
                    parseObject = [PFObject objectWithClassName:NSStringFromClass(TestObject.class)];
                    object = (TestObject *)[MTLParseAdapter modelFromParseObject:parseObject error:nil];
                    expect(object).to.beInstanceOf(TestObject.class);
                });
            });

            xcontext(@"when parsing fails", ^{
                it(@"should thread the error through", ^{
                });
            });
        });
    });

    describe(@"converting an array of objects", ^{
        describe(@"converting from model objects to Parse objects", ^{
            __block NSArray *objects, *parseObjects;

            beforeEach(^{
                TestObject *first, *second;

                first = [[TestObject alloc] init];
                first.name = @"First";

                second = [[TestObject alloc] init];
                second.name = @"Second";

                objects = @[first, second];
                parseObjects = [MTLParseAdapter parseObjectsFromModels:objects error:nil];
            });

            it(@"should have the same number of items in the array", ^{
                expect(parseObjects.count).to.equal(2);
            });

            it(@"should have only PFObjects", ^{
                for (id obj in parseObjects) {
                    expect(obj).to.beInstanceOf(PFObject.class);
                }
            });

            it(@"should maintain object ordering", ^{
                expect(parseObjects[0][@"name"]).to.equal(@"First");
                expect(parseObjects[1][@"name"]).to.equal(@"Second");
            });

            xcontext(@"when parsing any individual object fails", ^{
                it(@"should thread the error through", ^{
                });
            });

        });

        describe(@"converting from Parse objects to model objects", ^{
            __block NSArray *objects, *parseObjects;
            __block PFObject *first, *second;

            beforeEach(^{
                first = [PFObject objectWithClassName:@"Class"
                                           dictionary:@{@"name": @"First"}];
                second = [PFObject objectWithClassName:@"Class"
                                           dictionary:@{@"name": @"Second"}];

                parseObjects = @[first, second];
                objects = [MTLParseAdapter modelsOfClass:TestObject.class fromParseObjects:parseObjects error:nil];
            });

            it(@"should have the same number of items in the array", ^{
                expect(objects.count).to.equal(2);
            });

            it(@"should have only objects of the correct class", ^{
                for (id obj in objects) {
                    expect(obj).to.beInstanceOf(TestObject.class);
                }
            });

            it(@"should maintain object ordering", ^{
                TestObject *first = objects.firstObject;
                TestObject *second = objects.lastObject;
                expect(first.name).to.equal(@"First");
                expect(second.name).to.equal(@"Second");
            });

            context(@"when there is no model class given", ^{
                it(@"should infer class name from Parse class name", ^{
                    PFObject *parseObject = [PFObject objectWithClassName:NSStringFromClass(TestObject.class)];
                    parseObjects = @[parseObject];
                    objects = [MTLParseAdapter modelsFromParseObjects:parseObjects error:nil];
                    expect(objects.firstObject).to.beInstanceOf(TestObject.class);
                });
            });

            xcontext(@"when parsing any individual object fails", ^{
                it(@"should thread the error through", ^{
                });
            });
        });
    });
});

SpecEnd
