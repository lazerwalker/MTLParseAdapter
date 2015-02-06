//
//  MTLParseAdapter.m
//  Pods
//
//  Created by Michael Walker on 2/6/15.
//
//

#import <Asterism/Asterism.h>
#import <Mantle/Mantle.h>
#import <Parse/Parse.h>

#import "MTLParseAdapter.h"

@implementation MTLParseAdapter

+ (NSArray *)parseKeys {
    // TODO: ACL
    return @[@"objectId",
             @"createdAt",
             @"updatedAt",
             @"parseClassName"];
}

#pragma mark - GGLike
+ (PFObject *)parseObjectFromModel:(MTLModel <MTLJSONSerializing> *)model {
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:model];

    NSDictionary *parseParams = ASTPick(params, self.parseKeys);

    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams removeObjectsForKeys:self.parseKeys];
    params = [mutableParams copy];

    PFObject *object = [PFObject objectWithClassName:NSStringFromClass(model.class)
                                          dictionary:params];

    if (parseParams[@"objectId"] != [NSNull null]) {
        object.objectId = parseParams[@"objectId"];
    }

    return object;
}

#pragma mark - Private
+ (id)modelOfClass:(Class)modelClass fromParseObject:(PFObject *)object {
    if (!object.isDataAvailable) return nil;

    NSArray *objectKeys = object.allKeys;
    NSArray *objectValues = ASTMap(objectKeys, ^id(id key) {
        return object[key];
    });

    NSArray *parseValues = ASTMap(self.parseKeys, ^id(id key) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL selector = NSSelectorFromString(key);
        return [object performSelector:selector];
#pragma clang diagnostic pop
    });

    NSArray *keys = [objectKeys arrayByAddingObjectsFromArray:self.parseKeys];
    NSArray *values = [objectValues arrayByAddingObjectsFromArray:parseValues];

    NSDictionary *params = [[NSDictionary alloc] initWithObjects:values forKeys:keys];

    id obj = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:params error:nil];

    return obj;
}

#pragma mark - Array methods
+ (NSArray *)modelsOfClass:(Class)modelClass
          fromParseObjects:(NSArray *)models {
    return ASTMap(models, ^id(PFObject *obj) {
        return [self modelOfClass:modelClass fromParseObject:obj];
    });
}

+ (NSArray *)parseObjectsFromModels:(NSArray *)models {
    return ASTMap(models, ^id(id model) {
        return [self parseObjectFromModel:model];
    });
}

@end
