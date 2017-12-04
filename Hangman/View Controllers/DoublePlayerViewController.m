//
//  DoublePlayerViewController.m
//  Hangman
//
//  Created by CSCI 5737 on 9/27/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import "DoublePlayerViewController.h"
#import "GameViewController.h"


@interface DoublePlayerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *guessWordTextField;

- (IBAction)menuButtonAction:(id)sender;
- (IBAction)playButtonAction:(id)sender;

@end

@implementation DoublePlayerViewController

@synthesize myObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[_guessWordTextField becomeFirstResponder];
    
    NSObject* tempObj = [[NSObject alloc] init];
    myObj = tempObj;
    tempObj = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)playButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"doubleplayer2game" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue is to GameVC
    if ([[segue identifier] isEqualToString:@"doubleplayer2game"])
    {
        // Get reference to GameVC
        GameViewController *gameVC = [segue destinationViewController];
        
        // Pass guess word to GameVC
        gameVC.guessWord = _guessWordTextField.text;
        gameVC.statusDelegate = self;
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [_guessWordTextField resignFirstResponder];
    return true;
}


- (void)didWin:(bool)win {
    if (win) {
        self.navigationItem.title = @"Last attempt: WIN";
    }
    else {
        self.navigationItem.title = @"Last attempt: LOSE";
    }
}



@end
