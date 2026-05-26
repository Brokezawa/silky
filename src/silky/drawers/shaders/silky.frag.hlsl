// target hlsl dx12
// from silkyFrag

Texture2D<float4> atlasSampler : register(t0);
SamplerState atlasSamplerSampler : register(s0);


float4 PSMain(
  float4 gl_FragCoord : SV_POSITION,
  float2 fragmentUv : TEXCOORD0,
  float4 fragmentColor : COLOR0,
  float2 fragmentClipPos : TEXCOORD1,
  float2 fragmentClipSize : TEXCOORD2,
  float2 fragmentPos : TEXCOORD3,
  float2 fragmentMaskUv : TEXCOORD4
) : SV_TARGET {
  float4 fragColor = float4(0.0, 0.0, 0.0, 0.0);
  if ((((fragmentPos.x < fragmentClipPos.x) || (fragmentPos.y < fragmentClipPos.y)) || (fragmentClipPos.x + fragmentClipSize.x < fragmentPos.x)) || (fragmentClipPos.y + fragmentClipSize.y < fragmentPos.y)) {
    discard;
  } else if (0.0 <= float(fragmentMaskUv.x)) {
    float4 base = atlasSampler.Sample(atlasSamplerSampler, fragmentUv);
    float maskR = (atlasSampler.Sample(atlasSamplerSampler, fragmentMaskUv)).r;
    fragColor = float4(base.rgb * lerp(float3(1.0, 1.0, 1.0), fragmentColor.rgb, maskR), base.a * fragmentColor.a);
  } else {
    fragColor = atlasSampler.Sample(atlasSamplerSampler, fragmentUv) * fragmentColor;
  }
  return fragColor;
}
