//
//  GuesswordDynamoDB.h
//  Hangman
//
//  Created by CSCI 5737 on 11/27/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import <AWSDynamoDB/AWSDynamoDB.h>

@interface GuesswordDynamoDB : AWSDynamoDBObjectModel <AWSDynamoDBModeling>
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *category;

@end

