//
//  ViewController.h
//  OpenGL_ES_Practice_01
//
//  Created by  generic on 2022/6/23.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController
{
    
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (strong, nonatomic) GLKTextureInfo *textureInfo0;
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;

@end

