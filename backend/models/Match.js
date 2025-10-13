import mongoose from "mongoose";

const matchSchema = new mongoose.Schema({
  foundPet: { type: mongoose.Schema.Types.ObjectId, ref: "FoundPet", required: true },
  lostPet: { type: mongoose.Schema.Types.ObjectId, ref: "LostPet", required: true },
  score: { type: Number, required: true },
  createdAt: { type: Date, default: Date.now },
});

const Match = mongoose.model("Match", matchSchema);
export default Match;
