//
//  MYViewController.m
//  OpenGL_Play_01
//
//  Created by  generic on 2022/6/17.
//

#import "MYViewController.h"
#import <GLKit/GLKit.h>

@interface MYViewController ()

@end

@implementation MYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GLKView * view = (GLKView *)self.view;

    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
    
    view.drawableMultisample = GLKViewDrawableMultisample4X;
}

- (void)loadView {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    self.view = [[GLKView alloc] initWithFrame:[UIScreen mainScreen].bounds context:context];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
