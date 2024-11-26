import SwiftUI
import SpriteKit
import Observation
import AVFoundation
import UIKit
import Foundation

enum LatoFontType: String {
    case regular = "Lato-Regular"
    case bold = "Lato-Bold"
    case semibold = "Lato-Semibold"
    case black = "Lato-Black"
}

struct FontModifier: ViewModifier {
    
    var type: LatoFontType, size: CGFloat  // 存儲字體類型和字體大小
    
    // 初始化 FontModifier，提供默認值
    init(_ type: LatoFontType = .regular, size: CGFloat = 16) {
        self.type = type  // 設置字體類型
        self.size = size  // 設置字體大小
    }
    
    // 定義修飾符的主體內容
    func body(content: Content) -> some View {
        // 應用自定義字體到傳入的內容
        content.font(Font.custom(type.rawValue, size: size))  // 使用自定義字體和大小
    }
}
