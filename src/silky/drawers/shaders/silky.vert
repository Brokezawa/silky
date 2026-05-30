#version 450
// from silkyVert

layout(push_constant) uniform ShadyPushConstants {
  vec2 viewportSize;
  vec2 atlasSize;
} shadyPushConstants;
#define viewportSize shadyPushConstants.viewportSize
#define atlasSize shadyPushConstants.atlasSize

layout(location = 0) in vec2 pos;
layout(location = 1) in vec2 uv;
layout(location = 2) in vec4 color;
layout(location = 3) in vec2 clipPos;
layout(location = 4) in vec2 clipSize;
layout(location = 5) in vec2 maskUv;
layout(location = 0) out vec2 fragmentUv;
layout(location = 1) out vec4 fragmentColor;
layout(location = 2) out vec2 fragmentClipPos;
layout(location = 3) out vec2 fragmentClipSize;
layout(location = 4) out vec2 fragmentPos;
layout(location = 5) out vec2 fragmentMaskUv;

void main() {
  vec2 ndc = vec2((pos.x / viewportSize.x) * 2.0 - 1.0, 1.0 - (pos.y / viewportSize.y) * 2.0);
  gl_Position = vec4(ndc.x, ndc.y, 0.0, 1.0);
  fragmentUv = uv / atlasSize;
  fragmentColor = vec4(color);
  fragmentClipPos = clipPos;
  fragmentClipSize = clipSize;
  fragmentPos = pos;
  fragmentMaskUv = maskUv / atlasSize;
  gl_Position.y = -gl_Position.y;
}
