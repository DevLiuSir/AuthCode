//
//  AuthCodeView.swift
//  AuthCodeExample
//
//  Created by Liu Chuan on 2018/3/4.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit


/// 根据字体文字大小和字体计算label宽度
///
/// - Parameters:
///   - text: 文字
///   - font: 字体
///   - maxSize: 最大值
/// - Returns: 大小
func calculatorSize(withText text: String, font: UIFont, maxSize: CGSize) -> CGSize {
    let attrs = [NSAttributedStringKey.font: font]
    return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
}

/// 从一个范围中返回一个随机数
///
/// - Parameter range: 范围
/// - Returns: 随机数
func randomNumber(from range: CountableClosedRange<Int>) -> Int {
    let distance = range.upperBound - range.lowerBound
    let rnd = arc4random_uniform(UInt32(distance))
    return range.lowerBound + Int(rnd)
}

/// 获取随机色
///
/// - Parameter alpha: 透明度
/// - Returns: UIColor
func getRandomColor(withAlpha alpha: CGFloat) -> UIColor {
    let r = CGFloat(arc4random() % UInt32(100))
    let g = CGFloat(arc4random() % UInt32(100))
    let b = CGFloat(arc4random() % UInt32(100))
    let color = UIColor(red: r / 100.0, green: g / 100.0, blue: b / 100.0, alpha: alpha)
    return color
}


/// 识别码类型
///
/// - defaultType: 默认类型
/// - mathType: 数字类型
enum IdentifyingCodeType {
    case defaultType
    case mathType
}


/// 验证码视图
class AuthCodeView: UIView {
    
    // MARK: - Attribute
    
    /// 字符数据数组
    var dataArray = [String]()
    
    /// 默认验证码的字符串
    var defaultString = ""
    
    /// 算术验证码的字符串
    var mathString = ""
    
    /// 验证码类型
    var codeType = IdentifyingCodeType.defaultType
    
    /// 是否旋转
    var isRotation: Bool = false
    
    /// 线的个数
    var kLineCount = 9
    
    /// 线的宽度
    var kLineWidth: CGFloat = 1.0
    
    /// 字符个数
    var kCharCount = 4
    
    /// 字体大小
    var kFontSize = UIFont.systemFont(ofSize: CGFloat(arc4random() % 8 + 30))

    
    
    // MARK: - Method
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - frame: 尺寸
    ///   - type: 验证码类型
    init(frame: CGRect, with type: IdentifyingCodeType) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.backgroundColor = getRandomColor(withAlpha: 1.0)
        switch type {
        case .defaultType:
            configDefaultAuth()
        case .mathType:
            configMathAuth()
        }
        codeType = type
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 配置默认验证码
    private func configDefaultAuth() {

    /*
         从字符数组中随机抽取相应数量的字符，组成验证码字符串.
         数组中存放的是可选的字符，可以是字母，也可以是中文
    */
        dataArray = ["0","1","2","3","4","5","6","7","8","9",
                     "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                     "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
                     "中","国","日","报"
        ]
        // 随机获取4个字符, 组成验证码字符串
        for i in 0 ..< kCharCount {
            /// 随机的索引
            let index = Int(arc4random() % UInt32(dataArray.count - 1))
            /// 随机索引对应的字符串
            let str = dataArray[index]
            if i == 0 {
                defaultString = str
            }else {
                defaultString = "\(defaultString)\(str)"
            }
        }
    }

    /// 配置算术验证码
    private func configMathAuth() {
        let i = Int(arc4random() % 10)
        let j = Int(arc4random() % 10)
        defaultString = "\(i)+"
        defaultString = defaultString + "\(j)="
        mathString = "\(i + j)"
        print("\(defaultString)")
    }
    
    /// 移除所有子视图: 这里指label
    private func removeAllSubviews() {
        for v in subviews {
            v.removeFromSuperview()
        }
    }
 
    /// 点击当前视图调用
    ///
    /// - Parameters:
    ///   - touches: 点击
    ///   - event: 事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 点击界面，切换验证码
        switch codeType {
        case .defaultType:
            configDefaultAuth()
            removeAllSubviews()
        case .mathType:
            configMathAuth()
        }
        // 调用drawRect方法来实现view的绘制
        setNeedsDisplay()
    }

    // 绘制界面
    // 调用情况: 1.UIView初始化后自动调用； 2.调用setNeedsDisplay方法时会自动调用）
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        backgroundColor = getRandomColor(withAlpha: 0.8)
        
        // 常量
        let textStr = "S" as NSString
        
        // 1.获得要显示验证码字符串
        let codeStr = defaultString as NSString
        
        // 2.根据字体大小, 计算字符串长宽, 获取每个字符的位置
        let textSize = textStr.size(withAttributes: [NSAttributedStringKey.font : kFontSize])
        
        /* 绘制界面的相关属性 */
        let width = rect.size.width / CGFloat(codeStr.length) - textSize.width
        let height = Int(rect.size.height - textSize.height)
//        var po = CGPoint.zero
        /// 字符的长度
        let textLenth = codeStr.length
        
        print("******字符的长度\(textLenth)---\(codeStr)")
        
        // 3.遍历字符的长度
        for i in 0 ..< textLenth {
            let pX = CGFloat(arc4random() % UInt32(width)) + CGFloat(i) * rect.size.width / CGFloat(textLenth)
            let pY = CGFloat(arc4random() % UInt32(height))
//            po = CGPoint(x: pX, y: pY)

            /// 获取当前下标的字符
            let currentCharacter = String.init(format: "%C", codeStr.character(at: i))
            
            /*
             CGFloat.greatestFiniteMagnitude: 是Swift 3.0语法, 相当于2.3中的CGFloat.max, 即是CGFloat的最大值
             */
            
            /// 获取字体的Size
            let si = calculatorSize(withText: currentCharacter, font: kFontSize, maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            
            /// 4.标签
            let label = UILabel(frame: CGRect(x: pX, y: pY, width: si.width, height: si.height))
            label.text = currentCharacter
            label.font = kFontSize
            
            if isRotation { // 验证码字符是否需要斜着
                /// 旋转角度: 随机-1到1
                var r = Double(randomNumber(from: -1...1))
                
                if r > 0.3 {
                    r = 0.3
                } else if r < -0.3 {
                    r = -0.3
                }
                label.transform = CGAffineTransform(rotationAngle: CGFloat(r))
            }
            addSubview(label)
            
            
//             4.获取一个字符
//            let code = String.init(format: "%C", codeStr.character(at: i))
//            let textCharacter = code as NSString
//            // 5.以某个点绘制界面
//            textCharacter.draw(at: po, withAttributes: [NSAttributedStringKey.font: kFontSize])
        }
        // 6.绘制干扰线
        startDrawHinderLine(rect)
    }
    
    /// 开始绘制干扰线
    ///
    /// - Parameter re: 尺寸
    private func startDrawHinderLine(_ re: CGRect) {
        
        // 获取画笔上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 抗锯齿设置
        context?.setAllowsAntialiasing(false)
        
        // 设置画线的宽度
        context?.setLineWidth(kLineWidth)
        
        // 绘制干扰的彩色直线
        for _ in 0 ..< kLineCount {
            
            // 随机颜色
            let col = getRandomColor(withAlpha: 0.3)
            
            // 设置画笔颜色
            context?.setStrokeColor(col.cgColor)
            
            // 设置线的起点
            let pX = CGFloat(arc4random() % UInt32(re.size.width))
            let pY = CGFloat(arc4random() % UInt32(re.size.height))
            context?.move(to: CGPoint(x: pX, y: pY))
            
            // 设置线终点
            let piX = CGFloat(arc4random() % UInt32(re.size.width))
            let piY = CGFloat(arc4random() % UInt32(re.size.height))
            
            // 沿着x开始画线
            context?.addLine(to: CGPoint(x: piX, y: piY))
            
            // 开始绘制图
            context?.strokePath()
        }
    }
}
