import json
from firebase_admin import firestore
import requests
import logging
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

rack_url = "https://maps.burlingtonvt.gov/arcgis/rest/services/Bike_Racks/FeatureServer/0/query"
params = {
    "where": "1=1",
    "outFields": "*",
    "outSR": 4326,
    "f": "json",
}


# Turn the json data we recieve into a dict with only the fields that we want
def extract_fields(feature):
    attrs = feature.get("attributes", {})
    geom = feature.get("gometry", {})

    covered = attrs["Covered"]
    features = (
        [x.strip() for x in attrs["OtherFeatures"].split(",")] 
        if attrs["OtherFeatures"] else None
    )
    return {
        "ID": attrs.get("ASSETID"),
        "Address": attrs.get("RackLocation"),
        "Capacity": attrs.get("Capacity"),
        "Covered": (covered == "Yes" or covered == "1"), 
        "Features": features,
        "Location": firestore.firestore.GeoPoint(latitude=geom.get("y"), longitude=geom.get("x"))
    }

db = []

try:
    response = requests.get(rack_url, params=params, verify="./burlingtonvt-gov.pem")
    response.raise_for_status()
    json_data = response.json()

    raw_features = json_data.get("features", [])

    features = [extract_fields(f) for f in raw_features]

    for feature in features:
        db.append(feature)

    print(db)

except Exception as e:
    logging.error("Update Racks failed: {}".format(e.__str__()))
