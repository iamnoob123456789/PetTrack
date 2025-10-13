import Pet from '../models/Pet.js';
import Match from '../models/Match.js';
import { uploadToCloudinary } from '../config/cloudinary.js';
import fetch from 'node-fetch'; // install node-fetch if Node < 18

const MATCHING_API_URL = process.env.MATCHING_API_URL || 'http://localhost:8000/match_score';
const VALID_TYPES = ['lost', 'found'];
const MATCH_THRESHOLD = parseFloat(process.env.MATCH_THRESHOLD || '0.7');

// simple notification placeholder
function sendNotification(lostPet, foundPet, score) {
  // implement push/email/SMS here; for now just log
  console.log(`Notify owner ${lostPet.ownerName} (${lostPet.ownerEmail || lostPet.ownerPhone}) — possible match with ${foundPet.ownerName}. score=${score}`);
}

// add a lost pet
export const addLostPet = async (req, res) => {
  try {
    console.log('addLostPet body:', req.body);
    console.log('files count:', req.files?.length ?? 0);

    const name = (req.body.name || '').trim();
    let type = (req.body.type || '').toString().trim().toLowerCase();
    if (!name) return res.status(400).json({ error: 'Missing name' });
    if (!VALID_TYPES.includes(type) || type !== 'lost') return res.status(400).json({ error: 'Invalid type (must be lost)' });

    // upload files
    const files = req.files || [];
    if (files.length === 0) return res.status(400).json({ error: 'No files uploaded' });
    if (files.length > 5) return res.status(400).json({ error: 'Max 5 images allowed' });

    const photoUrls = [];
    for (const file of files) {
      const result = await uploadToCloudinary(file.buffer);
      photoUrls.push(result.secure_url || result.url);
    }

    const petData = {
      name,
      type,
      breed: req.body.breed,
      description: req.body.description,
      ownerName: req.body.ownerName,
      ownerPhone: req.body.ownerPhone,
      ownerEmail: req.body.ownerEmail,
      lastSeenDate: req.body.lastSeenDate ? new Date(req.body.lastSeenDate) : undefined,
      address: req.body.address,
      photoUrls,
    };

    const saved = await Pet.create(petData);
    return res.status(201).json({ message: 'Lost pet added', pet: saved });
  } catch (err) {
    console.error('Error in addLostPet:', err);
    return res.status(500).json({ error: 'An error occurred while adding the lost pet' });
  }
};

// add a found pet and run matching
export const addFoundPet = async (req, res) => {
  try {
    console.log('addFoundPet body:', req.body);
    console.log('files count:', req.files?.length ?? 0);

    const name = (req.body.name || '').trim();
    let type = (req.body.type || '').toString().trim().toLowerCase();
    if (!name) return res.status(400).json({ error: 'Missing name' });
    if (!VALID_TYPES.includes(type) || type !== 'found') return res.status(400).json({ error: 'Invalid type (must be found)' });

    const files = req.files || [];
    if (files.length === 0) return res.status(400).json({ error: 'No files uploaded' });
    if (files.length > 5) return res.status(400).json({ error: 'Max 5 images allowed' });

    const photoUrls = [];
    for (const file of files) {
      const result = await uploadToCloudinary(file.buffer);
      photoUrls.push(result.secure_url || result.url);
    }

    const petData = {
      name,
      type,
      breed: req.body.breed,
      description: req.body.description,
      ownerName: req.body.ownerName,
      ownerPhone: req.body.ownerPhone,
      ownerEmail: req.body.ownerEmail,
      lastSeenDate: req.body.lastSeenDate ? new Date(req.body.lastSeenDate) : undefined,
      address: req.body.address,
      photoUrls,
    };

    // save found pet
    const foundPet = await Pet.create(petData);

    // call matching service with found pet data
    let matches = [];
    try {
      const response = await fetch(MATCHING_API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          type: 'found',
          pet: {
            id: foundPet._id,
            name: foundPet.name,
            breed: foundPet.breed,
            description: foundPet.description,
            photoUrls: foundPet.photoUrls,
          }
        })
      });

      if (!response.ok) {
        console.warn('Matching API returned non-ok status', response.status);
      } else {
        const data = await response.json();
        // Expect data to be array of { lostId, score } or similar
        matches = Array.isArray(data) ? data : (data.matches || []);
      }
    } catch (matchErr) {
      console.error('Matching API error:', matchErr);
    }

    // process matches above threshold
    const createdMatches = [];
    for (const m of matches) {
      const score = typeof m.score === 'number' ? m.score : parseFloat(m.score);
      if (isNaN(score)) continue;
      if (score < MATCH_THRESHOLD) continue;

      // fetch lost pet
      const lostPet = await Pet.findOne({ _id: m.lostId, type: 'lost' });
      if (!lostPet) continue;

      // create Match record
      const matchDoc = await Match.create({
        lostPetId: lostPet._id,
        foundPetId: foundPet._id,
        score,
        createdAt: new Date(),
      });

      // remove lost pet (or mark removed/matched depending on business logic)
      await Pet.deleteOne({ _id: lostPet._id });

      // notify owner
      sendNotification(lostPet, foundPet, score);

      createdMatches.push({ match: matchDoc, lostPet, score });
    }

    return res.status(201).json({
      message: 'Found pet added',
      foundPet,
      matches: createdMatches
    });
  } catch (err) {
    console.error('Error in addFoundPet:', err);
    return res.status(500).json({ error: 'An error occurred while adding the found pet' });
  }
};

// get pets (all or filtered by type)
export const getPets = async (req, res) => {
  try {
    const filter = {};
    if (req.query.type && ['lost', 'found'].includes(req.query.type)) {
      filter.type = req.query.type;
    }
    const pets = await Pet.find(filter).sort({ createdAt: -1 });
    return res.status(200).json(pets);
  } catch (err) {
    console.error('Error in getPets:', err);
    return res.status(500).json({ error: 'An error occurred while fetching pets' });
  }
};
