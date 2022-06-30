//
//  ViewController.h
//  OpenGL_ES_Practice_5_1
//
//  Created by  generic on 2022/6/28.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (strong, nonatomic) GLKBaseEffect
   *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
   *vertexPositionBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
   *vertexNormalBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
   *vertexTextureCoordBuffer;

@end

