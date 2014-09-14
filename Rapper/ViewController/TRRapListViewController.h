//
//  TRRapListViewController.h
//  Rapper
//
//  Created by 雪本大樹 on 2014/05/17.
//  Copyright (c) 2014年 tolve. All rights reserved.
//

#import "BaseViewController.h"

@interface TRRapListViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate>

@property IBOutlet UITableView *tableView;

@end
