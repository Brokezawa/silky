import strutils, shady, silky/drawers/shader

block:
  let vertex = toShader(silkyVert, glsl3Desktop, shaderVertex)
  doAssert "uniform vec2 viewportSize;" in vertex
  doAssert "uniform vec2 atlasSize;" in vertex
  doAssert "in vec2 pos;" in vertex
  doAssert "in vec2 maskUv;" in vertex
  doAssert "out vec2 fragmentUv;" in vertex
  doAssert "out vec2 fragmentMaskUv;" in vertex

  let fragment = toShader(silkyFrag, glsl3Desktop, shaderFragment)
  doAssert "uniform sampler2D atlasSampler;" in fragment
  doAssert "discard" in fragment
  doAssert "texture(atlasSampler, fragmentUv)" in fragment
  doAssert "(texture(atlasSampler, fragmentMaskUv)).r" in fragment
  doAssert "mix(vec3(1.0, 1.0, 1.0), fragmentColor.rgb, maskR)" in fragment

block:
  let vertex = toHLSL(silkyVert, shaderVertex)
  doAssert "cbuffer ShadyUniforms : register(b0)" in vertex
  doAssert "float2 viewportSize;" in vertex
  doAssert "float2 atlasSize;" in vertex
  doAssert "float2 pos : POSITION0" in vertex
  doAssert "float2 maskUv : TEXCOORD3" in vertex
  doAssert "float4 pos : SV_POSITION;" in vertex

  let fragment = toHLSL(silkyFrag, shaderFragment)
  doAssert "Texture2D<float4> atlasSampler : register(t0);" in fragment
  doAssert "SamplerState atlasSamplerSampler : register(s0);" in fragment
  doAssert "float4 gl_FragCoord : SV_POSITION" in fragment
  doAssert "atlasSampler.Sample(atlasSamplerSampler, fragmentUv)" in fragment
  doAssert "(atlasSampler.Sample(atlasSamplerSampler, fragmentMaskUv)).r" in fragment
  doAssert "lerp(float3(1.0, 1.0, 1.0), fragmentColor.rgb, maskR)" in fragment

echo "Silky Shady shader codegen tests passed"
