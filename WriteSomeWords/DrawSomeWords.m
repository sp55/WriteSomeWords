//
//  DrawSomeWords.m
//  WriteSomeWords
//
//  Created by admin on 16/1/28.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "DrawSomeWords.h"
#import <CoreText/CoreText.h>
#define kSrceenWidth  [UIScreen mainScreen].bounds.size.width
#define kSrceenHeight [UIScreen mainScreen].bounds.size.height
#define RGBAColor(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]

@interface DrawSomeWords ()
@property(strong,nonatomic)CAShapeLayer *shapeLayer;

@end
@implementation DrawSomeWords

-(void)showWordsOnView:(UIView *)view string:(NSString *)string
{
    CGMutablePathRef letters = CGPathCreateMutable();
    //这里设置画线的字体和大小
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id _Nonnull)((__bridge CTFontRef)[UIFont systemFontOfSize:40.]), kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    CGPathRelease(letters);
    
    
    //layer
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, kSrceenHeight/4, kSrceenWidth, kSrceenHeight/2);
    _shapeLayer.geometryFlipped = YES;
    _shapeLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    _shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.path = path.CGPath;
    [view.layer addSublayer:_shapeLayer];
    
    
    //animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.delegate = self;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [_shapeLayer addAnimation:pathAnimation forKey:nil];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    _shapeLayer.fillColor = [RGBAColor(254, 67, 101) CGColor];

}



@end
