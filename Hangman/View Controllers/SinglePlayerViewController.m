//
//  SinglePlayerViewController.m
//  Hangman
//
//  Created by CSCI 5737 on 10/4/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "GuessWordDML.h"
#import "GameViewController.h"
#import "GuesswordDynamoDB.h"
#import "HistoryTableVC.h"

@interface SinglePlayerViewController ()
- (IBAction)historyBtnAction:(id)sender;

@end

@implementation SinglePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"Easy", @"Medium", @"Difficult", nil];
    _descArray = [[NSMutableArray alloc] initWithObjects:@"Pick from easy list of words", @"Pick from medium list of words", @"Pick from difficult list of words", nil];
    
    [self loadWordsIntoDatabase];
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
             initWithRegionType:AWSRegionUSEast1
                                                          identityPoolId:@"us-east-1:5e6604bd-c962-40a3-aefa-8226ae88bd20"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    
    _dynamoDBObjectMapper = [AWSDynamoDBObjectMapper defaultDynamoDBObjectMapper];

    _guesswordsHistory = [[NSMutableArray alloc] init];
    
    [self scanDynamoDBContents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadWordsIntoDatabase
{
    if ([GuessWordDML fetchWordFromCategory:@"Easy"] == nil)
    {
        NSString *easyPath = [[NSBundle mainBundle] pathForResource:@"Easy" ofType:@"plist"];
        NSMutableArray *easyArray = [[NSMutableArray alloc] initWithContentsOfFile:easyPath];
        for (int i=0; i<easyArray.count; i++)
        {
            NSString* curWord = (NSString *)[easyArray objectAtIndex:i];
            [GuessWordDML addWordWithWord:curWord category:@"Easy"];
        }
        NSString *mediumPath = [[NSBundle mainBundle] pathForResource:@"Medium" ofType:@"plist"];
        NSMutableArray *mediumArray = [[NSMutableArray alloc] initWithContentsOfFile:mediumPath];
        for (int i=0; i<mediumArray.count; i++)
        {
            NSString* curWord = (NSString *)[mediumArray objectAtIndex:i];
            [GuessWordDML addWordWithWord:curWord category:@"Medium"];
        }
        NSString *difficultPath = [[NSBundle mainBundle] pathForResource:@"Hard" ofType:@"plist"];
        NSMutableArray *difficultArray = [[NSMutableArray alloc] initWithContentsOfFile:difficultPath];
        for (int i=0; i<difficultArray.count; i++)
        {
            NSString* curWord = (NSString *)[difficultArray objectAtIndex:i];
            [GuessWordDML addWordWithWord:curWord category:@"Difficult"];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue is to GameVC
    if ([[segue identifier] isEqualToString:@"singleplayer2game"])
    {
        // Get reference to GameVC
        GameViewController *gameVC = [segue destinationViewController];
        
        // Pass guess word to GameVC
        gameVC.guessWord = _guessWord;
        gameVC.statusDelegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"singleplayer2history"])
    {
        // Get reference to HistoryVC
        HistoryTableVC *historyVC = [segue destinationViewController];
        
        // Pass history array to HistoryVC
        historyVC.dataArray = _guesswordsHistory;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    // Configure the cell...
    //cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    UILabel* mainLabel = [cell.contentView viewWithTag:1];
    mainLabel.text = [_dataArray objectAtIndex:indexPath.row];
    UILabel* descLabel = [cell.contentView viewWithTag:2];
    descLabel.text = [_descArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView * )tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* selectedCategory = [_dataArray objectAtIndex:indexPath.row];
    _guessWord = [GuessWordDML fetchWordFromCategory:selectedCategory ];
    [GuessWordDML deleteWord:_guessWord];

    [self performSegueWithIdentifier:@"singleplayer2game" sender:self];
    
    GuesswordDynamoDB *gWord = [GuesswordDynamoDB new];
    gWord.word = _guessWord;
    gWord.category = selectedCategory;
    
    [[_dynamoDBObjectMapper save:gWord]
     continueWithBlock:^id(AWSTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error: [%@]", task.error);
         } else {
             //Do something with task.result or perform other operations.
         }
         return nil;
     }];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didWin:(bool)win {
    if (win) {
        self.navigationItem.title = @"Last attempt: WIN";
    }
    else {
        self.navigationItem.title = @"Last attempt: LOSE";
    }
}

- (void) scanDynamoDBContents {
    [_guesswordsHistory removeAllObjects];
    AWSDynamoDBScanExpression *scanExpression = [AWSDynamoDBScanExpression new];
    
    [[_dynamoDBObjectMapper scan:[GuesswordDynamoDB class]
                      expression:scanExpression]
     continueWithBlock:^id(AWSTask *task) {
         if (task.error) {
             NSLog(@"The request failed. Error: [%@]", task.error);
         } else {
             AWSDynamoDBPaginatedOutput *paginatedOutput = task.result;
             for (GuesswordDynamoDB *dbGuessword in paginatedOutput.items) {
                 //Do something with guessword object.
                 [_guesswordsHistory addObject:dbGuessword];
             }
             
         }
         
         return nil;
         
     }];
}

- (IBAction)historyBtnAction:(id)sender {
    [self performSegueWithIdentifier:@"singleplayer2history" sender:self];
}






@end
