//
//  ViewController.h
//  OpenGL_ES_Practice_4_!
//
//  Created by  generic on 2022/6/27.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) GLKBaseEffect *extraEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
   *vertexBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
   *extraBuffer;

@property (nonatomic) GLfloat
   centerVertexHeight;
@property (nonatomic) BOOL
   shouldUseFaceNormals;
@property (nonatomic) BOOL
   shouldDrawNormals;

- (IBAction)takeShouldUseFaceNormalsFrom:(UISwitch *)sender;

- (IBAction)takeShouldDrawNormalsFrom:(UISwitch *)sender;

- (IBAction)takeCenterVertexHeightFrom:(UISlider *)sender;

@end

