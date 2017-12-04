//
//  GuessWordDML.h
//  Hangman
//
//  Created by CSCI 5737 on 10/18/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuessWordDML : NSObject

+ (NSString *)fetchWordFromCategory: (NSString*)categoryname;
+ (bool)addWordWithWord:(NSString *)word category:(NSString *)category;
+ (bool)deleteWord:(NSString *)wordString;

@end
