using Bonito, Observables
using Bonito: ES6Module
using Markdown

leafletjs = Bonito.ES6Module("https://esm.sh/v133/leaflet@1.9.4/es2022/leaflet.mjs")
leafletcss = Bonito.Asset("https://unpkg.com/leaflet@1.9.4/dist/leaflet.css")
myModule = ES6Module("./src/map.js")

struct LeafletMap
    position::NTuple{2,Float64} # lat, lon
    zoom::Int
end

lon = Observable(0.0)
lat = Observable(0.0)
pos = Observable([0.0, 0.0])
onany(pos) do pos
  println("(lat, lon): ", pos[1], ", ", pos[2])
end
# onany(lat, lon) do lat, lon
#     println("lat: ", lat, " lon: ", lon)
# end

# point = (30.460452, 114.612594)
stations = [
    (lat=30, lon=114, name="Station 1"),
    (lat=31, lon=115, name="Station 2"),
    # Add all 50 stations here
]

function Bonito.jsrender(session::Session, map::LeafletMap)
    title = md"""
    # Hello world!
    """
    map_div = DOM.div(; id="map", style="height: 600px;")
    coords_label = DOM.div("POI"; id="coords")

    script = js"""
      $(leafletjs).then(L => {
        $(myModule).then(Module => {
          const map = L.map('map').setView($(map.position), $(map.zoom));
          L.tileLayer(
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
              maxZoom: 19,
              attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
          }).addTo(map);

          // add all stations to Map
          var stations = $(stations)
          stations.forEach(station => {
              L.marker([station.lat, station.lon])
                .addTo(map).bindPopup('<b>' + station.name + '</b>')
                .on('click', function(e) {
                    console.log("Clicked on station: ", station.name);
                    $(pos).notify([station.lat, station.lon]);
                });
              // add a click response function
          });

          let marker; // Variable to store the current marker
          // Add click event listener
          map.on('click', function(e) {
              var lat = e.latlng.lat;
              var lon = e.latlng.lng;
              $(pos).notify([lat, lon]);

              if (marker) map.removeLayer(marker);
              // Add a new marker at the clicked location
              marker = L.marker([e.latlng.lat, e.latlng.lng]).addTo(map);
              marker.bindPopup("<b>New Marker</b><br>Location: " + lat.toFixed(6) + ", " + lon.toFixed(6)).openPopup();

              Module.map_click(e);
              //$(lon).notify(lon)
          });
        });
      })
    """
    return Bonito.jsrender(
        session,
        DOM.div(
            leafletcss,
            leafletjs,
            myModule,
            script,
          title, map_div, coords_label)
    )
end

page_leaf = App() do
    # point = (30.460452, 114.612594) # CUG_new
    point = (30.073959, 114.952011) # 大治
    return LeafletMap(point, 12)
end
