//
//  InviteFriendsViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@interface ServiceListInfo : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *value;

@end
