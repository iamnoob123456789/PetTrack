# main.py
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.routing import APIRoute
from models.pet import Pet
from matching_engine import match_score
from database import pets_collection, matches_collection
from bson import ObjectId

app = FastAPI()

# allow frontend dev origins (add others if needed)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5000", "http://localhost:8000", "http://localhost:4200", "http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def _get_status_from_pet(pet_dict):
    # support both `status` and `type`
    return pet_dict.get("status") or pet_dict.get("type")

@app.on_event("startup")
async def _log_routes():
    print("FastAPI routes:")
    for route in app.router.routes:
        if isinstance(route, APIRoute):
            print(f"  PATH: {route.path}  METHODS: {sorted(route.methods)}")
    print("Docs: http://localhost:8000/docs (or change port)")

# POST /pets - add lost or found
@app.post("/pets")
def add_pet(pet: Pet):
    pet_dict = pet.dict()
    status = _get_status_from_pet(pet_dict)
    if not status:
        raise HTTPException(status_code=400, detail="Missing pet status/type")

    # insert to DB
    inserted = pets_collection.insert_one(pet_dict)
    pet_id = inserted.inserted_id

    # if found, run matching against lost pets
    if str(status).lower() == "found":
        lost_pets = list(pets_collection.find({"$or": [{"status": "lost"}, {"type": "lost"}]}))
        created_matches = []
        for lost in lost_pets:
            try:
                score = match_score(lost, pet_dict)
            except Exception as e:
                print("matching error:", e)
                continue
            try:
                score_val = float(score)
            except:
                continue
            if score_val >= 0.7:
                match_doc = {
                    "lost_pet_id": lost["_id"],
                    "found_pet_id": pet_id,
                    "match_score": score_val
                }
                matches_collection.insert_one(match_doc)
                # remove matched lost pet (business logic)
                pets_collection.delete_one({"_id": lost["_id"]})
                created_matches.append({
                    "lost_pet_id": str(lost["_id"]),
                    "found_pet_id": str(pet_id),
                    "match_score": score_val
                })

        return {"message": "Found pet added", "pet_id": str(pet_id), "matches": created_matches}

    return {"message": "Pet added", "pet_id": str(pet_id)}

# GET /pets  optionally filter by ?type=lost|found
@app.get("/pets")
def get_pets(type: str = None):
    query = {}
    if type and type.lower() in ("lost", "found"):
        query["$or"] = [{"type": type.lower()}, {"status": type.lower()}]
    docs = list(pets_collection.find(query).sort("createdAt", -1))
    out = []
    for d in docs:
        d["_id"] = str(d["_id"])
        out.append(d)
    return out

# GET /pets/matches
@app.get("/pets/matches")
def get_matches():
    docs = list(matches_collection.find().sort("match_score", -1))
    out = []
    for m in docs:
        out.append({
            "_id": str(m.get("_id")),
            "lost_pet_id": str(m.get("lost_pet_id")),
            "found_pet_id": str(m.get("found_pet_id")),
            "match_score": m.get("match_score")
        })
    return {"matches": out}
