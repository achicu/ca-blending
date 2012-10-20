//
//  AppDelegate.h
//  CABlending
//
//  Created by Chiculita Alexandru on 10/19/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomView.h"
#import "MainView.h"
#import "MainWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet MainWindow *window;
@property (assign) IBOutlet MainView *mainView;
@property (assign) IBOutlet CustomView *customView;

- (IBAction)load:(id)sender;

@end
