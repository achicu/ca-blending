//
//  CustomView.m
//  CABlending
//
//  Created by Chiculita Alexandru on 10/19/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import "CustomView.h"
#import "DraggableLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomView

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    draggedLayer = nil;
    isDragging = NO;
    [self.layer setName:@"Root"];
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
    [self.layersTree registerForDraggedTypes:[NSArray arrayWithObject:@"com.adobe.DraggableLayer"]];
    [self.layersTree setDraggingSourceOperationMask:NSDragOperationMove forLocal:YES];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
    return YES;
}

- (void)makeBoxWithBackground:(CGColorRef)background andBorder:(CGColorRef)border withName:(NSString*)name
{
    DraggableLayer* layer = [[DraggableLayer alloc] init];
    [layer setBounds:CGRectMake(0, 0, 100, 100)];
    [layer setAnchorPoint:CGPointZero];
    [layer setBorderColor:border];
    [layer setBorderWidth:5];
    [layer setBackgroundColor:background];
    CIFilter* filter = [CIFilter filterWithName:@"CIDifferenceBlendMode"];
    [filter setName:@"CIDifferenceBlendMode"];
    [filter setDefaults];
    [layer setCompositingFilter:filter];
    [layer setName:name];
    
    [self.layer addSublayer:layer];
    
    [self.layersTree reloadData];
    [self.layersTree expandItem:nil expandChildren:YES];
}

- (IBAction)makeGreenBox:(id)sender
{
    CGColorRef red = CGColorCreateGenericRGB(1, 0, 0, 0.5);
    CGColorRef green = CGColorCreateGenericRGB(0, 1, 0, 1);
    [self makeBoxWithBackground:green andBorder:red withName:@"Green box"];
    CGColorRelease(red);
    CGColorRelease(green);
}

- (IBAction)makeBlueBox:(id)sender
{
    CGColorRef red = CGColorCreateGenericRGB(1, 0, 0, 0.5);
    CGColorRef blue = CGColorCreateGenericRGB(0, 0, 1, 1);
    [self makeBoxWithBackground:blue andBorder:red withName:@"Blue box"];
    CGColorRelease(red);
    CGColorRelease(blue);
}

- (IBAction)makeYellowBox:(id)sender
{
    CGColorRef red = CGColorCreateGenericRGB(1, 0, 0, 0.5);
    CGColorRef yellow = CGColorCreateGenericRGB(1, 1, 0, 1);
    [self makeBoxWithBackground:yellow andBorder:red withName:@"Yellow box"];
    CGColorRelease(red);
    CGColorRelease(yellow);
}

- (NSString*)indentation:(int)indent
{
    NSMutableString* result = [NSMutableString string];
    for (int i = 0; i < indent; ++i)
        [result appendString:@" "];
    return result;
}

- (IBAction)groupLayers:(id)sender
{
    CALayer* layer = self.layer;
    CALayer* groupLayer = [CALayer layer];
    [groupLayer setName:@"Group layer"];
    [groupLayer setBounds:CGRectZero];
    NSArray* layerList = [[layer sublayers] copy];
    for (CALayer* child in layerList) {
        // Do not include the previous groupping layers.
        if (![child isKindOfClass:[DraggableLayer class]])
            continue;
        [child removeFromSuperlayer];
        [groupLayer addSublayer:child];
    }
    [layer addSublayer:groupLayer];
    [self.layersTree reloadData];
    [self.layersTree expandItem:nil expandChildren:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self.window setAcceptsMouseMovedEvents:YES];
    [self.window makeFirstResponder:self];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self.window setAcceptsMouseMovedEvents:NO];
}

- (void)checkForNewLayerAt:(CGPoint)position
{
    CALayer* layer = self.layer;
    CALayer* hitLayer = nil;
    for (CALayer* child in layer.sublayers) {
        CGPoint newPosition = [layer convertPoint:position toLayer:child];
        if ([child containsPoint:newPosition])
            hitLayer = child;
    }
    if (hitLayer == draggedLayer)
        return;
    if (draggedLayer)
        [draggedLayer setBorderWidth:5];
    draggedLayer = hitLayer;
    if (!draggedLayer)
        return;
    [draggedLayer setBorderWidth:15];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (!draggedLayer)
        return;
    CGPoint delta = [theEvent locationInWindow];
    delta.x -= mouseStartPosition.x;
    delta.y -= mouseStartPosition.y;
    
    CGPoint position = startPosition;
    position.x += delta.x;
    position.y += delta.y;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    [draggedLayer setPosition:position];
    [CATransaction commit];
    
    [self.layersTree reloadItem:draggedLayer];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:self.window.contentView];
    [self checkForNewLayerAt:point];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    CGPoint point = [self convertPoint:[theEvent locationInWindow] fromView:self.window.contentView];
    [self checkForNewLayerAt:point];
    if (!draggedLayer)
        return;
    startPosition = [draggedLayer position];
    mouseStartPosition = [theEvent locationInWindow];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (!draggedLayer)
        return;
    draggedLayer = nil;
}


@end
