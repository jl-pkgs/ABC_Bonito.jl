using WGLMakie
using MakieLayers

z = rand(10, 10, 4)
page_imagesc = App() do session::Session
  fig = Figure(; size = (1400, 800))
  imagesc!(fig, z; colorrange=(-1, 1))
  return fig
end
