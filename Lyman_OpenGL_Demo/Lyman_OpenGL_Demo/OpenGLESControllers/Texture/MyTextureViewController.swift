//
//  MyTextureViewController.swift
//  Lyman_OpenGL_Demo
//
//  Created by  generic on 2022/6/30.
//

import UIKit
import GLKit

struct SenceVertex {
    let positionCoord: GLKVector3
    let textureCoord: GLKVector2
}

class MyTextureViewController: UIViewController {
    
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
    
    // OpenGL绘制图层
    lazy var glkView: GLKView = {
        let glkView = GLKView()
        glkView.backgroundColor = .clear
        glkView.delegate = self
        return glkView
    }()
    
    lazy var baseEffect: GLKBaseEffect = {
        let baseEffect = GLKBaseEffect()
        return baseEffect
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        EAGLContext.setCurrent(nil)
    }
    
    private func setupUI() {
        title = "纹理渲染小课堂"
        view.backgroundColor = .white
        
        // MARK: 初始化 GLKView
        guard let context = EAGLContext(api: .openGLES2) else {
            return
        }
        glkView.frame = CGRect(
            x: 0,
            y: 100,
            width: view.bounds.size.width,
            height: view.bounds.size.width
        )
        glkView.context = context
        view.addSubview(glkView)
    
        // MARK: 设置glkView的上下文为当前上下文
        EAGLContext.setCurrent(glkView.context)
        
        // MARK: 通过GLKTextureLoader 来加载纹理，并存放在 GLKBaseEffect 中
        guard let imagePath = Bundle.main.path(forResource: "sample", ofType: "jpg") else {
            assert(false, "error in generate imagePath")
        }
        guard let cgImage = UIImage(contentsOfFile: imagePath)?.cgImage else {
            assert(false, "error in generate cgImage")
        }
        guard let textureInfo = try? GLKTextureLoader.texture(with: cgImage, options: [GLKTextureLoaderOriginBottomLeft: true]) else {
            assert(false, "error in generate textureInfo")
        }
        guard let target = GLKTextureTarget(rawValue: textureInfo.target) else {
            assert(false, "error in generate target")
        }
        
        baseEffect.texture2d0.name = textureInfo.name
        baseEffect.texture2d0.target = target

        glkView.display()
    }

}

extension MyTextureViewController: GLKViewDelegate {
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        baseEffect.prepareToDraw()
        
        // MARK: 创建顶点缓存
        var vertexBuffer: GLuint = GLuint()
        glGenBuffers(1, &vertexBuffer) // 步骤一: 生成
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer) // 步骤二: 绑定
        let bufferSizeBytes = MemoryLayout<SenceVertex>.size * vertices.count
        glBufferData(GLenum(GL_ARRAY_BUFFER), bufferSizeBytes, vertices, GLenum(GL_STATIC_DRAW)) // 步骤: 缓存数据
        
        // 设置顶点数据
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue)) // 步骤四: 启用或禁用
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.position.rawValue),
            3,
            GLenum(GL_FLOAT),
            GLboolean(false),
            GLsizei(MemoryLayout<SenceVertex>.size),
            UnsafeRawPointer(bitPattern: 0)
        ) // 步骤五: 设置指针
        
        // 设置纹理数据
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.texCoord0.rawValue))
        glVertexAttribPointer(
            GLuint(GLKVertexAttrib.texCoord0.rawValue),
            2,
            GLenum(GL_FLOAT),
            GLboolean(false),
            GLsizei(MemoryLayout<SenceVertex>.size),
            UnsafeRawPointer(bitPattern:MemoryLayout<GLKVector3>.size + 4)
        )
        
        // 开始绘制
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, GLsizei(vertices.count))
        // 删除顶点缓存
        glDeleteBuffers(1, &vertexBuffer)
        vertexBuffer = GLuint()
    }
}




