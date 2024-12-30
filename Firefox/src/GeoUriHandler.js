const uri = decodeURIComponent(location.hash.substring(1));
let data = uri.replace("geo:", "");
let coords = data.split(';')[0].split(',');
let targetUrl = "https://www.openstreetmap.org/?mlat=" + coords[0] + "&mlon=" + coords[1] + "&zoom=15";
location.href = targetUrl;