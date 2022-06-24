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
    AGLKVertexAttribArrayBuffer *vertexBuffer;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (nonatomic) BOOL shouldUseLinearFilter;
@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL shouldRepeatTexture;
@property (nonatomic) GLfloat sCoordinateOffset;

- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender;
- (IBAction)takeShouldAnimationFrom:(UISwitch *)sender;
- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender;
- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender;
@end

