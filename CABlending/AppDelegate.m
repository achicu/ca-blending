//
//  AppDelegate.m
//  CABlending
//
//  Created by Chiculita Alexandru on 10/19/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import "AppDelegate.h"
#import "DraggableLayer.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (IBAction)load:(id)sender
{
    DraggableLayer* layer = [[DraggableLayer alloc] init];
    [layer setBounds:CGRectMake(0, 0, 100, 100)];
    CGColorRef red = CGColorCreateGenericRGB(1, 0, 0, 0.5);
    CGColorRef green = CGColorCreateGenericRGB(0, 1, 0, 0.5);
    [layer setBorderColor:red];
    [layer setBorderWidth:5];
    [layer setBackgroundColor:green];
    CGColorRelease(red);
    CGColorRelease(green);
    
    [self.customView setWantsLayer:YES];
    [[self.customView layer] addSublayer:layer];
}

@end
