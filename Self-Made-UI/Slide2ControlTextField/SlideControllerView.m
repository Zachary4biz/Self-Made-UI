//
//  SlideControllerView.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/28.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "SlideControllerView.h"
@interface SlideControllerView()<UITextFieldDelegate>
@property (nonatomic, strong)NSTimer *moveRightTimer;
@property (nonatomic, strong)NSTimer *moveLeftTimer;
@end

@implementation SlideControllerView

- (instancetype)initWithFrame:(CGRect)frame andTheTargetTextField:(UITextField *)aTextField
{
    if (self = [super initWithFrame:frame]) {
        //创造滑块
        CGRect frame4Square = CGRectMake(0.5*frame.size.width-0.5*frame.size.height,
                                         0,
                                         frame.size.height,
                                         frame.size.height);
        _square = [[UIView alloc]initWithFrame:frame4Square];
        _square.backgroundColor = [UIColor cyanColor];
        //给滑块添加各种手势
        //pan移动
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                              action:@selector(panGesture:)];
        [_square addGestureRecognizer:panGestureRecognizer];
        //doubletap双击
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                                    action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [_square addGestureRecognizer:doubleTapGestureRecognizer];
        
        //doubletap&tap 双击后单击
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                              action:@selector(tapAfterDoubleTap:)];
        [tapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        [_square addGestureRecognizer:tapGestureRecognizer];
        
        //长按选择
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                                                                                action:@selector(longPress:)];
        [_square addGestureRecognizer:longPressGestureRecognizer];
        
        //创造背景的滑动条
        CGRect frame4SlideBar = CGRectMake(0,
                                           2,
                                           frame.size.width,
                                           frame.size.height-2*2);
        _slideBar = [[UIView alloc]initWithFrame:frame4SlideBar];
        _slideBar.backgroundColor = [UIColor colorWithWhite:0.95
                                                      alpha:1.0];
        
        //
        [self addSubview:_slideBar];
        [self addSubview:_square];
        
        //获取一下
        self.targetTextField = aTextField;
        self.targetTextField.delegate = self;
    }
    return self;
}

#pragma mark 手势响应

#pragma mark pan移动滑块手势
//这个是用来记录每次调用到这个函数时，手指相比上一次移动了多少
static CGFloat recorder4SquareOffsetChange = 0.0;
/**
 滑块的pan手势

 @param aPanGestureRecognizer nil
 */
- (void)panGesture:(UIPanGestureRecognizer *)aPanGesture
{
    
    CGPoint gesturePoint = [aPanGesture translationInView:self.slideBar];
    if (fabsl(gesturePoint.x)<0.5*self.slideBar.frame.size.width){
        //滑动范围还在slideBar里面==>方块移动 ==> 光标也要移动
        self.square.transform = CGAffineTransformMakeTranslation(gesturePoint.x, 0);
        //获取当前的transform.tx相比于上一次偏移了多少
        recorder4SquareOffsetChange = self.square.transform.tx-recorder4SquareOffsetChange;
        //这个偏移量就设置为offset
        [self makeOffset:recorder4SquareOffsetChange onTextField:self.targetTextField];
        //移完了要记得更新recorder4SquareOffsetChange的记录为新的transform.tx
        recorder4SquareOffsetChange = self.square.transform.tx;
    }else if(gesturePoint.x>=0.5*self.slideBar.frame.size.width){
        //gesturePoint.x
        //滑动范围在slideBar右边==>方块停在了最右边==>光标自动向右移(预计这个offset大一点好，比如10)
        if (!self.moveRightTimer) {
            self.moveRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.08
                                                                   target:self
                                                                 selector:@selector(makeOffsetAutoIncreaseRight)
                                                                 userInfo:nil
                                                                  repeats:YES];
        }
    }else if(gesturePoint.x<=-0.5*self.slideBar.frame.size.width){
        //滑动范围在slideBar左边==>方块停在了最左边==>光标自动向左移
        if (!self.moveLeftTimer) {
            self.moveLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.08
                                                                  target:self
                                                                selector:@selector(makeOffsetAutoIncreaseLeft)
                                                                userInfo:nil
                                                                 repeats:YES];
        }
    }
    if (aPanGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.square.transform = CGAffineTransformIdentity;
        }];
        recorder4SquareOffsetChange = 0.0;
    }
}

#pragma mark doubleTap双击手势
//这两个是判断在双击全选之前，光标是在文本开头还是在文本末尾处
static int isHeadOfText = 0;
static int isTailOfText = 0;
/**
 双击选中全文

 @param aDoubleTap nil
 */
- (void)doubleTap:(UITapGestureRecognizer *)aDoubleTap
{
    //开始选中前光标距离文本末尾的offset
    NSInteger offset2End = [self.targetTextField offsetFromPosition:self.targetTextField.selectedTextRange.start
                                                   toPosition:self.targetTextField.endOfDocument];
    if (offset2End == 0) {
        //光标在末尾
        isTailOfText = 1;
    }else if(offset2End == [self.targetTextField offsetFromPosition:self.targetTextField.beginningOfDocument
                                                   toPosition:self.targetTextField.endOfDocument])
    {
        //光标在开头
        isHeadOfText = 1;
    }
    //选中范围设置为全文
    self.targetTextField.selectedTextRange = [self.targetTextField textRangeFromPosition:self.targetTextField.beginningOfDocument
                                                                  toPosition:self.targetTextField.endOfDocument];
}

#pragma mark DoubleTap&tap 双击后单击手势
/**
 双击选中全部之后，再单击
 依据全选之前光标的位置来确定这次单击是让光标移到开头还是末尾还是不动

 @param aTapGesture
 */
- (void)tapAfterDoubleTap:(UITapGestureRecognizer *)aTapGesture
{
    //文字总的长度
    NSInteger totalOffset = [self.targetTextField offsetFromPosition:self.targetTextField.beginningOfDocument
                                                    toPosition:self.targetTextField.endOfDocument];
    //当前选中的文字长度
    NSInteger currentOffset = [self.targetTextField offsetFromPosition:self.targetTextField.selectedTextRange.start
                                                      toPosition:self.targetTextField.selectedTextRange.end];
    if(totalOffset == currentOffset){
        //表示是已经双击选中过了
        if (isHeadOfText) {
            //双击前，光标在开头，那么现在就让光标去末尾
            self.targetTextField.selectedTextRange = [self.targetTextField textRangeFromPosition:self.targetTextField.endOfDocument
                                                                          toPosition:self.targetTextField.endOfDocument];
            //并重置
            isHeadOfText = 0;
        }else if (isTailOfText){
            //双击前，光标在末尾，现在就让光标去开头
            self.targetTextField.selectedTextRange = [self.targetTextField textRangeFromPosition:self.targetTextField.beginningOfDocument
                                                                          toPosition:self.targetTextField.beginningOfDocument];
            //并重置
            isTailOfText = 0;
        }
    }
    
}

#pragma mark LongPress长按选择手势
//初始化一个变量用来累每次增加的选择offset
- (void)longPress:(UILongPressGestureRecognizer *)aLongPress
{
    if (aLongPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
        self.slideBar.backgroundColor = [UIColor cyanColor];
    }else if (aLongPress.state == UIGestureRecognizerStateChanged){
        
        CGPoint gesturePoint = [aLongPress locationInView:self.slideBar];
        if (gesturePoint.x>0 && gesturePoint.x<self.slideBar.frame.size.width) {
            self.square.transform = CGAffineTransformMakeTranslation(gesturePoint.x-self.square.center.x, 0);
            [self makeSelectionWithOffset:self.square.transform.tx];
        }
    }
    if (aLongPress.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.square.transform = CGAffineTransformIdentity;
        }];
        self.slideBar.backgroundColor = [UIColor lightGrayColor];
        NSLog(@"结束长按");
    }
}

#pragma mark 一些方法
#pragma mark 移动光标
/*
 *判断移动的方向，因为系统有个默认的移动到最后再移就自动回到开头开始移，不希望有这个
 *所以判断一下，
 *如果aOffset是正数表示在往右移，那么距离末尾应该越来越近，即targetOffset2End越来越小
 *（反之，targetOffset2End应该越来越大，但是不用考虑这个，因为系统没有到开头再回到末尾这个毛病。）
 */
- (void)makeOffset:(NSInteger)aOffset onTextField:(UITextField *)textField
{
    UITextPosition *targetPosition = [textField positionFromPosition:textField.selectedTextRange.start offset:aOffset];
    //预计会移动到的位置距离末尾有多少个字符
    NSInteger targetOffset2End = [textField offsetFromPosition:targetPosition toPosition:textField.endOfDocument];
    //当前距离末尾还有多少个字符
    NSInteger currentRemainOffset2End = [textField offsetFromPosition:textField.selectedTextRange.start toPosition:textField.endOfDocument];
    NSLog(@"aOffset -- %ld",aOffset);
    NSLog(@"预计移动后距离末尾--%ld",targetOffset2End);
    NSLog(@"当前剩余--%ld",currentRemainOffset2End);
    if (aOffset>0) {
        //表示是应该向右边移动
        if (targetOffset2End > currentRemainOffset2End ) {
            //如果预计移动后距离末尾字符数大于现在还剩下的，说明超过了尾巴，要修改targetPosition为末尾就好了
            targetPosition = textField.endOfDocument;
        }
    }else{
        //向左边移不用管，系统默认移动到最左边也不会到textField的末尾处
    }
    textField.selectedTextRange = [textField textRangeFromPosition:targetPosition toPosition:targetPosition];
}

#pragma mark 滑块到达最右（左）处时，继续自动移动光标并且是加速的
//这里三个参数是用来配合我的加速函数用的，加速动画的函数就是取以1.2为底的对数
static int increasement4Offset = 0;
static float num4log = 1.2;
static int num4Increase = 1;

- (void)makeOffsetAutoIncreaseLeft
{
    if (self.square.frame.origin.x<=self.slideBar.frame.origin.x) {
        //当滑块在边界处时，自动移动
        increasement4Offset += num4Increase;
        [self makeOffset:-(int)(log(increasement4Offset)/log(num4log)) onTextField:self.targetTextField];
        NSLog(@"increasement %d  offset %d",increasement4Offset,(int)(log(increasement4Offset)/log(num4log)));
    }else{
        //当滑块已经不再边界处了，就不自动移动了
        increasement4Offset = 0;
        [_moveLeftTimer invalidate];
        _moveLeftTimer = nil;
    }
    
}
- (void)makeOffsetAutoIncreaseRight
{
    if (self.square.frame.origin.x>self.slideBar.frame.size.width - self.square.frame.size.width) {
        //当滑块在边界处时，自动移动
        increasement4Offset += num4Increase;
        [self makeOffset:(int)(log(increasement4Offset)/log(num4log)) onTextField:self.targetTextField];
        NSLog(@"increasement %d  offset %d",increasement4Offset,(int)(log(increasement4Offset)/log(num4log)));
    }else{
        //当滑块已经不再边界处了，就不自动移动了
        increasement4Offset = 0;
        [_moveRightTimer invalidate];
        _moveRightTimer = nil;
    }
    
}

#pragma mark 移动选择方法
- (void)makeSelectionWithOffset:(NSInteger)aOffset
{
    //    NSLog(@"aOffset--%ld",aOffset);
    //起始点
    UITextPosition *selectionBeginPosition;
    UITextPosition *targetPosition;
    if (aOffset>0) {
        //表示是应该向右边移动
        //光标向右移动那么就是向右选择，所以起始点应该是左边的，左边的是.start
        selectionBeginPosition = self.targetTextField.selectedTextRange.start;
        targetPosition = [self.targetTextField positionFromPosition:selectionBeginPosition offset:aOffset];
        //预计会移动到的位置距离末尾有多少个字符
        NSInteger targetOffset2End = [self.targetTextField offsetFromPosition:targetPosition toPosition:self.targetTextField.endOfDocument];
        //当前距离末尾还有多少个字符
        NSInteger currentRemainOffset2End = [self.targetTextField offsetFromPosition:self.targetTextField.selectedTextRange.start toPosition:self.targetTextField.endOfDocument];
        if (targetOffset2End >= currentRemainOffset2End ) {
            //如果预计移动后距离末尾字符数大于现在还剩下的，说明超过了尾巴，修改targetPosition为末尾就好了
            targetPosition = self.targetTextField.endOfDocument;
        }
    }else{
        //向左边移不用管，系统默认移动到最左边也不会到textField的末尾处
        //但是起始点就变了，向左选择，起始点应该是右边的.end
        //        NSLog(@"左移%ld个",aOffset);
        selectionBeginPosition = self.targetTextField.selectedTextRange.end;
        targetPosition = [self.targetTextField positionFromPosition:selectionBeginPosition offset:aOffset];
    }
    self.targetTextField.selectedTextRange = [self.targetTextField textRangeFromPosition:selectionBeginPosition
                                                                  toPosition:targetPosition];
    
    if (aOffset>0) {
        /*
         *这里特意放在selectedTextRange修改后再来修改UIFieldEditor的偏移量
         *不然SelectedTextRange一变又会改掉UIFieldEdito的偏移量
         */
        //向右边选择文字会出现field不会自动右移的情况
        
        NSString *selectedStr2BeginOfDocument = [self.targetTextField textInRange:[self.targetTextField textRangeFromPosition:self.targetTextField.beginningOfDocument
                                                                                                       toPosition:targetPosition]];
        //        NSLog(@"选中的文字是:\n%@",selectedStr2BeginOfDocument);
        CGSize strSize = [selectedStr2BeginOfDocument sizeWithAttributes:@{NSFontAttributeName:self.targetTextField.font}];
        //获取那个UIFieldEditor
        UIScrollView *theUIFieldEditorContentView;
        CGFloat offsetXShouldBe;
        for (id i in self.targetTextField.subviews)
        {
            if ([i class] == NSClassFromString(@"UIFieldEditor")) {
                theUIFieldEditorContentView = i;
            }
        }
        //修改UIFieldEditor的offset
        if (strSize.width - theUIFieldEditorContentView.frame.size.width) {
            offsetXShouldBe = strSize.width - theUIFieldEditorContentView.frame.size.width;
        }else{
            offsetXShouldBe = 0;
        }
        theUIFieldEditorContentView.contentOffset =CGPointMake(offsetXShouldBe,0);
    }
}

#pragma mark 检测是否有中文
//这个是因为如果有中文，当进入输入状态文字会下沉，所以判断如果有中文，在进入编辑状态让view上移一点
- (BOOL)isContainChineseCharacter:(NSString *)Str
{
    for (int i=0; i<[Str length]; i++) {
        int a = [Str characterAtIndex:i];
        if (a>0x4e00 && a<0x9fff) {
            return YES;
        }
    }
    return NO;
}

#pragma mark UITextFieldDelegate
//如果有中文，进入编辑时，让UIFieldEditor这个view上移一点
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIScrollView *theEditorView;
    if ([self isContainChineseCharacter:textField.text]) {
        for (UIScrollView *view in textField.subviews)
        {
            if ([view class] == NSClassFromString(@"UIFieldEditor")) {
                theEditorView = view;
            }
        }
    }
    theEditorView.contentOffset = CGPointMake(0, 3);
}
@end
