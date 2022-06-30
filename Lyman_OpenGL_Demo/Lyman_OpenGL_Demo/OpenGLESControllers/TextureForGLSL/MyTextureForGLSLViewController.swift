//
//  MyTextureForGLSLViewController.swift
//  Lyman_OpenGL_Demo
//
//  Created by  generic on 2022/6/30.
//

import UIKit
import GLKit

class MyTextureForGLSLViewController: UIViewController {
    
    // 顶点数组
    var vertices: [SenceVertex] = [
        SenceVertex(
            positionCoord: GLKVector3(v: (-1, 1, 0)),
            textureCoord: GLKVector2(v:(0, 1))
        ), // 左上角
        SenceVertex(
            positionCoord: GLKVector3(v: (-1, -1, 0)),
            textureCoord: GLKVector2(v:(0, 0))
        ), // 左下角
        SenceVertex(
            positionCoord: GLKVector3(v: (1, 1, 0)),
            textureCoord: GLKVector2(v:(1, 1))
        ), // 右上角
        SenceVertex(
            positionCoord: GLKVector3(v: (1, -1, 0)),
            textureCoord: GLKVector2(v:(1, 0))
        ) // 右下角
    ]
    
    var context: EAGLContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "纹理渲染GLSL小课堂"
        view.backgroundColor = .white
        
        context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(context)
        
        // 创建一个展示纹理的层
        let layer = CAEAGLLayer()
        layer.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.width)
        layer.contentsScale = UIScreen.main.scale // 设置缩放比例，不设置的话，纹理会失真
        
        view.layer.addSublayer(layer)
        
        bindRenderLayer(layer: layer)
        
        
    }

}

extension MyTextureForGLSLViewController {
    
    private func bindRenderLayer(layer: CAEAGLLayer) {
        
        var renderBuffer = GLuint() // 渲染缓存
        var frameBuffer = GLuint() // 帧缓存
        
        // 绑定渲染缓存要输出的layer
        glGenRenderbuffers(1, &renderBuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), renderBuffer)
        context?.renderbufferStorage(Int(GL_RENDERBUFFER), from: layer)
        
        // 将渲染缓存绑定到帧缓存上
        
        
        
    }
    
}
