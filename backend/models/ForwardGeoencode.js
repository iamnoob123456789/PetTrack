// import the library
// if you use ES6 modules, use:
import opencage from 'opencage-api-client';
// if you use CommonJS, use:
const opencage = require('opencage-api-client');

// note that the library takes care of URI encoding
opencage
  .geocode({ q: 'Theresienhöhe 11, München' })
  .then((data) => {
    // console.log(JSON.stringify(data));
    if (data.status.code === 200 && data.results.length > 0) {
      const place = data.results[0];
      console.log(place.formatted);
      console.log(place.geometry);
      console.log(place.annotations.timezone.name);
    } else {
      console.log('Status', data.status.message);
      console.log('total_results', data.total_results);
    }
  })
  .catch((error) => {
    // console.log(JSON.stringify(error));
    console.log('Error', error.message);
    // other possible response codes:
    // https://opencagedata.com/api#codes
    if (error.status.code === 402) {
      console.log('hit free trial daily limit');
      console.log('become a customer: https://opencagedata.com/pricing');
    }
  });

// ... prints
// Theresienhöhe 11, 80339 Munich, Germany
// { lat: 48.1341651, lng: 11.5464794 }
// Europe/Berlin
