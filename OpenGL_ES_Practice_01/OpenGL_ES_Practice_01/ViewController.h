//
//  ViewController.h
//  OpenGL_ES_Practice_01
//
//  Created by  generic on 2022/6/23.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController
{
    GLuint vertexBufferID;
}

@property (strong, nonatomic) GLKBaseEffect *baseEffect;

@end

