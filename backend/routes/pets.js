import express from "express";
import upload from "../middleware/upload.js";
import { addLostPet, addFoundPet, getPets } from "../controllers/petsController.js";

const router = express.Router();

// Add lost pet
router.post("/lost", upload, addLostPet);

// Add found pet
router.post("/found", upload, addFoundPet);

// Get pets
router.get("/", getPets);

export default router;
