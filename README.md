# MTLParseAdapter

[![CI Status](http://img.shields.io/travis/lazerwalker/MTLParseAdapter.svg?style=flat)](https://travis-ci.org/lazerwalker/MTLParseAdapter)
[![Version](https://img.shields.io/cocoapods/v/MTLParseAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLParseAdapter)
[![License](https://img.shields.io/cocoapods/l/MTLParseAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLParseAdapter)
[![Platform](https://img.shields.io/cocoapods/p/MTLParseAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLParseAdapter)

MTLParseAdapter is a small class that lets you easily serialize and deserialize your app's model objects to and from Parse's `PFObject` class using [Mantle](https://github.com/Mantle/Mantle). 

## Why Might You Use This?

[Parse](https://parse.com)'s iOS library encourages you to model your data in one of two ways. You can use `PFObject` as a key-value store, similar to how one would use `NSDictionary`, but doing this you lose a lot of the convenience and type safety of properties. Alternatively, you can make your own domain objects subclass `PFObject`, but this is problematic for a number of reasons:

* You cannot gain functionality from subclassing a different class (such as Mantle's `MTLModel`).
* Depending on your app's structure, having your model objects be aware of how to persist to Parse may be a violation of the [single responsibility principle](https://en.wikipedia.org/wiki/Single_responsibility_principle). This isn't necessarily a problem in practice, but is still less than ideal.
* The implementation of Parse's SDK is not open-source, making it more difficult to debug issues that might arise. Minimizing the presence of `PFObject` in your object graph can help reduce any pain this might cause.
* If you want to switch to using a different backend, be it a different BaaS or your own servers, removing Parse from your application will necessitate modifications to your client domain objects.

`MTLParseAdapter` gives you a way to avoid these problems. It allows you to model your domain objects as `MTLModel` Mantle objects, and serialize them into `PFObject`s and back as needed.

It is modelled after and built on top of the JSON serialization functionality in [Mantle](https://github.com/Mantle/Mantle). If your domain objects are already `MTLModel` subclasses that conform to `MTLJSONSerializing`, no additional work should be needed to allow MTLParseAdapter to convert your objects to and from `PFObject`s. If you have used `MTLJSONAdapter` before, `MTLParseAdapter` will feel very familiar.


## Usage

In order to serialize your objects to and from `PFObject`s, they will need to (a) subclass `MTLModel` and (b) implement the `MTLJSONSerializing` protocol. For more information on this, check out the [Mantle documentation](https://github.com/Mantle/Mantle).

After doing this, you can use `MTLParseAdapter` to convert your model objects.

```objc
User *user = [[User alloc] init];
PFObject *parseObject = [MTLParseAdapter parseObjectFromModel:user error:&error];
```

```objc
PFObject *parseObject; // Fetched via a PFQuery, for instance
User *user = [MTLParseAdapter modelOfClass:User.class 
							fromParseObject:parseObject
							error:&error];
```

If your Parse class names are identical to the names of your Objective-C object classes, you can omit the model class when deserializing from `PFObject`

```objc
PFObject *parseObject = [PFObject objectWithClassName:@"User"];
User *user = [MTLParseAdapter modelFromParseObject:parseObject error:&error];
```

Equivalent methods exist to convert arrays of multiple objects of the same class.
```objc
User *user1 = [[User alloc] init];
User *user2 = [[User alloc] init];
NSArray *users = @[user1, user2];
PFObject *parseObject = [MTLParseAdapter parseObjectsFromModels:users error:&error];
```

```objc
PFObject *parseObject1 = [PFObject objectWithClassName:@"User"];
PFObject *parseObject2 = [PFObject objectWithClassName:@"User"];
NSArray *parseObjects = @[parseObject1, parseObject2];
User *user = [MTLParseAdapter modelsOfClass:User.class 
							fromParseObjects:parseObjects
							error:&error];
```

As above, there is also a `modelsFromParseObjects:` method that infers the Objective-C class of each `PFObject` based on its `parseClassName`.


## Installation

MTLParseAdapter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MTLParseAdapter"

It includes Mantle and Parse as dependencies.

## Author

Mike Lazer-Walker

michael@lazerwalker.com

@lazerwalker

## License

MTLParseAdapter is available under the MIT license. See the LICENSE file for more info.

