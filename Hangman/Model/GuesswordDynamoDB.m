//
//  GuesswordDynamoDB.m
//  Hangman
//
//  Created by CSCI 5737 on 11/27/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import "GuesswordDynamoDB.h"

@implementation GuesswordDynamoDB

+ (NSString *)dynamoDBTableName {
    return @"Guessword";
}

+ (NSString *)hashKeyAttribute {
    return @"word";
}

@end

