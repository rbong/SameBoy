#define GBLayoutInternal
#import "GBVerticalLayout.h"

@implementation GBVerticalLayout

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    CGSize resolution = self.resolution;
    
    CGRect screenRect = {0,};
    screenRect.size.width = self.hasFractionalPixels? resolution.width : floor(resolution.width / 160) * 160;
    screenRect.size.height = screenRect.size.width / 160 * 144;
    
    double screenBorderWidth = screenRect.size.width / 40;
    screenRect.origin.x = (resolution.width - screenRect.size.width) / 2;
    screenRect.origin.y = self.minY + screenBorderWidth * 2;
    self.screenRect = screenRect;
    
    double controlAreaStart = screenRect.origin.y + screenRect.size.height + screenBorderWidth * 2;
    
    self.selectLocation = (CGPoint){
        MIN(resolution.width / 4, 120 * self.factor),
        MIN(resolution.height - 80 * self.factor, (resolution.height - controlAreaStart) * 0.75 + controlAreaStart)
    };
    
    self.startLocation = (CGPoint){
        resolution.width - self.selectLocation.x,
        self.selectLocation.y
    };
        
    double buttonRadius = 36 * self.factor;
    CGSize buttonsDelta = [self buttonDeltaForMaxHorizontalDistance:resolution.width / 2 - buttonRadius * 2 - screenBorderWidth * 2];
    
    self.dpadLocation = (CGPoint) {
        self.selectLocation.x,
        self.selectLocation.y - 140 * self.factor
    };
    
    CGPoint buttonsCenter = {
        resolution.width - self.dpadLocation.x,
        self.dpadLocation.y,
    };
    
    self.aLocation = (CGPoint) {
        round(buttonsCenter.x + buttonsDelta.width / 2),
        round(buttonsCenter.y - buttonsDelta.height / 2)
    };
    
    self.bLocation = (CGPoint) {
        round(buttonsCenter.x - buttonsDelta.width / 2),
        round(buttonsCenter.y + buttonsDelta.height / 2)
    };
    
    double controlsTop = self.dpadLocation.y - 80 * self.factor;
    double middleSpace = self.bLocation.x - buttonRadius - (self.dpadLocation.x + 80 * self.factor);
    
    UIGraphicsBeginImageContextWithOptions(resolution, true, 1);
    [self drawBackground];
    [self drawScreenBezels];
    
    if (controlsTop - controlAreaStart > 24 * self.factor + screenBorderWidth * 2 ||
        middleSpace > 160 * self.factor) {
        [self drawLogoInVerticalRange:(NSRange){controlAreaStart + screenBorderWidth, 24 * self.factor}];
    }
    
    [self drawLabels];    
    
    self.background = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return self;
}

@end
