//
//  Const.h
//  FileBrower
//
//  Created by andy on 2020/2/28.
//  Copyright © 2020 andy. All rights reserved.
//

#ifndef Const_h
#define Const_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX (kScreenWidth >= 375.0f && kScreenHeight >= 812.0f && iPhone)
#define TITLE_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAV_HEIGHT self.navigationController.navigationBar.frame.size.height
#define TABBAR_EMPTY ((iPhoneX) ? 34.f : 0.f)

#endif /* Const_h */
