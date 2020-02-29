//
//  FileBrowserViewController.h
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 meliora.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^fileParamBlock)(NSDictionary *dic);

@interface FileBrowserViewController : UIViewController

- (void)setFileBlock:(fileParamBlock)block;

@end

NS_ASSUME_NONNULL_END
