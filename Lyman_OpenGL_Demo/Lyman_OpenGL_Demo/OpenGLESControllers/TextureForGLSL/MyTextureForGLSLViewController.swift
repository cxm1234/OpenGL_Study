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
    
    // 获取渲染缓存宽度
    lazy var drawableWidth: GLint = {
        var backingWidth: GLint = GLint()
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &backingWidth)
        return backingWidth
    }()
    
    // 获取渲染缓存高度
    lazy var drawableHeight: GLint = {
        var backingHeight: GLint = GLint()
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &backingHeight)
        return backingHeight
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    deinit {
        EAGLContext.setCurrent(nil)
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
        
        // 读取纹理
        guard let imagePath = Bundle.main.path(forResource: "sample", ofType: "jpg") else {
            assert(false, "error in generate imagePath")
        }
        guard let image = UIImage(contentsOfFile: imagePath) else {
            assert(false, "error in generate image")
        }
        let textureID = createTexture(with: image)
        
        // 设置视口尺寸
        glViewport(0, 0, drawableWidth, drawableHeight)
        
        // 编译链接 shader
        let program = program(with: "glsl")
        glUseProgram(program)
        
        // 获取 shader 中的参数, 然后传数据进去
        let positionSlot = glGetAttribLocation(program, "Position")
        let textureSlot = glGetUniformLocation(program, "Texture") // 注意 Uniform 类型的获取方式
        let textureCoordsSlot = glGetAttribLocation(program, "TextureCoords")
        
        // 将纹理 ID 传给着色器程序
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(GLenum(GL_TEXTURE_2D), textureID)
        glUniform1i(textureSlot, 0) // 将 textureSlot 赋值为 0, 而 0 与 GL_TEXTURE0 对应，这里如果写 1，上面也要改成 GL_TEXTURE1
        
        // 创建顶点缓存
        var vertexBuffer = GLuint()
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        let bufferSizeBytes = MemoryLayout<SenceVertex>.size * vertices.count
        glBufferData(GLenum(GL_ARRAY_BUFFER), bufferSizeBytes, vertices, GLenum(GL_STATIC_DRAW))
        
        // 设置顶点数据
        glEnableVertexAttribArray(GLuint(positionSlot))
        glVertexAttribPointer(GLuint(positionSlot), 3, GLenum(GL_FLOAT), GLboolean(false), GLsizei(MemoryLayout<SenceVertex>.size), UnsafeRawPointer(bitPattern: 0))
        
        // 设置纹理数据
        glEnableVertexAttribArray(GLuint(textureCoordsSlot))
        glVertexAttribPointer(GLuint(textureCoordsSlot), 2, GLenum(GL_FLOAT), GLboolean(false), GLsizei(MemoryLayout<SenceVertex>.size), UnsafeRawPointer(bitPattern: MemoryLayout<GLKVector3>.size + 4))
        
        
        // 开始绘制
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, GLsizei(vertices.count))
        
        context?.presentRenderbuffer(Int(GL_RENDERBUFFER))
        
        // 删除顶点缓存
        glDeleteBuffers(GLsizei(1), &vertexBuffer)
        vertexBuffer = 0
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
        let width = Int32(cgImageRef.width)
        let height = Int32(cgImageRef.height)
        let rect = CGRect(x: 0, y: 0, width: Int(width), height: Int(height))
        
        // 绘制图片
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 开辟内存空间
        let imageDataPointer = calloc(Int(width) * Int(height) * MemoryLayout<GLuint>.size, MemoryLayout<GLuint>.size)
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
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageDataPointer)
        
        // 设置如何把纹素映射成像素
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GLint(GL_CLAMP_TO_EDGE))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GLint(GL_CLAMP_TO_EDGE))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GLint(GL_LINEAR))
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GLint(GL_LINEAR))
        
        // 解绑
        glBindTexture(GLenum(GL_TEXTURE_2D), GLuint(0))

        // 释放内存
        free(imageDataPointer)
        return textureID
        
    }
    
}

// MARK: - 装载Shader -
extension MyTextureForGLSLViewController {
    
    private func program(with shaderName: String) -> GLuint {
    
        // 编译两个着色器
        let vertexShader = compileShader(with: shaderName, type: GLenum(GL_VERTEX_SHADER))
        let fragmentShader = compileShader(with: shaderName, type: GLenum(GL_FRAGMENT_SHADER))
        
        // 挂载 shader 到 program 上
        let program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        
        // 链接 program
        glLinkProgram(program)
        
        // 检查链接是否成功
        var linkSuccess: GLint = GLint()
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkSuccess)
        if linkSuccess == GL_FALSE {
            var infoLength: GLsizei = 0
            let bufferLength: GLsizei = 1024
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            
            let info: [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            var actualLength: GLsizei = 0
            
            // 获取错误信息
            glGetProgramInfoLog(program, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
            assert(false, "program 链接失败: \(info)")
            return 0
        }
        
        return program
    }
    
    private func compileShader(with name: String, type: GLenum) -> GLuint {
        
        guard let shaderPath = Bundle.main.path(forResource: name, ofType: type == GLenum(GL_VERTEX_SHADER) ? "vsh" : "fsh") else {
            return 0
        }
        
        guard let shaderString = try? String(contentsOfFile: shaderPath, encoding: .utf8) else {
            return 0
        }
        
        // 创建一个 shader 对象
        let shader = glCreateShader(type)
        
        // 获取 shader 的内容
        var shaderStringUTF8 = NSString(string: shaderString).utf8String
        var shaderStringLength: GLint = GLint(Int32(shaderString.count))
        glShaderSource(shader, 1, &shaderStringUTF8, &shaderStringLength)
        
        // 编译shader
        glCompileShader(shader)
        
        // 查询 shader 是否编译成功
        var compileSuccess: GLint = GLint()
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compileSuccess)
        
        if compileSuccess == GL_FALSE {
            var infoLength: GLsizei = 0
            let bufferLength: GLsizei = 1024
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            
            let info: [GLchar] = Array(repeating: GLchar(0), count: Int(bufferLength))
            var actualLength: GLsizei = 0
            
            // 获取错误信息
            glGetShaderInfoLog(shader, bufferLength, &actualLength, UnsafeMutablePointer(mutating: info))
            let messageString = String(utf8String: info)
            assert(false, "shader 编译失败: \(messageString)")
            return 0
        }
        
        return shader
    }
    
}
