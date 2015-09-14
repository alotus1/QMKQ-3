
#import "UIScrollView+ScrollMore.h"
#import <objc/runtime.h>
#import <Accelerate/Accelerate.h>



static char UIScrollViewDataDelegate;
static char RefreshControlKey;

@interface UIScrollView () <UIScrollViewDelegate>



@end

@implementation UIScrollView (ScrollMore)

- (void)setAddDataDelegate:(id<UIScrollViewDataDelegate>)addDataDelegate
{
    self.alwaysBounceVertical=YES;
    [self willChangeValueForKey:@"UIScrollViewDataDelegate"];
    objc_setAssociatedObject(self, &UIScrollViewDataDelegate,
                             addDataDelegate,
                             OBJC_ASSOCIATION_ASSIGN);
    
    [self didChangeValueForKey:@"UIScrollViewDataDelegate"];
}

- (id<UIScrollViewDataDelegate>)addDataDelegate {
    return objc_getAssociatedObject(self, &UIScrollViewDataDelegate);
}

- (void)setRefreshControl:(UIRefreshControl *)refreshControl
{
    [self willChangeValueForKey:@"RefreshControlKey"];
    objc_setAssociatedObject(self, &RefreshControlKey,
                             refreshControl,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self didChangeValueForKey:@"RefreshControlKey"];
}

- (UIRefreshControl *)refreshControl {
    return objc_getAssociatedObject(self, &RefreshControlKey);
}

//- (void)setRefreshControl:(MyRefresh *)refreshControl
//{
//    [self willChangeValueForKey:@"RefreshControlKey"];
//    objc_setAssociatedObject(self, &RefreshControlKey,
//                             refreshControl,
//                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    
//    [self didChangeValueForKey:@"RefreshControlKey"];
//}
//
//- (MyRefresh *)refreshControl {
//    return objc_getAssociatedObject(self, &RefreshControlKey);
//}


//- (void)addRefreshAndActionHandler:(void (^)(void))actionHandler
//{
//    self.alwaysBounceVertical = YES;
//    self.refreshControl=[[MyRefresh alloc]initWithFrame:CGRectMake(0, -RefreshInsectY, [UIScreen mainScreen].bounds.size.width, RefreshInsectY)];
//    self.refreshControl.scrollView=self;
//    self.refreshControl.originalContentInsectY=RefreshInsectY;
//    self.refreshControl.pullToRefreshActionHandler=actionHandler;
//    [self addSubview:self.refreshControl];
//}
//
//- (void)didFinishRefreshAnimation:(BOOL)animation
//{
//    if (animation) {
//        [self.refreshControl performSelector:@selector(endLoading) withObject:nil afterDelay:0.5];
//    }else {
//        [self.refreshControl endLoading];
//    }
//}

- (void)addRefreshControl
{
    self.refreshControl=[[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshStatus) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.refreshControl];
}

- (void)refreshStatus
{
    if (self.refreshControl.isRefreshing) {
        if ([self.addDataDelegate respondsToSelector:@selector(addDataForUpdate)]) {
            [self.addDataDelegate addDataForUpdate];
        }
    }
}


- (void)checkToUpdateDataWillBeginDecelerating
{
    if (self.contentSize.height-self.contentOffset.y<3*self.frame.size.height&&self.contentSize.height>self.frame.size.height) {
        //添加
        if ([self.addDataDelegate respondsToSelector:@selector(addDataForAddNew)]) {
            [self.addDataDelegate addDataForAddNew];
        }
    }
}

- (void)checkToUpdateDataWillBeginDragging
{
    if (self.contentSize.height-self.contentOffset.y<3*self.frame.size.height&&self.contentSize.height-self.contentOffset.y>0&&self.contentSize.height>self.frame.size.height) {
        //添加
        if ([self.addDataDelegate respondsToSelector:@selector(addDataForAddNew)]) {
            [self.addDataDelegate addDataForAddNew];
        }
    }
}

- (void)checkToUpdateDataDidEndDragging
{
        CGPoint p = self.contentOffset;
        CGFloat tvSmallHeight = self.contentSize.height;
        if (tvSmallHeight-p.y-self.frame.size.height<50) {
            //添加
            if ([self.addDataDelegate respondsToSelector:@selector(addDataForAddNew)]) {
                [self.addDataDelegate addDataForAddNew];
            }
        }
}



@end



