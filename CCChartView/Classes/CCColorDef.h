//
//  CCColorDef.h
//  Pods
//
//  Created by fall1994 on 2017/1/4.
//
//

#ifndef __CCColorDef_H__
#define __CCColorDef_H__

#define CC_RGBA_COLOR(r,g,b,a) \
    [UIColor colorWithRed:((r)*1.0)/255.0 \
        green:((g)*1.0)/255.0 blue:((b)*1.0)/255.0 alpha:a]

#define CC_RGB_COLOR(r,g,b) \
    CC_RGBA_COLOR(r,g,b,1.0)


// -------------------------------------------------------

#define CC_COLOR_SNOW           CC_RGB_COLOR(255,250,250)

#define CC_COLOR_GHOST_WHITE    CC_RGB_COLOR(248,248,255)

#define CC_COLOR_LIGHT_GRAY     CC_RGB_COLOR(211,211,211)

#define CC_COLOR_DARK_GRAY      CC_RGB_COLOR(169,169,169)

#define CC_COLOR_HONEYDEW       CC_RGB_COLOR(240,255,240)

#define CC_COLOR_LAVENDER       CC_RGB_COLOR(230,230,250)

#define CC_COLOR_MISTY_ROSE     CC_RGB_COLOR(255,228,225)

#define CC_COLOR_INDIAN_RED     CC_RGB_COLOR(205,92,92)

#define CC_COLOR_ORANGE_RED     CC_RGB_COLOR(255,69,0)

#define CC_COLOR_LIGHT_PINK     CC_RGB_COLOR(255,174,185)

#define CC_COLOR_BLACK          CC_RGB_COLOR(0,0,0)


#endif
