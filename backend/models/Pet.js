import mongoose from 'mongoose';

const petSchema = new mongoose.Schema({
  name: { type: String, required: true },
  type: { type: String, enum: ['lost', 'found'], required: true },
  breed: { type: String },
  description: { type: String },
  ownerName: { type: String },
  ownerPhone: { type: String },
  ownerEmail: { type: String },
  lastSeenDate: { type: Date, default: Date.now }, // Set default to current date
  address: { type: String },
  photoUrls: { type: [String] },
  ownerId: {
  type: String,
  required: true,
},
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model('Pet', petSchema);
