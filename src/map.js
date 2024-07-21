export function map_click(e) {
  var lat = e.latlng.lat;
  var lon = e.latlng.lng;

  // $(lat).notify(lat)
  // $(lon).notify(lon)
  // console.log("lon:" + lon);
  // console.log("lon:" + lat);
  const div_coord = document.getElementById('coords');
  div_coord.innerHTML = '(lat, lon): ' + lat.toFixed(6) + ', ' + lon.toFixed(6);
  // return {lat: lat, lon:lon};
}
