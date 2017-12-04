//
//  SinglePlayerViewController.h
//  Hangman
//
//  Created by CSCI 5737 on 10/4/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
#import <AWSDynamoDB/AWSDynamoDB.h>

@interface SinglePlayerViewController : UITableViewController <WinningStatusDelegate>
{
    NSMutableArray* _dataArray;
    NSString* _guessWord;
    NSMutableArray* _descArray;
    AWSDynamoDBObjectMapper *_dynamoDBObjectMapper;
    NSMutableArray* _guesswordsHistory;

}

@end
