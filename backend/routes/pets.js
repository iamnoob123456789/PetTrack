import express from "express";
import { addPet, getPets } from "../controllers/petsController.js";

const router = express.Router();

// Add new pet (JSON only, no multer)
router.post("/", addPet);

// Get pets
router.get("/", getPets);

export default router;
