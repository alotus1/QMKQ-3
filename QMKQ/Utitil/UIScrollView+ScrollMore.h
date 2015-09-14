
#import <UIKit/UIKit.h>
//#import "MyRefresh.h"

@protocol UIScrollViewDataDelegate <NSObject>

@optional

- (void)addDataForUpdate;
- (void)addDataForAddNew;

@end

@interface UIScrollView (ScrollMore)

@property (nonatomic, assign) id<UIScrollViewDataDelegate> addDataDelegate;
//@property(nonatomic,strong) MyRefresh *refreshControl;
//- (void)addRefreshAndActionHandler:(void (^)(void))actionHandler;
//- (void)didFinishRefreshAnimation:(BOOL)animation;
//监测动画,MyRefresh
//- (void)checkToRefreshAnimation;

@property (nonatomic, strong) UIRefreshControl * refreshControl;
- (void)addRefreshControl;

// 监测更新
- (void)checkToUpdateDataWillBeginDecelerating;
- (void)checkToUpdateDataWillBeginDragging;
- (void)checkToUpdateDataDidEndDragging;

@end
