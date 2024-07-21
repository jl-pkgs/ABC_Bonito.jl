using WGLMakie
using MakieLayers
using Bonito, Observables
using Bonito: @js_str, onjs, Button, TextField, Slider, linkjs, Session, App
using Bonito.DOM
using Hyperscript
using Markdown

include("page_imagesc.jl")
include("page_leaflet.jl")

app = App() do session::Session
  dom = md"""
  # Hello world!

  ## [Flood monitor](http://localhost/flood) 

  ## [leafmap](http://localhost/leafmap)
  """
  return Bonito.DOM.div(Bonito.MarkdownCSS, Bonito.Styling, dom)
end


## 建设起第一个简陋的app
server = Bonito.Server(app, "127.0.0.1", 80)
Bonito.HTTPServer.route!(server, "/flood" => page_imagesc)
Bonito.HTTPServer.route!(server, "/leafmap" => page_leaf)

Bonito.HTTPServer.start(server)
println("running ...")
wait(server)

# close(server)
