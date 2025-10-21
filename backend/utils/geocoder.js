import opencage from 'opencage-api-client';
import dotenv from 'dotenv';
import ForwardGeoencode from '../models/ForwardGeoencode.js';

dotenv.config();

const geocodeAddress = async (address) => {
  if (!address) {
    return null;
  }

  try {
    // First check if we already have this address geocoded in our database
    const existingGeocode = await ForwardGeoencode.findOne({ address });
    if (existingGeocode) {
      console.log('Using cached geocode for address:', address);
      return {
        type: 'Point',
        coordinates: [existingGeocode.longitude, existingGeocode.latitude],
      };
    }

    // If not found in database, call the OpenCage API
    const data = await opencage.geocode({ 
      q: address, 
      key: process.env.OPENCAGE_API_KEY || 'YOUR_OPENCAGE_API_KEY'
    });

    if (data.status.code === 200 && data.results.length > 0) {
      const place = data.results[0];
      
      // Save the geocoded result to our database for future use
      await ForwardGeoencode.create({
        address: address,
        longitude: place.geometry.lng,
        latitude: place.geometry.lat,
        formattedAddress: place.formatted
      });
      
      return {
        type: 'Point',
        coordinates: [place.geometry.lng, place.geometry.lat],
      };
    }
  } catch (error) {
    console.error('Geocoding error:', error.message);
  }

  return null;
};

export default geocodeAddress;
