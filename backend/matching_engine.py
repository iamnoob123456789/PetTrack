# matching_engine.py
from sentence_transformers import SentenceTransformer, util
from geopy.distance import geodesic
from PIL import Image
import requests

model = SentenceTransformer("clip-ViT-B-32")

def get_image_features(image_url):
    response = requests.get(image_url, stream=True)
    image = Image.open(response.raw).convert("RGB")
    return model.encode(image, convert_to_tensor=True)

def get_text_features(pet):
    text = f"{pet['color']} {pet['breed']}"
    return model.encode(text, convert_to_tensor=True)

def match_score(lost_pet, found_pet):
    lost_img = get_image_features(lost_pet["image_url"])
    found_img = get_image_features(found_pet["image_url"])
    lost_text = get_text_features(lost_pet)
    found_text = get_text_features(found_pet)

    image_sim = util.cos_sim(lost_img, found_img).item()
    text_sim = util.cos_sim(lost_text, found_text).item()

    location_dist = geodesic(
        (lost_pet["latitude"], lost_pet["longitude"]),
        (found_pet["latitude"], found_pet["longitude"])
    ).km
    loc_score = max(0, 1 - (location_dist / 50))

    final_score = (0.4 * image_sim) + (0.4 * text_sim) + (0.2 * loc_score)
    return round(final_score, 3)
