# iOS 手绘地图的实现

最近项目中实现的一个核心功能是实现手绘地图，具体的效果类似驴迹导游，有气泡弹出、路线绘制等。

## 实现方式确定

经过探讨我们认为比较靠谱的两种实现方式：

* 类似百度“瓦片”，在百度或高德原有的地图API上覆盖一层我们的手绘图，然后在进行其他功能
* 直接自定义View，用scrollView+imageView的方式初步实现地图的缩放+手势点击等

对比两种方式，前者更省力，尤其是是路线绘制会很简单，但缺点是可能后期一些功能的实现会受限，考虑到该模块是我们APP的核心模块，综合考虑下决定使用笨方法：最费力但可扩展性好。

##  两个难点

#### 1.手绘图坐标系的转换

因为需要实际地图在手绘图上1比1重现，就需要GPS坐标系和手绘图坐标系实现精准转换。

比如要计算区域中某一点的具体位置，过程整理如下：


![坐标系转换示意图]((https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d18bee6cb4fe4a979f244b1596fcc296~tplv-k3u1fbpfcp-zoom-1.image)



> 已知:景区边界点经纬度坐标：
>
> 左上：**A（x,y）**
>
> 左下：**B（x1,y1）**
>
> 右上：**C (x2,y2)**
>
> 景区手绘图图片url地址-----推出手绘图宽高：
>
> **W**和**H**
>
> 要计算的位置经纬度坐标：**D (x0,y0)**
>
> 求用户位置在手绘图的显示**（x4,y4）**
>
> 以iOS中的坐标系为例：
>
> 计算公式：**x4 =（x0-x1）/(x2-x1)*W**
>
> y4同理



代码实现如下：

```
/// 计算某位置在手绘图中的坐标
/// @param imageSize 手绘图尺寸
/// @param locationNow 当前位置的经纬度坐标
- (CLLocationCoordinate2D)getLocationWithsize:(CGSize)imageSize location:(CLLocationCoordinate2D) locationNow{
    
    CGSize size = imageSize;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(0, 0);
    //纬度= （左上纬度-现在纬度）/（左上高纬度-坐下）*image高度
    location.latitude = (self.leftToplocation.latitude-locationNow.latitude)/(self.leftToplocation.latitude-self.leftBottomLocation.latitude)*size.height;
    //经度=(现在经度-左上经度)/(右上经度-左上经度)*image宽度
    location.longitude = (locationNow.longitude-self.leftToplocation.longitude)/(self.rightTopLocation.longitude-self.leftToplocation.longitude)*size.width;
    return location;
}
```

#### 2.曲线的绘制

关于地图中路线的绘制，需要考虑路线有直线曲线两种情况，关于CALayer绘制曲线网上的介绍很多，不再赘述，具体实现方法：

```
-(void)drawCurvewithImageSize:(CGSize)imagesize Array:(NSArray *)lineArr ishu:(NSInteger) ishu TopLeftPoint:(CLLocationCoordinate2D)topleftPoint TopRightPoint:(CLLocationCoordinate2D)topright LeftBottom:(CLLocationCoordinate2D)leftBottom linewidth:(CGFloat)width color:(UIColor*)color{
    
    CalculatorLocationTool *calculatorTool = [[CalculatorLocationTool alloc] init];
    calculatorTool.leftToplocation = topleftPoint;
    calculatorTool.leftBottomLocation = leftBottom;
    calculatorTool.rightTopLocation = topright;
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (int i=0; i<lineArr.count; i++) {
        CLLocationCoordinate2D coor;
        NSValue *value = lineArr[i];
        [value getValue:&coor];
        
        CLLocationCoordinate2D coor1 = [calculatorTool getLocationWithsize:imagesize location:coor];
        if (i==0) {
            // 起点
            [linePath moveToPoint:CGPointMake(coor1.longitude,coor1.latitude)];
        }else if(ishu&&i<lineArr.count-2){
            
            CGPoint p0 = [self GetPointWithvalue:lineArr[i-1] Tool:calculatorTool imagesize:imagesize];
            CGPoint p1 = [self GetPointWithvalue:lineArr[i] Tool:calculatorTool imagesize:imagesize];
            CGPoint p2 = [self GetPointWithvalue:lineArr[i+1] Tool:calculatorTool imagesize:imagesize];
            CGPoint p3 = [self GetPointWithvalue:lineArr[i+2] Tool:calculatorTool imagesize:imagesize];
            
            // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
            for (int i = 1; i < 50; i++) {
                
                float t = (float) i * (1.0f / (float) 50);
                float tt = t * t;
                float ttt = tt * t;
                
                CGPoint pi; // intermediate point
                pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
                pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
                [linePath addLineToPoint:pi];
            }
            
            // Now add p2
            [linePath addLineToPoint:p2];
            // 其他点
            
            //
        }else{
            [linePath addLineToPoint:CGPointMake(coor1.longitude,coor1.latitude)];
        }
        
    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    lineLayer.lineWidth = width;
    lineLayer.lineJoin = kCALineJoinRound;
    linePath.lineJoinStyle = kCGLineJoinRound;
    lineLayer.strokeColor = color.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    
    [self.layer addSublayer:lineLayer];
    
}
```
![项目展示](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6477e50ccd264d8890e342cc86a68632~tplv-k3u1fbpfcp-zoom-1.image?imageslim "展示")


为了把项目中其他的点也体现出来，整理成[项目](https://github.com/hyf12138/HYFGraphicMap)了，有兴趣的同学可以下载下来看看。
