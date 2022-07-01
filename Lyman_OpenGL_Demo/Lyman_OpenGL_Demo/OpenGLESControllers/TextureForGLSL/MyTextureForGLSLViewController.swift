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
        
        // MARK: 通过GLKTextureLoader 来加载纹理，并存放在 GLKBaseEffect 中
        guard let imagePath = Bundle.main.path(forResource: "sample", ofType: "jpg") else {
            assert(false, "error in generate imagePath")
        }
        guard let image = UIImage(contentsOfFile: imagePath) else {
            assert(false, "error in generate image")
        }
        
        
        
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
        glGenFramebuffers(1, &frameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), renderBuffer)
        
    }
    
    private func createTexture(with image: UIImage) -> GLuint {
        // 将UIImage 转换为 CGImageRef
        guard let cgImageRef = image.cgImage else {
            return GLuint()
        }
        let width = GLuint(bitPattern: Int32(cgImageRef.width))
        let height = GLuint(bitPattern: Int32(cgImageRef.height))
        let rect = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
        
        
        // 绘制图片
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let imageDataPointer = UnsafeMutableRawPointer(bitPattern: MemoryLayout<GLuint>.size * Int(width) * Int(height))
        let context = CGContext(
            data: imageDataPointer,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: 8,
            bytesPerRow: Int(width) * MemoryLayout<GLuint>.size,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        )
        context?.translateBy(x: 0, y: CGFloat(height))
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.clear(rect)
        context?.draw(cgImageRef, in: rect)
        
        // 生成纹理
        var textureID: GLuint = GLuint()
        glGenTextures(1, &textureID)
        glBindTexture(GLenum(GL_TEXTURE_2D), textureID)
//        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, width, <#T##height: GLsizei##GLsizei#>, <#T##border: GLint##GLint#>, <#T##format: GLenum##GLenum#>, <#T##type: GLenum##GLenum#>, <#T##pixels: UnsafeRawPointer!##UnsafeRawPointer!#>)
        
        
        
    }
    
}
