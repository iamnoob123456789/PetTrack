import mongoose from "mongoose";

const foundPetSchema = new mongoose.Schema({
  name: { type: String, required: true },
  type: { type: String, default: 'found' },
  breed: { type: String },
  description: { type: String },
  reporterName: { type: String },
  reporterPhone: { type: String },
  reporterId: { type: String },
  lastSeenDate: { type: Date, default: Date.now },
  address: { type: String },
  location: {
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], default: [0, 0] },
  },
  photoUrls: { type: [String] },
  createdAt: { type: Date, default: Date.now },
});

foundPetSchema.index({ location: '2dsphere' });

const FoundPet = mongoose.model("FoundPet", foundPetSchema);
export default FoundPet;
