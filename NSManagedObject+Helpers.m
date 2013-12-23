/// Copyright © 2013 NeedMoreDesu desu@horishniy.org.ua
//
/// This program is free software. It comes without any warranty, to
/// the extent permitted by applicable law. You can redistribute it
/// and/or modify it under the terms of the Do What The Fuck You Want
/// To Public License, Version 2, as published by Sam Hocevar. See
/// http://www.wtfpl.net/ for more details.

#import "NSManagedObject+Helpers.h"
#import "NSManagedObjectContext+Helpers.h"
#import <objc/runtime.h>

@implementation NSManagedObject (Helpers)

+ (NSManagedObjectContext*)setupContext:(NSManagedObjectContext *)context
{
    if (!context)
        context = [NSManagedObjectContext fromAppDelegate];
    return context;
}

+ (NSEntityDescription*)setupEntity:(NSString*)entityName
                        withContext:(NSManagedObjectContext*)context;
{
    return [NSEntityDescription
            entityForName:
            entityName?
            entityName:
            NSStringFromClass([self class])
            inManagedObjectContext:context];
}

+ (id)temporaryObjectWithContext:(NSManagedObjectContext *)context
                          entity:(NSString *)entityName
{
    context = [NSManagedObject setupContext:context];
    NSEntityDescription *entity = [NSManagedObject
                                   setupEntity:entityName
                                   withContext:context];
    
    return [[NSManagedObject alloc]
            initWithEntity:entity
            insertIntoManagedObjectContext:nil];
}

- (id)temporaryObjectWithContext:(NSManagedObjectContext *)context
                          entity:(NSString *)entityName
{
    context = [NSManagedObject setupContext:context];
    NSEntityDescription *entity = [NSManagedObject
                                   setupEntity:entityName
                                   withContext:context];
    
    NSManagedObject *obj = [[NSManagedObject alloc]
                            initWithEntity:entity
                            insertIntoManagedObjectContext:nil];
    
    [obj setValuesForKeysWithDictionary:
     [self dictionaryWithValuesForKeys:
      [entity attributesByName].allKeys]];

    return obj;
}

- (id)insertToContext:(NSManagedObjectContext*)context
{
    context = [NSManagedObject setupContext:context];
    [context insertObject:self];
    return self;
}

+ (id)newObjectWithContext:(NSManagedObjectContext *)context
                    entity:(NSString*)entityName
{
    return [[self
            temporaryObjectWithContext:context
            entity:entityName]
            insertToContext:context];
}

- (id)newObjectWithContext:(NSManagedObjectContext *)context
                    entity:(NSString*)entityName
{
    return [[self
             temporaryObjectWithContext:context
             entity:entityName]
            insertToContext:context];
}

@end
