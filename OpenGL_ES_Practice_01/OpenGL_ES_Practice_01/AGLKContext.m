//
//  AGLKContext.m
//  OpenGL_ES_Practice_01
//
//  Created by  generic on 2022/6/23.
//

#import "AGLKContext.h"

@implementation AGLKContext

- (void)setClearColor:(GLKVector4)clearColorRGBA {
    clearColor = clearColorRGBA;
    
    glClearColor(
                 clearColorRGBA.r,
                 clearColorRGBA.g,
                 clearColorRGBA.b,
                 clearColorRGBA.a
                 );
}

- (GLKVector4)clearColor {
    return clearColor;
}

- (void)clear:(GLbitfield)mask {
    glClear(mask);
}

- (void)enable:(GLenum)capability {
    glEnable(capability);
}

- (void)disable:(GLenum)capability {
    glDisable(capability);
}

- (void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor {
    glBlendFunc(sfactor, dfactor);
}

@end
