//
//  Person.m
//  Gifter
//
//  Created by samanthaburak on 7/13/21.
//

#import "Person.h"

@implementation Person

@dynamic name;
@dynamic interests;
@dynamic giftSuggestions;

+ (nonnull NSString *)parseClassName {
    return @"Person";
}

+ (void)createPerson: ( NSString * _Nullable )name withInterests: ( NSMutableArray * _Nullable )interests withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Person *newPerson = [Person new];
    newPerson.name = name;
    newPerson.interests = interests;
    
    [newPerson saveInBackgroundWithBlock: completion];
}

- (NSMutableArray *)getInterests {
    return self.interests;
}

@end

