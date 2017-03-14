// 14 august 2015
#import "uipriv_darwin.h"

@interface labelView : NSTextView {
    uiLabel *libui_l;
}
- (id)initWithFrame:(NSRect)r label:(uiLabel *)l;
@end

struct uiLabel {
	uiDarwinControl c;
	NSTextView *textview;
	labelView *label;
};

@implementation labelView
- (id)initWithFrame:(NSRect)r label:(uiLabel *)l
{
	self = [super initWithFrame:r];
	if (self) {
		self->libui_l = l;
    }
    return self;
}

//- (void)drawRect:(NSRect)r
//{
//	CGContextRef c;
//	c = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextSetShouldSmoothFonts(c, true);
//	CGContextSetFillColorWithColor(c, [[self backgroundColor] CGColor]);
//	// CGContextSetFillColorWithColor(c, [[NSColor whiteColor] CGColor]);
//    CGContextFillRect(c, r);
//    // [super drawRect:r];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName,[self textColor], NSForegroundColorAttributeName, nil];
//
//    NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:[self stringValue] attributes: attributes];
//
//    [currentText drawAtPoint:NSMakePoint(0, 0)];
//}
//
//- (NSRect)drawingRectForBounds:(NSRect)rect
//{
//    NSRect r = NSMakeRect(rect.origin.x + 10, rect.origin.x + 10, rect.size.width + 10, rect.size.height + 10);
//    // [super drawingRectForBounds:r];
//    return r;
//}
@end

uiDarwinControlAllDefaults(uiLabel, textview)

char *uiLabelText(uiLabel *l)
{
	return uiDarwinNSStringToText([l->textview string]);
}

void uiLabelSetText(uiLabel *l, const char *text)
{
	[l->textview setString:toNSString(text)];
}

labelView *newLabel(NSString *str)
{
	uiLabel *l;

    // l = [[labelView alloc] initWithFrame:NSZeroRect label:l];
    l = [[labelView alloc] initWithFrame:NSMakeRect(0, 0, 100, 50) label:l];
	[l setString:@"testtesttest"];
	// [l setEditable:NO];
	// [l setSelectable:NO];
	// [l setBordered:NO];
	[l setDrawsBackground:YES];
	[l setWantsLayer:YES];
    [[l textContainer] setContainerSize:NSMakeSize(100, 50)];
	return l;
}

uiLabel *uiNewLabel(const char *text)
{
	uiLabel *l;

	uiDarwinNewControl(uiLabel, l);

	l->textview = newLabel(toNSString(text));
    l->label = l->textview;

	return l;
}

void uiLabelSetColor(uiLabel *l, uiDrawBrush *b)
{
	[l->textview setTextColor:[NSColor colorWithDeviceRed:b->R green:b->G blue:b->B alpha:b->A]];
}

void uiLabelSetBackground(uiLabel *l, uiDrawBrush *b)
{
	[l->textview setBackgroundColor:[NSColor colorWithDeviceRed:b->R green:b->G blue:b->B alpha:b->A]];
}

struct uiDrawTextFont {
	CTFontRef f;
};

void uiLabelSetFont(uiLabel *l, uiDrawTextFont *font)
{
    CTFontRef f = font->f;
	[l->textview setFont:f];
}
