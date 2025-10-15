from sentence_transformers import SentenceTransformer, util
from geopy.distance import geodesic
from PIL import Image
import requests

model = SentenceTransformer("clip-ViT-B-32")


def get_image_features(image_url):
    try:
        response = requests.get(image_url, stream=True, timeout=5)
        image = Image.open(response.raw).convert("RGB")
        return model.encode(image, convert_to_tensor=True)
    except Exception as e:
        print("Image feature error:", e)
        return None


def get_text_features(pet):
    color = pet.get("color", "")
    breed = pet.get("breed", "")
    description = pet.get("description", "")
    text = f"{color} {breed} {description}".strip() or "unknown pet"
    return model.encode(text, convert_to_tensor=True)


def match_score(lost_pet, found_pet):
    # --- Image similarity ---
    image_sim = 0.0
    lost_url = lost_pet.get("image_url")
    found_url = found_pet.get("image_url")
    if lost_url and found_url:
        lost_img = get_image_features(lost_url)
        found_img = get_image_features(found_url)
        if lost_img is not None and found_img is not None:
            image_sim = util.cos_sim(lost_img, found_img).item()

    # --- Text similarity ---
    lost_text = get_text_features(lost_pet)
    found_text = get_text_features(found_pet)
    text_sim = util.cos_sim(lost_text, found_text).item()

    # --- Location similarity ---
    loc_score = 0.0
    try:
        lost_lat, lost_lon = lost_pet.get("latitude"), lost_pet.get("longitude")
        found_lat, found_lon = found_pet.get("latitude"), found_pet.get("longitude")
        if None not in (lost_lat, lost_lon, found_lat, found_lon):
            dist_km = geodesic((lost_lat, lost_lon), (found_lat, found_lon)).km
            loc_score = max(0, 1 - (dist_km / 50))
    except Exception as e:
        print("Location calc error:", e)

    # --- Weighted combination ---
    final_score = (0.4 * image_sim) + (0.4 * text_sim) + (0.2 * loc_score)
    return round(final_score, 3)
