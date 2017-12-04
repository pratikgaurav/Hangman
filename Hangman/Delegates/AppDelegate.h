//
//  AppDelegate.h
//  Hangman
//
//  Created by CSCI 5737 on 9/27/17.
//  Copyright © 2017 CSCI 5737. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

