when defined(windows) and defined(useDirectX) and defined(shadyRunDx12):
  import silky, vmath

  let window = newWindow(
    title = "Silky Shady DirectX shader test",
    size = ivec2(64, 64),
    visible = false
  )
  let atlasBuilder = newAtlasBuilder(32, 1)

  discard newSilky(window, atlasBuilder.atlasImage, atlasBuilder.atlas)
  echo "Silky DirectX Shady shader runtime test passed"
elif defined(windows) and defined(useDirectX):
  echo "Silky DirectX Shady shader runtime test skipped; run with -d:shadyRunDx12"
else:
  echo "Silky DirectX Shady shader runtime test skipped; Windows DirectX is required"
