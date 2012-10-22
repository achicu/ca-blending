//
//  CustomView.h
//  CABlending
//
//  Created by Chiculita Alexandru on 10/19/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomView : NSView
{
    CALayer* draggedLayer;
    CGPoint startPosition;
    CGPoint mouseStartPosition;
    BOOL isDragging;
}

- (IBAction)makeGreenBox:(id)sender;
- (IBAction)makeYellowBox:(id)sender;
- (IBAction)makeBlueBox:(id)sender;
- (IBAction)groupLayers:(id)sender;

@property (assign) IBOutlet NSOutlineView *layersTree;

@end
