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

+ (PFObject *)parseObjectFromModel:(MTLModel <MTLJSONSerializing> *)model {
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:model];

    NSDictionary *parseParams = ASTPick(params, self.parseKeys);

    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams removeObjectsForKeys:self.parseKeys];
    params = [mutableParams copy];

    PFObject *object = [PFObject objectWithClassName:NSStringFromClass(model.class)
                                          dictionary:params];

    for (NSString *key in parseParams) {
        if (parseParams[key] != [NSNull null]) {
            [object setValue:parseParams[key] forKey:key];
        }
    }


    return object;
}

+ (id)modelOfClass:(Class)modelClass fromParseObject:(PFObject *)object {
    if (!object.isDataAvailable) return nil;

    NSArray *objectKeys = object.allKeys;
    NSArray *objectValues = ASTMap(objectKeys, ^id(id key) {
        return object[key];
    });

    NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] initWithObjects:objectValues forKeys:objectKeys];

    for (NSString *key in self.parseKeys) {
        id value = [object valueForKey:key];
        if (value != nil && value != [NSNull null]) {
            mutableParams[key] = value;
        }
    }

    id obj = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:mutableParams.copy error:nil];

    return obj;
}

+ (id)modelFromParseObject:(PFObject *)object {
    if (object.parseClassName == nil) return nil;
    return [self modelOfClass:NSClassFromString(object.parseClassName) fromParseObject:object];
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
