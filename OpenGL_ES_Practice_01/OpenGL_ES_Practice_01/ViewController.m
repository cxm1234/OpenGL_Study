//
//  ViewController.m
//  OpenGL_ES_Practice_01
//
//  Created by  generic on 2022/6/23.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

@interface GLKEffectPropertyTexture (AGLKAddtion)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (AGLKAddtion)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value {
    glBindTexture(self.target, self.name);
    glTexParameterf(self.target, parameterID, value);
}

@end

@implementation ViewController

@synthesize baseEffect;
@synthesize vertexBuffer;
@synthesize shouldUseLinearFilter;
@synthesize shouldAnimate;
@synthesize shouldRepeatTexture;
@synthesize sCoordinateOffset;

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords; // 纹理坐标
}
SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] = {
    {-0.02f, -0.01f, 0.0f},
    {0.01f, -0.005f, 0.0f},
    {-0.01f, 0.01f, 0.0f},
};

- (void)updateTextureParameters {
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S value:(self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE)];
    
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER value:(self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST)];
}

- (void)updateAnimatedVertexPositions {
    if (shouldAnimate) {
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if (vertices[i].positionCoords.x >= 1.0f ||
                vertices[i].positionCoords.x <= -1.0f) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            
            vertices[i].positionCoords.y += movementVectors[i].y;
            if (vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            
            vertices[i].positionCoords.z += movementVectors[i].z;
            if (vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    } else {
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    {
        int i;
        for (i = 0; i < 3; i++) {
            vertices[i].textureCoords.s = (defaultVertices[i].textureCoords.s + sCoordinateOffset);
        }
    }
}

- (void)update {
    
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    
    [vertexBuffer reinitWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) bytes:vertices];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.preferredFramesPerSecond = 60;
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
    
    
    GLKView * view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View Controller's view is not a GLKView");
    
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    
    // Setup texture
    CGImageRef imageRef = [[UIImage imageNamed:@"grid.png"] CGImage];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:nil];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer
     prepareToDrawWithAttrib:GLKVertexAttribPosition
     numberOfCoordinates:3
     attribOffset:offsetof(SceneVertex, positionCoords)
     shouldEnable:YES];
    [self.vertexBuffer
     prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
     numberOfCoordinates:2
     attribOffset:offsetof(SceneVertex, textureCoords)
     shouldEnable:YES];
    
    [self.vertexBuffer
     drawArrayWithMode:GL_TRIANGLES
     startVertexIndex:0
     numberOfVertices:3];
}

- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender {
    self.shouldRepeatTexture = [sender isOn];
}

- (IBAction)takeShouldAnimationFrom:(UISwitch *)sender {
    self.shouldAnimate = [sender isOn];
}

- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender {
    self.shouldUseLinearFilter = [sender isOn];
}

- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender {
    self.sCoordinateOffset = [sender value];
}

- (void)dealloc {
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    self.vertexBuffer = nil;
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
