import mongoose from "mongoose";

const lostPetSchema = new mongoose.Schema({
  name: { type: String, required: true },
  type: { type: String, default: 'lost' },
  breed: { type: String },
  description: { type: String },
  ownerName: { type: String },
  ownerPhone: { type: String },
  ownerEmail: { type: String, required: true },
  ownerId: { type: String, required: true },
  lastSeenDate: { type: Date, default: Date.now },
  address: { type: String },
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], default: [0, 0] },
  },
  photoUrls: { type: [String] },
  createdAt: { type: Date, default: Date.now },
});

lostPetSchema.index({ location: '2dsphere' });

const LostPet = mongoose.model("LostPet", lostPetSchema);
export default LostPet;
