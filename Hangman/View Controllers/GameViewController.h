//
//  GameViewController.h
//  Hangman
//
//  Created by CSCI 5737 on 9/27/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Protocols.h"

@interface GameViewController : UIViewController <UIAlertViewDelegate>
{
    int _curGuessCount;
    UIAlertView* _loseAlert;
    UIAlertView* _winAlert;
    NSArray* _titlesArray;
    
    AVAudioPlayer* _correctSoundPlayer;
    AVAudioPlayer* _wrongSoundPlayer;

}

@property (nonatomic, retain) NSString* guessWord;
@property (weak) id <WinningStatusDelegate> statusDelegate;

@end
