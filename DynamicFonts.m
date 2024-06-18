/**
 * Copyright (c) 2017-present, grassper. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the LICENSE file in the root
 * directory of this source tree.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "DynamicFonts.h"

@implementation DynamicFonts

RCT_EXPORT_MODULE();

- (void) loadFontWithData:(CGDataProviderRef) fontDataProvider callback:(RCTResponseSenderBlock)callback
{
  CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
  NSString *newFontName = (__bridge_transfer NSString *)CGFontCopyPostScriptName(newFont);

  if (newFontName && [UIFont fontWithName:newFontName size:16]) {
    CGFontRelease(newFont);
    CGDataProviderRelease(fontDataProvider);
    callback(@[[NSNull null], newFontName]);
    return;
  }

  CFErrorRef error;
  if (!CTFontManagerRegisterGraphicsFont(newFont, &error)) {
    CFStringRef errorDescription = CFErrorCopyDescription(error);
    NSLog(@"Failed to register font: %@", errorDescription);
    callback(@[[NSString stringWithFormat:@"Failed to register font: %@", (__bridge_transfer NSString *)errorDescription]]);
    CFRelease(errorDescription);
    CFRelease(error);
    CGFontRelease(newFont);
    CGDataProviderRelease(fontDataProvider);
    return;
  }

  CGFontRelease(newFont);
  CGDataProviderRelease(fontDataProvider);
  callback(@[[NSNull null], newFontName]);
}

RCT_EXPORT_METHOD(loadFont:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback)
{
  NSString *name = [options valueForKey:@"name"];
  NSString *data = [options valueForKey:@"data"];
  NSString *type = [options valueForKey:@"type"];
  
  if ([name isEqual:[NSNull null]] || [name length] == 0) {
    callback(@[@"Name property is empty"]);
    return;
  }

  if ([data isEqual:[NSNull null]] || [data length] == 0) {
    callback(@[@"Data property is empty"]);
    return;
  }

  if ([[[data substringWithRange:NSMakeRange(0, 5)] lowercaseString] isEqualToString:@"data:"]) {
    NSArray *parts = [data componentsSeparatedByString:@","];
    NSString *mimeType = parts[0];
    data = parts[1];

    if (![mimeType isEqual:[NSNull null]] && [mimeType length] > 0) {
      mimeType = [[[mimeType substringFromIndex:5] componentsSeparatedByString:@";"] objectAtIndex:0];

      if ([mimeType isEqualToString:@"application/x-font-ttf"] || 
          [mimeType isEqualToString:@"application/x-font-truetype"] ||
          [mimeType isEqualToString:@"font/ttf"]) {
        type = @"ttf";
      } else if ([mimeType isEqualToString:@"application/x-font-opentype"] || 
                 [mimeType isEqualToString:@"font/opentype"]) {
        type = @"otf";
      }
    }
  }

  if ([type isEqual:[NSNull null]] || [type length] == 0) {
    type = @"ttf";
  }

  NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
  CGDataProviderRef fontDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)decodedData);
  [self loadFontWithData:fontDataProvider callback:callback];
}

RCT_EXPORT_METHOD(loadFontFromFile:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback)
{
  NSString *name = [options valueForKey:@"name"];
  NSString *filePath = [options valueForKey:@"filePath"];
  NSString *type = [options valueForKey:@"type"];
  
  if ([name isEqual:[NSNull null]] || [name length] == 0) {
    callback(@[@"Name property is empty"]);
    return;
  }

  if ([filePath isEqual:[NSNull null]] || [filePath length] == 0) {
    callback(@[@"FilePath property is empty"]);
    return;
  }

  if ([type isEqual:[NSNull null]] || [type length] == 0) {
    type = @"ttf";
  }

  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    callback(@[@"Font file does not exist"]);
    return;
  }

  CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename(filePath.fileSystemRepresentation);
  if (!fontDataProvider) {
    callback(@[@"Failed to create font data provider"]);
    return;
  }

  [self loadFontWithData:fontDataProvider callback:callback];
}

@end