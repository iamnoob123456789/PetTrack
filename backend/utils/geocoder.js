import opencage from 'opencage-api-client';
import dotenv from 'dotenv';

dotenv.config();

const geocodeAddress = async (address) => {
  if (!address) {
    return null;
  }

  try {
    const data = await opencage.geocode({ q: address, key: process.env.OPENCAGE_API_KEY });

    if (data.status.code === 200 && data.results.length > 0) {
      const place = data.results[0];
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
