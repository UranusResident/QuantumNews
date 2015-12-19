//
//  ViewController.m
//  QuantumNews
//
//  Created by wangxinyan on 15/11/17.
//  Copyright (c) 2015年 longjiang. All rights reserved.
//

#import "ViewController.h"
#import "DWBubbleMenuButton.h"
#import "DKCircleButton.h"

#import "DetailNewsVC.h"

#import "MJExtension.h"
#import <AFHTTPRequestOperation.h>
#import <AFHTTPRequestOperationManager.h>


#import "dataRequest.h"


#import "MyTableViewCell.h"

#define OriginHight 250
#define Height 80.0f

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *tableView;
//毛玻璃效果的图片
@property(strong,nonatomic)UIImageView *imageview;

//毛玻璃页面“设置页面”
@property(strong,nonatomic)UIImageView *setImageview;
//数据数组
@property(strong,nonatomic)NSArray *array;

@end
//contentSize可滚动区域
@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
        //创建按钮菜单
    UILabel *HomeLabel=[self createHomeButtonView];
    //下面的展开按钮
    HomeLabel=[self createHomeButtonView];
    
    DWBubbleMenuButton *upmenuView=[[DWBubbleMenuButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - HomeLabel.frame.size.width - 20.f,  self.view.frame.size.height - HomeLabel.frame.size.height - 20.f,HomeLabel.frame.size.width, HomeLabel.frame.size.height) expansionDirection:DirectionUp];
    
    upmenuView.homeButtonView=HomeLabel;
    
    [upmenuView addButtons:[self createNewsButtonArray]];
    
    [self.view addSubview:upmenuView];
    


    
    
    //创建设置菜单按钮
    DKCircleButton *buttonSet=[[DKCircleButton alloc]initWithFrame:CGRectMake(10, 20, 35, 35)];
    buttonSet.center=CGPointMake(self.view.frame.size.width-30, 30);
    buttonSet.backgroundColor=[UIColor clearColor];
    [buttonSet addTarget:self action:@selector(SettingForBlur:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSet];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    //内容视图上下左右四个边扩展出去的大小
    self.tableView.contentInset = UIEdgeInsetsMake(OriginHight, 0, 0, 0);
    
    [self.view addSubview:self.tableView];
    
    self.ImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123.jpg"]];
    
    self.ImageView.frame = CGRectMake(0, -OriginHight -Height, self.tableView.frame.size.width, OriginHight + Height);
    
    [self.tableView addSubview:self.ImageView];
    self.tableView.showsVerticalScrollIndicator=NO;
    //下拉刷新？？
    
    
    
    //请求数据

        NSString *httpUrl = @"http://www.longxyun.com/AppData";
        NSString *httpName = @"sky.php";

        [self resquestData: httpUrl withHttpName:httpName];
 
}

-(void)resquestData:(NSString*)Url withHttpName:(NSString*)Name{
    NSString *str=[NSString stringWithFormat:@"%@/%@",Url,Name];
    NSURL *url=[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *html=operation.responseString;
        NSData *data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"%@",dict);
        [self jsonToModel:dict];
        
        //查看线程
        //NSThread *th=[NSThread currentThread];
        
        
        [self.tableView reloadData];//应该加在哪最好
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    

}
-(void)jsonToModel:(NSDictionary *)dic{
    //NSLog(@"dic:%@",dic);
    NSArray *arr=[dic objectForKey:@"data"];
    
    _array=[dataRequest objectArrayWithKeyValuesArray:arr];

//    for (dataRequest *da in array) {
//        NSLog(@"title:%@",da.titles);
//        
//    }

}

#pragma mark 上下两个按钮的方法
-(UILabel *)createHomeButtonView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
    
    label.text = @"In";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.frame.size.height / 2.f;
    label.backgroundColor =[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
    label.clipsToBounds = YES;
    
    return label;
    
}

-(NSArray *)createNewsButtonArray{
    
    NSMutableArray *ButtonsArray=[[NSMutableArray alloc]init];
    int i=0;
    for (NSString *title in @[@"热点",@"科技",@"社会",@"军事",@"时尚"]) {
        //UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        DKCircleButton *button=[[DKCircleButton alloc]init];
        //设置按钮属性
        button.center=CGPointMake(160, 200);
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.clipsToBounds = YES;
        button.tag = i++;
        
        [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        [ButtonsArray addObject:button];
        
    }
    return [ButtonsArray copy];

}

- (UIButton *)createButtonWithName:(NSString *)imageName {
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    
    [button addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)test:(UIButton *)sender{
    if (sender.tag==0) {
        //NSLog(@"热点");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *httpUrl = @"http://www.longxyun.com/AppData";
        NSString *httpName = @"sky.php";
        [self resquestData: httpUrl withHttpName:httpName];
            dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
            });
        });

    }else if (sender.tag==1){
        //NSLog(@"科技");
        //在子线程中请求数据
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
            NSString *httpUrl = @"http://www.longxyun.com/AppData";
            NSString *httpName = @"yooganews.php";
            [self resquestData: httpUrl withHttpName:httpName];
            //通知主线程来刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        });

    }else if (sender.tag==2){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
    NSString *httpUrl = @"http://www.longxyun.com/AppData";
    NSString *httpName = @"yooganews2.php";
    [self resquestData: httpUrl withHttpName:httpName];
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
        });
    });

    
    }else if (sender.tag==3){
        NSLog(@"军事");
    }else{
        NSLog(@"时尚");
    }
}

- (BOOL)prefersStatusBarHidden {
    return true;
}
//上方按钮的方法（毛玻璃效果）
-(void)SettingForBlur:(UIButton *)but{
    NSLog(@"弹出一个有毛玻璃效果的页面");
    _imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _imageview.contentMode=UIViewContentModeScaleAspectFit;
    _imageview.userInteractionEnabled=YES;
    [self.view addSubview:_imageview];
    
    //创建毛玻璃效果
    UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview=[[UIVisualEffectView alloc]initWithEffect:blur];
    effectview.frame=CGRectMake(0, 0, _imageview.frame.size.width, _imageview.frame.size.height);
    [_imageview addSubview:effectview];
    
    //关于“设置”的按钮
    DKCircleButton *settingBut=[[DKCircleButton alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    settingBut.center=CGPointMake(20, 20);
    settingBut.backgroundColor=[UIColor blueColor];
    [settingBut addTarget:self action:@selector(settingButton) forControlEvents:UIControlEventTouchUpInside];
    [effectview.contentView addSubview:settingBut];
    
    //退出毛玻璃页面的按钮
    DKCircleButton *reback=[[DKCircleButton alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    reback.center=CGPointMake(self.view.frame.size.width-20, 20);
    reback.backgroundColor=[UIColor blueColor];
    [reback addTarget:self action:@selector(ReBackMainVC) forControlEvents:UIControlEventTouchUpInside];
    [effectview.contentView addSubview:reback];
    
    //中间可以设置头像的imageview
    
    
}
-(void)settingButton{
    NSLog(@"设置");
    _setImageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _setImageview.contentMode=UIViewContentModeScaleAspectFit;
    _setImageview.userInteractionEnabled=YES;
    [self.imageview addSubview:_setImageview];
    
    //创建毛玻璃效果
    UIBlurEffect *blur2=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview2=[[UIVisualEffectView alloc]initWithEffect:blur2];
    effectview2.frame=CGRectMake(0, 0, _setImageview.frame.size.width, _setImageview.frame.size.height);
    [_setImageview addSubview:effectview2];
    
    //设置选项
    //语言、清除缓存、等等
    
    //退出毛玻璃页面的按钮
    DKCircleButton *reback2=[[DKCircleButton alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    reback2.center=CGPointMake(self.view.frame.size.width-20, 20);
    reback2.backgroundColor=[UIColor blueColor];
    [reback2 addTarget:self action:@selector(ReBackImageview) forControlEvents:UIControlEventTouchUpInside];
    [effectview2.contentView addSubview:reback2];

   
    
}
-(void)ReBackMainVC{
    NSLog(@"关闭");
    [self.imageview removeFromSuperview];
}
-(void)ReBackImageview{
    [self.setImageview removeFromSuperview];
}
#pragma mark 滑动效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //UIScrollView当前显示区域的定点相对于frame顶点的偏移量
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + OriginHight)/2;
    
    if (yOffset < -OriginHight) {
        
        CGRect f = self.ImageView.frame;
        
        f.origin.y = yOffset - Height;
        
        f.size.height =  -yOffset + Height;
        
        f.origin.x = xOffset;
        
        f.size.width = self.view.frame.size.width + fabsf(xOffset)*2;
        
        self.ImageView.frame = f;
        
    }
   
}
#pragma mark tableview的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_array count];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }

    cell.NumberImageView.image=[UIImage imageNamed:@"dot.png"];
    
    dataRequest *datas=_array[indexPath.row];
    cell.TitleLabel.text=[NSString stringWithFormat:@"%@",datas.titles];
    cell.ContentLabel.text=[NSString stringWithFormat:@"%@",datas.descriptions];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dataRequest *data=_array[indexPath.row];
    DetailNewsVC *dvc=[[DetailNewsVC alloc]initWithNibName:@"DetailNewsVC" bundle:nil];
    dvc.selectedData=data;
    [self presentViewController:dvc animated:NO completion:nil];
}
@end
