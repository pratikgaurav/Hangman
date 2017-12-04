//
//  GuessWordDML.m
//  Hangman
//
//  Created by CSCI 5737 on 10/18/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import "GuessWordDML.h"
#import "AppDelegate.h"
#import "Guessword+CoreDataClass.h"

@implementation GuessWordDML

+ (NSManagedObjectContext *) getManagedObjectContext
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.persistentContainer.viewContext;
}

+ (NSString *)fetchWordFromCategory: (NSString*)categoryname
{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Guessword" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category=%@", categoryname];
    [request setPredicate:predicate];
    // Define how we will sort the records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"word" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    NSString* retStr = nil;
    if (!mutableFetchResults)
    {
        return nil;
    }
    else
    {
        if([mutableFetchResults count] > 0)
        {
            int indexOfRandomWord = arc4random() % [mutableFetchResults count];
            Guessword *guessWordObj = [mutableFetchResults objectAtIndex:indexOfRandomWord];
            retStr = [NSString stringWithFormat:@"%@",guessWordObj.word];
        }
    }
    return retStr;
}

+ (bool)addWordWithWord:(NSString *)word category:(NSString *)category
{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    //Create a blank new record
    Guessword *guessWordObj = (Guessword *)[NSEntityDescription insertNewObjectForEntityForName:@"Guessword" inManagedObjectContext:context];
    //Fill the new record
    [guessWordObj setWord:word];
    [guessWordObj setCategory:category];
    //Save the new record
    NSError *error;
    if(![context save:&error])
    {
        return false;
    }
    else
    {
        return true;
    }
}

+ (bool)deleteWord:(NSString *)wordString
{
    //Get managed object context
    NSManagedObjectContext* context =[[self class] getManagedObjectContext];
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Guessword" inManagedObjectContext:context];
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word=%@", wordString];
    [request setPredicate:predicate];
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if(mutableFetchResults.count > 0)
    {
        NSManagedObject *managedObject = [mutableFetchResults objectAtIndex:0];
        [context deleteObject:managedObject];
        if (![context save:&error])
        {
            return false;
        }
    }
    return true;
}


@end
