import { uploadToCloudinary } from '../config/cloudinary.js'; 
import Pet from "../models/Pet.js";

export const addPet = async (req, res) => {
  try {
    console.log("📥 Incoming request to addPet");
    console.log("REQ.BODY:", req.body);

    const cleanBody = {};
    if (req.body && Object.keys(req.body).length > 0) {
      for (const [key, value] of Object.entries(req.body)) {
        cleanBody[key] = typeof value === "string" ? value.trim() : value;
      }
    }

    // ✅ Validate and parse lastSeenDate
    let lastSeenDate = cleanBody.lastSeenDate ? new Date(cleanBody.lastSeenDate) : undefined;
    if (lastSeenDate && isNaN(lastSeenDate.getTime())) {
      return res.status(400).json({ error: "Invalid lastSeenDate format" });
    }

    // ✅ Handle photoUrls directly (Flutter already sends array)
    let photoUrls = [];
    if (Array.isArray(cleanBody.photoUrls)) {
      photoUrls = cleanBody.photoUrls;
    }

    // ✅ Build pet data (use ownerId from body if no auth middleware)
    const petData = {
      name: cleanBody.name,
      type: cleanBody.type,
      breed: cleanBody.breed,
      description: cleanBody.description,
      ownerName: cleanBody.ownerName,
      ownerPhone: cleanBody.ownerPhone,
      ownerEmail: cleanBody.ownerEmail,
      lastSeenDate,
      address: cleanBody.address,
      photoUrls,
      ownerId: req.user?.uid || cleanBody.ownerId, // ✅ FIXED
    };

    // Validate required fields
    if (!petData.name || !petData.type || !petData.ownerId) {
      return res.status(400).json({ error: "Missing required fields: name, type, ownerId" });
    }

    const newPet = await Pet.create(petData);
    res.status(201).json({ message: "Pet added successfully", pet: newPet });
  } catch (error) {
    console.error("❌ Error in addPet controller:", error);
    res.status(500).json({ error: "An error occurred while adding the pet" });
  }
};


export const getPets = async (req, res) => {
  try {
    const filter = {};

    if (req.query.type && ["lost", "found"].includes(req.query.type.trim())) {
      filter.type = req.query.type.trim();
    }

    const pets = await Pet.find(filter).sort({ createdAt: -1 });
    res.status(200).json(pets);
  } catch (error) {
    console.error("Error fetching pets:", error);
    res.status(500).json({ error: "An error occurred while fetching pets" });
  }
};
