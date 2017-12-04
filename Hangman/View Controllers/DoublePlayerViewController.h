//
//  DoublePlayerViewController.h
//  Hangman
//
//  Created by CSCI 5737 on 9/27/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface DoublePlayerViewController : UIViewController <UITextFieldDelegate, WinningStatusDelegate>

@property (weak) NSObject* myObj;

@end
