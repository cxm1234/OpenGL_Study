//
//  ViewController.m
//  OpenGL_ES_Practice_5_4
//
//  Created by  generic on 2022/6/28.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"
#import "lowPolyAxesAndModels2.h"

/////////////////////////////////////////////////////////////////
// Forward declaration
static GLKMatrix4 SceneMatrixForTransform(
   SceneTransformationSelector type,
   SceneTransformationAxisSelector axis,
   float value);

@implementation ViewController

@synthesize baseEffect;
@synthesize vertexPositionBuffer;
@synthesize vertexNormalBuffer;
@synthesize transform1ValueSlider;
@synthesize transform2ValueSlider;
@synthesize transform3ValueSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
       @"View controller's view is not a GLKView");
       
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[AGLKContext alloc]
       initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];

    // Configure a light to simulate the Sun
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(
       0.4f, // Red
       0.4f, // Green
       0.4f, // Blue
       1.0f);// Alpha
    self.baseEffect.light0.position = GLKVector4Make(
       1.0f,
       0.8f,
       0.4f,
       0.0f);
     
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
       0.0f, // Red
       0.0f, // Green
       0.0f, // Blue
       1.0f);// Alpha
    
    // Create vertex buffers containing vertices to draw
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
       initWithAttribStride:(3 * sizeof(GLfloat))
       numberOfVertices:sizeof(lowPolyAxesAndModels2Verts) /
          (3 * sizeof(GLfloat))
       bytes:lowPolyAxesAndModels2Verts
       usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
       initWithAttribStride:(3 * sizeof(GLfloat))
       numberOfVertices:sizeof(lowPolyAxesAndModels2Normals) /
          (3 * sizeof(GLfloat))
       bytes:lowPolyAxesAndModels2Normals
       usage:GL_STATIC_DRAW];

    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeRotation(
       GLKMathDegreesToRadians(30.0f),
       1.0,  // Rotate about X axis
       0.0,
       0.0);
    modelviewMatrix = GLKMatrix4Rotate(
       modelviewMatrix,
       GLKMathDegreesToRadians(-30.0f),
       0.0,
       1.0,  // Rotate about Y axis
       0.0);
    modelviewMatrix = GLKMatrix4Translate(
       modelviewMatrix,
       -0.25,
       0.0,
       -0.20);
       
    self.baseEffect.transform.modelviewMatrix = modelviewMatrix;

    [((AGLKContext *)view.context) enable:GL_BLEND];
    [((AGLKContext *)view.context)
       setBlendSourceFunction:GL_SRC_ALPHA
       destinationFunction:GL_ONE_MINUS_SRC_ALPHA];
}

/////////////////////////////////////////////////////////////////
// GLKView delegate method: Called by the view controller's view
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a frame buffer that
// shares memory with a Core Animation Layer)
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   const GLfloat  aspectRatio =
      (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;

   self.baseEffect.transform.projectionMatrix =
      GLKMatrix4MakeOrtho(
         -0.5 * aspectRatio,
         0.5 * aspectRatio,
         -0.5,
         0.5,
         -5.0,
         5.0);

   // Clear back frame buffer (erase previous drawing)
   [((AGLKContext *)view.context)
      clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
   
   // Prepare vertex buffers for drawing
   [self.vertexPositionBuffer
      prepareToDrawWithAttrib:GLKVertexAttribPosition
      numberOfCoordinates:3
      attribOffset:0
      shouldEnable:YES];
   [self.vertexNormalBuffer
      prepareToDrawWithAttrib:GLKVertexAttribNormal
      numberOfCoordinates:3
      attribOffset:0
      shouldEnable:YES];
   
   // Save the current Modelview matrix
   GLKMatrix4 savedModelviewMatrix =
      self.baseEffect.transform.modelviewMatrix;
   
   // Combine all of the user chosen transforms in order
   GLKMatrix4 newModelviewMatrix =
      GLKMatrix4Multiply(savedModelviewMatrix,
      SceneMatrixForTransform(
         transform1Type,
         transform1Axis,
         transform1Value));
   newModelviewMatrix =
      GLKMatrix4Multiply(newModelviewMatrix,
      SceneMatrixForTransform(
         transform2Type,
         transform2Axis,
         transform2Value));
   newModelviewMatrix =
      GLKMatrix4Multiply(newModelviewMatrix,
      SceneMatrixForTransform(
         transform3Type,
         transform3Axis,
         transform3Value));

   // Set the Modelview matrix for drawing
   self.baseEffect.transform.modelviewMatrix = newModelviewMatrix;
   
   // Make the light white
   self.baseEffect.light0.diffuseColor = GLKVector4Make(
      1.0f, // Red
      1.0f, // Green
      1.0f, // Blue
      1.0f);// Alpha
      
   [self.baseEffect prepareToDraw];
         
   // Draw triangles using vertices in the prepared vertex
   // buffers
   [AGLKVertexAttribArrayBuffer
      drawPreparedArraysWithMode:GL_TRIANGLES
      startVertexIndex:0
      numberOfVertices:lowPolyAxesAndModels2NumVerts];

   // Restore the saved Modelview matrix
   self.baseEffect.transform.modelviewMatrix =
      savedModelviewMatrix;
   
   // Change the light color
   self.baseEffect.light0.diffuseColor = GLKVector4Make(
      1.0f, // Red
      1.0f, // Green
      0.0f, // Blue
      0.3f);// Alpha

   [self.baseEffect prepareToDraw];
   
   // Draw triangles using vertices in the prepared vertex
   // buffers
   [AGLKVertexAttribArrayBuffer
      drawPreparedArraysWithMode:GL_TRIANGLES
      startVertexIndex:0
      numberOfVertices:lowPolyAxesAndModels2NumVerts];
}

/////////////////////////////////////////////////////////////////
// Called when the view controller's view has been unloaded
// Perform clean-up that is possible when you know the view
// controller's view won't be asked to draw again soon.
- (void)viewDidUnload
{
   [super viewDidUnload];
   
   // Make the view's context current
   GLKView *view = (GLKView *)self.view;
   [AGLKContext setCurrentContext:view.context];
    
   // Delete buffers that aren't needed when view is unloaded
   self.vertexPositionBuffer = nil;
   self.vertexNormalBuffer = nil;
   
   // Stop using the context created in -viewDidLoad
   ((GLKView *)self.view).context = nil;
   [EAGLContext setCurrentContext:nil];
}


/////////////////////////////////////////////////////////////////
// Transform the current coordinate system according to the users
// selections stored in global variables, transform1Type,
// transform1Axis, and transform1Value.
static GLKMatrix4 SceneMatrixForTransform(
   SceneTransformationSelector type,
   SceneTransformationAxisSelector axis,
   float value)
{
   GLKMatrix4 result = GLKMatrix4Identity;
   
   switch (type) {
      case SceneRotate:
         switch (axis) {
            case SceneXAxis:
               result = GLKMatrix4MakeRotation(
                  GLKMathDegreesToRadians(180.0 * value),
                  1.0,
                  0.0,
                  0.0);
               break;
            case SceneYAxis:
               result = GLKMatrix4MakeRotation(
                  GLKMathDegreesToRadians(180.0 * value),
                  0.0,
                  1.0,
                  0.0);
               break;
            case SceneZAxis:
            default:
               result = GLKMatrix4MakeRotation(
                  GLKMathDegreesToRadians(180.0 * value),
                  0.0,
                  0.0,
                  1.0);
               break;
         }
         break;
      case SceneScale:
         switch (axis) {
            case SceneXAxis:
               result = GLKMatrix4MakeScale(
                  1.0 + value,
                  1.0,
                  1.0);
               break;
            case SceneYAxis:
               result = GLKMatrix4MakeScale(
                  1.0,
                  1.0 + value,
                  1.0);
               break;
            case SceneZAxis:
            default:
               result = GLKMatrix4MakeScale(
                  1.0,
                  1.0,
                  1.0 + value);
               break;
         }
         break;
      default:
         switch (axis) {
            case SceneXAxis:
               result = GLKMatrix4MakeTranslation(
                  0.3 * value,
                  0.0,
                  0.0);
               break;
            case SceneYAxis:
               result = GLKMatrix4MakeTranslation(
                  0.0,
                  0.3 * value,
                  0.0);
               break;
            case SceneZAxis:
            default:
               result = GLKMatrix4MakeTranslation(
                  0.0,
                  0.0,
                  0.3 * value);
               break;
         }
         break;
   }
   
   return result;
}


- (IBAction)takeTransform3ValueFrom:(UISlider *)sender {
    transform3Value = [sender value];
}

- (IBAction)takeTransform2ValueFrom:(UISlider *)sender {
    transform2Value = [sender value];
}

- (IBAction)takeTransform1ValueFrom:(UISlider *)sender {
    transform1Value = [sender value];
}

- (IBAction)takeTransform3AxisFrom:(UISegmentedControl *)sender {
    transform3Axis = [sender selectedSegmentIndex];
}

- (IBAction)takeTransform2AxisFrom:(UISegmentedControl *)sender {
    transform2Axis = [sender selectedSegmentIndex];
}

- (IBAction)takeTransform1AxisFrom:(UISegmentedControl *)sender {
    transform1Axis = [sender selectedSegmentIndex];
}

- (IBAction)takeTransform3TypeFrom:(UISegmentedControl *)sender {
    transform3Type = [sender selectedSegmentIndex];
}

- (IBAction)takeTransform2TypeFrom:(UISegmentedControl *)sender {
    transform2Type = [sender selectedSegmentIndex];
}

- (IBAction)takeTransform1TypeFrom:(UISegmentedControl *)sender {
    
    transform1Type = [sender selectedSegmentIndex];
    
}

- (IBAction)resetIdentity:(id)sender {
    
    [transform1ValueSlider setValue:0.0];
    [transform2ValueSlider setValue:0.0];
    [transform3ValueSlider setValue:0.0];
    transform1Value = 0.0;
    transform2Value = 0.0;
    transform3Value = 0.0;
    
}
@end
