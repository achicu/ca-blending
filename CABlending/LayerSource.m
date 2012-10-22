//
//  LayerSource.m
//  CABlending
//
//  Created by Chiculita Alexandru on 10/21/12.
//  Copyright (c) 2012 Chiculita Alexandru. All rights reserved.
//

#import "LayerSource.h"

@interface ByRefLayerEncoder : NSObject <NSCoding>

@property (assign) CALayer* layer;

@end

@implementation ByRefLayerEncoder

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    //[aCoder encodeByrefObject:self.layer];
    [aCoder encodeInt64:(int64_t)self.layer forKey:@"layer"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
        self.layer = (__bridge CALayer*)(void*)[aDecoder decodeInt64ForKey:@"layer"];
    }
    return self;
}

- (id)initWithLayer:(CALayer*)layer
{
    if (self = [self init]) {
        self.layer = layer;
    }
    return self;
}

+ (ByRefLayerEncoder*)encoderWithLayer:(CALayer*)layer
{
    return [[ByRefLayerEncoder alloc] initWithLayer:layer];
}

@end

@implementation LayerSource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    NSLog(@"outlineView=%@ - numberOfChildrenOfItem=%@", outlineView, item);
    if (item == nil)
        return 1;
    return [[(CALayer*)item sublayers] count];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    NSLog(@"outlineView=%@ - isItemExpandable=%@", outlineView, item);
    if (item == nil)
        return YES;
    return [[(CALayer*)item sublayers] count];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSLog(@"outlineView=%@ - child=%ld - item=%@", outlineView, index, item);
    if (item == nil)
        return self.baseView.layer;
    return [[(CALayer*)item sublayers] objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    CALayer* layer = (CALayer*)item;
    if ([[tableColumn identifier] compare:@"name"] == NSOrderedSame) {
        return [layer name];
    } else if ([[tableColumn identifier] compare:@"bounds"] == NSOrderedSame) {
        CGRect bounds = [layer bounds];
        return [NSString stringWithFormat:@"%.2fx%.2f - %.2fx%.2f", bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height];
    } else if ([[tableColumn identifier] compare:@"position"] == NSOrderedSame) {
        CGPoint point = [layer position];
        return [NSString stringWithFormat:@"%.2fx%.2f", point.x, point.y];
    } else if ([[tableColumn identifier] compare:@"compositing-filter"] == NSOrderedSame) {
        if (![layer compositingFilter])
            return @"none";
        return [[layer compositingFilter] name];
    } else if ([[tableColumn identifier] compare:@"color"] == NSOrderedSame) {
        CGColorRef color = [layer backgroundColor];
        if (!color)
            return @"no color";
        NSMutableString* string = [NSMutableString stringWithString:@"("];
        const CGFloat* components = CGColorGetComponents(color);
        size_t count = CGColorGetNumberOfComponents(color);
        for (size_t i = 0; i < count; ++i) {
            if (i)
                [string appendString:@", "];
            [string appendFormat:@"%.2f", components[i]];
        }
        [string appendString:@")"];
        return string;
    }
    
    return [NSString string];
}

- (void)outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    CALayer* layer = (CALayer*)item;
    if ([[tableColumn identifier] compare:@"name"] == NSOrderedSame)
        [layer setName:object];
}

// Drag - drop

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id<NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
{
    NSData* data = [[info draggingPasteboard] dataForType:@"com.adobe.DraggableLayer"];
    if (!data)
        return NO;
    ByRefLayerEncoder* encoder = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!encoder)
        return NO;
    CALayer* layer = [encoder layer];
    CALayer* oldParent = [layer superlayer];
    NSLog(@"old parent is %@", oldParent);
    [layer removeFromSuperlayer];
    [item insertSublayer:layer atIndex:(unsigned)index];
    [outlineView reloadItem:oldParent reloadChildren:YES];
    [outlineView reloadItem:item reloadChildren:YES];
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id<NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    if (item == nil)
        return NSDragOperationNone;
    NSData* data = [[info draggingPasteboard] dataForType:@"com.adobe.DraggableLayer"];
    if (!data)
        return NO;
    ByRefLayerEncoder* encoder = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!encoder)
        return NO;
    CALayer* layer = [encoder layer];
    CALayer* newParent = (CALayer*)item;
    while (newParent) {
        if (newParent == layer)
            return NSDragOperationNone;
        newParent = [newParent superlayer];
    }
    return NSDragOperationMove;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pasteboard
{
    if (items.count != 1 || [items containsObject:self.baseView.layer])
        return NO;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[ByRefLayerEncoder encoderWithLayer:[items objectAtIndex:0]]];
    [pasteboard declareTypes:[NSArray arrayWithObject:@"com.adobe.DraggableLayer"] owner:self];
    [pasteboard setData:data forType:@"com.adobe.DraggableLayer"];
    return YES;
}

@end
