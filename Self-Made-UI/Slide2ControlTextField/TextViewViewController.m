//
//  TextViewViewController.m
//  Self-Made-UI
//
//  Created by 周桐 on 16/12/29.
//  Copyright © 2016年 周桐. All rights reserved.
//

#import "TextViewViewController.h"
#import "SetUpAboutKeyboard.h"

@interface TextViewViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *functionView;
@property (weak, nonatomic) IBOutlet UIView *slideBar;
@property (weak, nonatomic) IBOutlet UIView *square;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *functionalBtn1;
- (IBAction)functionalBtn1:(id)sender;
- (IBAction)functionalBtn2:(id)sender;
- (IBAction)functionalBtn3:(id)sender;
- (IBAction)functionalBtn4:(id)sender;


@property (nonatomic, assign) CGFloat squareOffset;
@property (nonatomic, assign) CGFloat squareOriginalX;
//@property (nonatomic, strong) NSOperation *moveRightOperation;
//@property (nonatomic, strong) NSOperation *moveLeftOperation;
//@property (nonatomic, assign) NSRunLoop *moveRightRunLoop;
//@property (nonatomic, assign) CFRunLoopRef moveLeftRunLoop;
@property (nonatomic, strong) NSOperationQueue *moveRightQueue;
@property (nonatomic, strong) NSOperationQueue *moveLeftQueue;

@property (nonatomic, strong) NSTimer *moveLeftTimer;
@property (nonatomic, strong) NSTimer *moveRightTimer;
@end

@implementation TextViewViewController

- (CGFloat)squareOffset
{
    _squareOffset = _square.frame.origin.x - _squareOriginalX;
    return _squareOffset;
}

- (NSTimer *)moveLeftTimer
{
    if (!_moveLeftTimer) {
        _moveLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(makeOffsetAutoIncreaseLeft) userInfo:nil repeats:YES];
    }
    return _moveLeftTimer;
}

- (NSTimer *)moveRightTimer
{
    if (!_moveRightTimer) {
        _moveRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(makeOffsetAutoIncreaseRight) userInfo:nil repeats:YES];
    }
    return _moveRightTimer;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    //拖拽移动光标
    UIPanGestureRecognizer *aPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.square addGestureRecognizer:aPanGesture];
    
    //双击全选
    UITapGestureRecognizer *aDoubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [aDoubleTapGesture setNumberOfTapsRequired:2];
    [self.square addGestureRecognizer:aDoubleTapGesture];
    
    //双击后单击跳到开头、结尾
    UITapGestureRecognizer *aTapAfterDoubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAfterDoubleTap:)];
    //这句很重要
    [aTapAfterDoubleTapGesture requireGestureRecognizerToFail:aDoubleTapGesture];
    [self.square addGestureRecognizer:aTapAfterDoubleTapGesture];
    
    //长按选择
    UILongPressGestureRecognizer *aLongPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.square addGestureRecognizer:aLongPressGesture];
    
    
    //初始化originalX
    self.squareOriginalX = self.square.frame.origin.x;
    self.textField.delegate = self;
//    self.textField.text = @"begin-----------a;sdjlkfhc阿斯兰的；开飞机离开；差距暗室逢灯；拉三等奖iuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwibshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiuhgkjzgviuxcfgadsa;sdjlkfhcxuizviuabshjekgqwiads*************end测试中文";
    self.textField.text = @"begin-------a;sdjlkfhc阿斯兰的阿斯兰的阿斯兰的阿斯兰的阿斯兰的阿斯兰的";
    [[SetUpAboutKeyboard alloc]initWithPreparation4KeyboardWithVC:self andLiftTheViews:nil];
    
    //初始化队列
    self.moveRightQueue = [[NSOperationQueue alloc]init];
    self.moveLeftQueue = [[NSOperationQueue alloc]init];
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            NSLog(@"%@",[[NSRunLoop currentRunLoop] class]);
            NSLog(@"squareFrame%@ - slideBarFrame%@",NSStringFromCGRect(self.square.frame),NSStringFromCGRect(self.slideBar.frame));
        } while (self.square.frame.origin.x <= self.slideBar.frame.origin.x);
    });
}
#pragma mark LongPress手势
static CGFloat recorder4LongPressOffset = 0.0;
//初始化一个变量用来累每次增加的选择offset
static CGFloat plusVar = 0.0;
- (void)longPress:(UILongPressGestureRecognizer *)aLongPress
{
    if (aLongPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
        self.slideBar.backgroundColor = [UIColor cyanColor];
    }else if (aLongPress.state == UIGestureRecognizerStateChanged){
        
        CGPoint gesturePoint = [aLongPress locationInView:self.slideBar];
        NSLog(@"gesturePoint-longPress-location- %@",NSStringFromCGPoint(gesturePoint));
        if (gesturePoint.x>0 && gesturePoint.x<self.slideBar.frame.size.width) {
            self.square.transform = CGAffineTransformMakeTranslation(gesturePoint.x-self.square.center.x, 0);
            [self makeSelectionWithOffset:self.square.transform.tx];
        }
    }
    if (aLongPress.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.square.transform = CGAffineTransformIdentity;
        }];
        recorder4LongPressOffset = 0.0;
        plusVar = 0.0;
        self.slideBar.backgroundColor = [UIColor lightGrayColor];
        NSLog(@"结束长按");
    }
}

#pragma mark 移动选择方法
- (void)makeSelectionWithOffset:(NSInteger)aOffset
{
    //起始点
    UITextPosition *selectionBeginPosition;
    UITextPosition *targetPosition;
    if (aOffset>0) {
        //表示是应该向右边移动
        //光标向右移动那么就是向右选择，所以起始点应该是左边的，左边的是.start
        selectionBeginPosition = self.textField.selectedTextRange.start;
        targetPosition = [self.textField positionFromPosition:selectionBeginPosition offset:aOffset];
        //预计会移动到的位置距离末尾有多少个字符
        NSInteger targetOffset2End = [self.textField offsetFromPosition:targetPosition toPosition:self.textField.endOfDocument];
        //当前距离末尾还有多少个字符
        NSInteger currentRemainOffset2End = [self.textField offsetFromPosition:self.textField.selectedTextRange.start toPosition:self.textField.endOfDocument];
        if (targetOffset2End > currentRemainOffset2End ) {
            //如果预计移动后距离末尾字符数大于现在还剩下的，说明超过了尾巴，修改targetPosition为末尾就好了
            targetPosition = self.textField.endOfDocument;
        }
    }else{
        //向左边移不用管，系统默认移动到最左边也不会到textField的末尾处
        //但是起始点就变了，向左选择，起始点应该是右边的.end
        selectionBeginPosition = self.textField.selectedTextRange.end;
        targetPosition = [self.textField positionFromPosition:selectionBeginPosition offset:aOffset];
    }
    self.textField.selectedTextRange = [self.textField textRangeFromPosition:selectionBeginPosition
                                                                  toPosition:targetPosition];
    
    NSString *selectedStr2BeginOfDocument = [self.textField textInRange:[self.textField textRangeFromPosition:self.textField.beginningOfDocument toPosition:targetPosition]];
    
    NSLog(@"%@",selectedStr2BeginOfDocument);
#warning 这里用sizeWithFont应该可以高出这个字符串的长度才对
    CGSize strSize = [selectedStr2BeginOfDocument sizeWithAttributes:@{NSFontAttributeName:self.textField.font}];
    NSLog(@"文字size%@",NSStringFromCGSize(strSize));
    /*
     *!!!!!
     */
    //向右边选择文字会出现field不会自动右移的情况
    UIScrollView *theUIFieldEditorContentView;
    for (id i in self.textField.subviews)
    {
        if ([i class] == NSClassFromString(@"UIFieldEditor")) {
            theUIFieldEditorContentView = i;
        }
    }
    NSLog(@"展示的文字view的contentOffset%@",NSStringFromCGPoint(theUIFieldEditorContentView.contentOffset));
    CGFloat offsetX = (strSize.width - theUIFieldEditorContentView.frame.size.width)>0?strSize.width - theUIFieldEditorContentView.frame.size.width:0;
    theUIFieldEditorContentView.contentOffset =CGPointMake(offsetX,
                                                           0);

    
}

#pragma mark DoubleTap手势
//这两个是判断在双击全选之前，光标是在文本开头还是在文本末尾处
static int isHeadOfText = 0;
static int isTailOfText = 0;
- (void)doubleTap:(UITapGestureRecognizer *)aDoubleTap
{
    //开始选中前光标距离文本末尾的offset
    NSInteger offset2End = [self.textField offsetFromPosition:self.textField.selectedTextRange.start
                                                   toPosition:self.textField.endOfDocument];
    if (offset2End == 0) {
        //光标在末尾
        isTailOfText = 1;
    }else if(offset2End == [self.textField offsetFromPosition:self.textField.beginningOfDocument
                                                   toPosition:self.textField.endOfDocument])
    {
        //光标在开头
        isHeadOfText = 1;
    }
    //选中范围设置为全文
    self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.beginningOfDocument
                                                                  toPosition:self.textField.endOfDocument];
    
}
#pragma mark DoubleTap&Tap 手势
- (void)tapAfterDoubleTap:(UITapGestureRecognizer *)aTap
{
    //文字总的长度
    NSInteger totalOffset = [self.textField offsetFromPosition:self.textField.beginningOfDocument
                                                    toPosition:self.textField.endOfDocument];
    //当前选中的文字长度
    NSInteger currentOffset = [self.textField offsetFromPosition:self.textField.selectedTextRange.start
                                                      toPosition:self.textField.selectedTextRange.end];
    if(totalOffset == currentOffset){
        //表示是已经双击选中过了
        if (isHeadOfText) {
            //双击前，光标在开头，那么现在就让光标去末尾
            self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.endOfDocument
                                                                          toPosition:self.textField.endOfDocument];
            //并重置
            isHeadOfText = 0;
        }else if (isTailOfText){
            //双击前，光标在末尾，现在就让光标去开头
            self.textField.selectedTextRange = [self.textField textRangeFromPosition:self.textField.beginningOfDocument
                                                                          toPosition:self.textField.beginningOfDocument];
            //并重置
            isTailOfText = 0;
        }
    }
    
}
#pragma mark Pan手势
static CGFloat recorder4SquareOffsetChange = 0.0;
- (void)pan:(UIPanGestureRecognizer *)aPanGesture
{
    NSLog(@"--gesturePoint-pan-location-%@",NSStringFromCGPoint([aPanGesture locationInView:self.slideBar]));

        CGPoint gesturePoint = [aPanGesture translationInView:self.slideBar];
    NSLog(@"--gesturePoint-pan-translation-%@",NSStringFromCGPoint(gesturePoint));

    if (fabsl(gesturePoint.x)<0.5*self.slideBar.frame.size.width){
            //滑动范围还在slideBar里面==>方块移动 ==> 光标也要移动
            self.square.transform = CGAffineTransformMakeTranslation(gesturePoint.x, 0);
            recorder4SquareOffsetChange = self.square.transform.tx-recorder4SquareOffsetChange;
            [self makeOffset:recorder4SquareOffsetChange onTextField:self.textField];
            recorder4SquareOffsetChange = self.square.transform.tx;
        //要停止runloop
        [self.moveRightQueue cancelAllOperations];
        
    }else if(gesturePoint.x>=0.5*self.slideBar.frame.size.width){
        //滑动范围在slideBar右边==>方块停在了最右边==>光标自动向右移(预计这个offset大一点好，比如10)
        if (self.moveRightTimer.isValid) {
            
        }else{
            [self.moveRightTimer fire];
        }
        
    }else if(gesturePoint.x<=-0.5*self.slideBar.frame.size.width){
        //滑动范围在slideBar左边==>方块停在了最左边==>光标自动向左移
        if (self.moveLeftTimer.isValid) {
            
        }else{
            [self.moveLeftTimer fire];
        }
        
    }
    if (aPanGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.square.transform = CGAffineTransformIdentity;
        }];
        recorder4SquareOffsetChange = 0.0;
    }
}

#pragma mark 移动方法
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
static int increasement4Offset = 0;
static float num4log = 1.2;
static int num4Increase = 1;
- (void)makeOffsetAutoIncreaseLeft
{
    if (self.square.frame.origin.x<=self.slideBar.frame.origin.x) {
        increasement4Offset += num4Increase;
        [self makeOffset:-(int)(log(increasement4Offset)/log(num4log)) onTextField:self.textField];
        NSLog(@"increasement %d  offset %d",increasement4Offset,(int)(log(increasement4Offset)/log(num4log)));
    }else{
        increasement4Offset = 0;
        [_moveLeftTimer invalidate];
        _moveLeftTimer = nil;
    }
    
}
- (void)makeOffsetAutoIncreaseRight
{
    if (self.square.frame.origin.x>self.slideBar.frame.size.width - self.square.frame.size.width) {
        increasement4Offset += num4Increase;
        [self makeOffset:(int)(log(increasement4Offset)/log(num4log)) onTextField:self.textField];
        NSLog(@"increasement %d  offset %d",increasement4Offset,(int)(log(increasement4Offset)/log(num4log)));
    }else{
        increasement4Offset = 0;
        [_moveRightTimer invalidate];
        _moveRightTimer = nil;
    }
    
}
#pragma mark 检测是否有中文
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
- (void)textDidChange:(id<UITextInput>)textInput
{
    
}
static CGRect caretRectForPosition;
static CGRect firstRectForRange;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    caretRectForPosition = [self.textField caretRectForPosition:self.textField.selectedTextRange.end];
    firstRectForRange = [self.textField firstRectForRange:self.textField.selectedTextRange];
    NSLog(@"caretRectForPosition:%@",NSStringFromCGRect(caretRectForPosition));
    NSLog(@"firstRectForRange:%@",NSStringFromCGRect(firstRectForRange));
    return YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)functionalBtn1:(id)sender {
    caretRectForPosition = [self.textField caretRectForPosition:self.textField.beginningOfDocument];
    firstRectForRange = [self.textField firstRectForRange:self.textField.selectedTextRange];
    NSLog(@"caretRectForPosition:%@",NSStringFromCGRect(caretRectForPosition));
    NSLog(@"firstRectForRange:%@",NSStringFromCGRect(firstRectForRange));
}

- (IBAction)functionalBtn2:(id)sender {
    UITextRange *aTextRange = self.textField.selectedTextRange;
    UITextPosition *headOfText = self.textField.beginningOfDocument;
    UITextPosition *tailOfText = self.textField.endOfDocument;
    NSLog(@"offsetFromPosition文首到光标%ld",(long)[self.textField offsetFromPosition:headOfText toPosition:aTextRange.start]);
    NSLog(@"offsetFromPosition文首到文尾%ld",(long)[self.textField offsetFromPosition:headOfText toPosition:tailOfText]);
    NSLog(@"offsetFromPosition选中的头到尾%ld",(long)[self.textField offsetFromPosition:aTextRange.start toPosition:aTextRange.end]);
    
    NSLog(@"comparePosition%ld",[self.textField comparePosition:aTextRange.start toPosition:aTextRange.end]);
}

- (IBAction)functionalBtn3:(id)sender {
    UITextRange *aTextRange = self.textField.selectedTextRange;
    
    UITextRange *newTextRange = [self.textField textRangeFromPosition:aTextRange.start toPosition:aTextRange.end];
    self.textField.selectedTextRange = [self.textField textRangeFromPosition:newTextRange.end toPosition:newTextRange.end];
}
static NSInteger deltaRight = 3;
static NSInteger deltaLeft = -3;
static NSInteger selection = 0;
- (IBAction)functionalBtn4:(id)sender {
    //测试向左选择3个
    selection += deltaLeft;
    [self makeSelectionWithOffset:selection];
    //测试左移3个
//    [self makeOffset:-3];
    /*
    //这里是测试光标右移3个
    NSInteger aOffset = 3;
    //注意这是光标没有选中任何东西时才行
    UITextPosition *caretPosition = self.textField.selectedTextRange.start;
    UITextPosition *targetPosition = [self.textField positionFromPosition:caretPosition
                                                                   offset:aOffset];
    UITextRange *newTextRange = [self.textField textRangeFromPosition:targetPosition
                                                           toPosition:targetPosition];
    self.textField.selectedTextRange = newTextRange;
     */
}
@end
