//
//  SyntaxHighlightTextStorage.m
//  TextKitNotepad
//
//  Created by April Lee on 2014/12/31.
//  Copyright (c) 2014年 Colin Eberhardt. All rights reserved.
//

#import "SyntaxHighlightTextStorage.h"

@implementation SyntaxHighlightTextStorage
{
    NSMutableAttributedString *_backingStore;
    NSDictionary * _replacement;
}

-(id)init
{
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
        [self createHightlightPatterns];
    }
    return self;
}

-(NSString *)string
{
    return [_backingStore string];
}

-(NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

-(void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharactersInRange:%@ withString:%@",NSStringFromRange(range),str);
    
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}

-(void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@",attrs,NSStringFromRange(range));
    
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

-(void)processEditing
{
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

-(void)performReplacementsForRange:(NSRange)changedRange
{
    NSRange extenedRange =  NSUnionRange(changedRange, [[_backingStore string]lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extenedRange = NSUnionRange(changedRange, [[_backingStore string]lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    
    [self applyStylesToRange:extenedRange];
    
}

-(void)applyStylesToRange:(NSRange)searchRange
{
    NSDictionary *normalAttrs = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    
    //iterate over each replacement
    for (NSString *key in _replacement) {
        NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:key options:0 error:nil];
        
        NSDictionary *attributes = _replacement[key];
        [regex enumerateMatchesInString:[_backingStore string] options:0 range:searchRange
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 //apply the style
                                 NSRange matchRange = [result rangeAtIndex:1];
                                 [self addAttributes:attributes range:matchRange];
                                 
                                 //reset the style to the original
                                 if (NSMaxRange(matchRange)+1 < self.length) {
                                     [self addAttributes:normalAttrs range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                                 }
                             }];
    }
    
 /*
   //create some fonts
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    UIFont *boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size:0.0];
    UIFont *normalFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    //match items surrounded by asterisks
    NSString *regeStr = @"(\\*\\w+(\\s\\w+)*\\*)\\s";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regeStr options:0 error:nil];
    
    NSDictionary *boldAttributes = @{NSFontAttributeName : boldFont};
    NSDictionary *normalAttributes = @{NSFontAttributeName : normalFont};
    
    //iterate over each match, making the text bold
    [regex enumerateMatchesInString:[_backingStore string] options:0 range:searchRange
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                             NSRange matchRange = [result rangeAtIndex:1];
                             [self addAttributes:boldAttributes range:matchRange];
                             
                             //reset the style to the original
                             if (NSMaxRange(matchRange)+1 < self.length) {
                                 [self addAttributes:normalAttributes range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                             }
                             
                         }];
  */
}

-(void) createHightlightPatterns{
    UIFontDescriptor *scriptFontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:@"Zapfino"}];
    //base our script font on the preferred body font size
    UIFontDescriptor *bodyFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFontDescriptor.fontAttributes[UIFontDescriptorSizeAttribute];
    UIFont *scriptFont = [UIFont fontWithDescriptor:scriptFontDescriptor size:[bodyFontSize floatValue]];
    
    // create the attributes
    NSDictionary *boldAttributes = [self createAttributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitBold];
    NSDictionary *italicAttributes = [self createAttributesForFontStyle:UIFontTextStyleBody withTrait:UIFontDescriptorTraitItalic];
    
    NSDictionary *strikeThroughAttributes = @{NSStrikethroughStyleAttributeName : @1};
    NSDictionary *scriptAttributes = @{NSFontAttributeName:scriptFont};
    NSDictionary *redTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
    
    //contruct a dictionary of replacement based on regexes
    _replacement = @{
                     @"(\\*\\w+(\\s\\w+)*\\*)\\s" :boldAttributes,
                     @"(_\\w+(\\s\\w+)*_)\\s" : italicAttributes,
                     @"([0-9]+\\.)\\s" : boldAttributes,
                     @"(-\\w+(\\s\\w+)*-)\\s" :strikeThroughAttributes,
                     @"(~\\w+(\\s\\w+)*~)\\s" : scriptAttributes,
                     @"\\s([A-Z]{2,})\\s" :redTextAttributes };
}


-(NSDictionary *)createAttributesForFontStyle:(NSString *)style withTrait:(uint32_t)trait
{
    UIFontDescriptor *fontDecriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor * descriptorWithTrait = [fontDecriptor fontDescriptorWithSymbolicTraits:trait];
    
    UIFont *font = [UIFont fontWithDescriptor:descriptorWithTrait size:0.0];
    return @{NSFontAttributeName :font};
}

-(void)update{
    //update the highlight patterns
    [self createHightlightPatterns];
    
    //change the 'global' font
    NSDictionary *bodyFont = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    [self addAttributes:bodyFont range:NSMakeRange(0, self.length)];
    
    //re-apply the regex matches
    [self applyStylesToRange:NSMakeRange(0, self.length)];
}

@end
