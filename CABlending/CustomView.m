//
//  CustomView.m
//  CABlending
//
//  Created by Chiculita Alexandru on 10/19/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (void)awakeFromNib
{
    draggedLayer = nil;
    isDragging = NO;
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
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

- (void)mouseDragged:(NSEvent *)theEvent
{
    if (isDragging) {
        if (!draggedLayer)
            return;
        CGPoint delta = [theEvent locationInWindow];
        delta.x -= mouseStartPosition.x;
        delta.y -= mouseStartPosition.y;
        
        CGPoint position = startPosition;
        position.x += delta.x;
        position.y += delta.y;
        [draggedLayer setPosition:position];
        return;
    }
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    CALayer* hitLayer = [self.layer hitTest:[self convertPointFromBacking:[theEvent locationInWindow]]];
    if (hitLayer == draggedLayer)
        return;
    if (draggedLayer)
        [draggedLayer setBorderWidth:5];
    draggedLayer = hitLayer;
    if (!draggedLayer)
        return;
    [draggedLayer setBorderWidth:15];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    if (!draggedLayer)
        return;
    isDragging = YES;
    startPosition = [draggedLayer position];
    mouseStartPosition = [theEvent locationInWindow];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    isDragging = NO;
    if (!draggedLayer)
        return;
    draggedLayer = nil;
}


@end
