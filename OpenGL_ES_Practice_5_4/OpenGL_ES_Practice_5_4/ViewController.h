//
//  ViewController.h
//  OpenGL_ES_Practice_5_4
//
//  Created by  generic on 2022/6/28.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

/////////////////////////////////////////////////////////////////
// Constants identify user selected transformations
typedef enum
{
    SceneTranslate = 0,
    SceneRotate,
    SceneScale,
} SceneTransformationSelector;

/////////////////////////////////////////////////////////////////
// Constants identify user selected axis for transformation
typedef enum
{
    SceneXAxis = 0,
    SceneYAxis,
    SceneZAxis,
} SceneTransformationAxisSelector;

@interface ViewController : GLKViewController
{
    SceneTransformationSelector      transform1Type;
    SceneTransformationAxisSelector  transform1Axis;
    float                            transform1Value;
    SceneTransformationSelector      transform2Type;
    SceneTransformationAxisSelector  transform2Axis;
    float                            transform2Value;
    SceneTransformationSelector      transform3Type;
    SceneTransformationAxisSelector  transform3Axis;
    float                            transform3Value;
}

@property (strong, nonatomic) GLKBaseEffect
   *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
   *vertexPositionBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
   *vertexNormalBuffer;
@property (weak, nonatomic) IBOutlet UISlider *transform1ValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *transform2ValueSlider;
@property (weak, nonatomic) IBOutlet UISlider *transform3ValueSlider;

- (IBAction)resetIdentity:(id)sender;

- (IBAction)takeTransform1TypeFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform2TypeFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform3TypeFrom:(UISegmentedControl *)sender;

- (IBAction)takeTransform1AxisFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform2AxisFrom:(UISegmentedControl *)sender;
- (IBAction)takeTransform3AxisFrom:(UISegmentedControl *)sender;

- (IBAction)takeTransform1ValueFrom:(UISlider *)sender;
- (IBAction)takeTransform2ValueFrom:(UISlider *)sender;
- (IBAction)takeTransform3ValueFrom:(UISlider *)sender;

@end

