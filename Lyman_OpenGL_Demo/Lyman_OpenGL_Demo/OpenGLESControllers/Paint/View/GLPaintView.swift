//
//  GLPaintView.swift
//  Lyman_OpenGL_Demo
//
//  Created by  generic on 2022/7/4.
//

import UIKit

class GLPaintView: UIView {
    
    var textureSize: CGSize = .zero
    var customBackgroundColor: UIColor = UIColor.white
    var backgroundImage: UIImage?

    init(
        with frame: CGRect,
        textureSize: CGSize,
        backgroundColor: UIColor,
        backgroundImage: UIImage
    ) {
        super.init(frame: frame)
        self.textureSize = textureSize
        self.customBackgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
    }
    
    convenience init(with frame: CGRect, textureSize: CGSize, background: UIColor) {
        self.init(with: frame, textureSize: textureSize, backgroundColor: background, backgroundImage: <#T##UIImage#>)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
