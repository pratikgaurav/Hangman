//
//  Protocols.h
//  Hangman
//
//  Created by CSCI 5737 on 11/15/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#ifndef Protocols_h
#define Protocols_h

@protocol WinningStatusDelegate
@required
-(void) didWin:(bool)win;
@end

#endif /* Protocols_h */
