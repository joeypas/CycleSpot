# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import scheduler_fn
from firebase_functions.options import set_global_options
import firebase_admin
from firebase_admin import initialize_app
from firebase_admin import firestore
from firebase_admin import credentials
import requests
import logging

cred = credentials.Certificate("./cyclespot-dc104-firebase-adminsdk-fbsvc-9eda8d6a15.json")

# For cost control, you can set the maximum number of containers that can be
# running at the same time. This helps mitigate the impact of unexpected
# traffic spikes by instead downgrading performance. This limit is a per-function
# limit. You can override the limit for each function using the max_instances
# parameter in the decorator, e.g. @https_fn.on_request(max_instances=5).
set_global_options(max_instances=10)

# Initialize app
app = initialize_app(cred)

# Get access to our firebase instance
db = firestore.client(app=app)

# This is the api we want to query, with the specified params
burlington_rack_url = "https://maps.burlingtonvt.gov/arcgis/rest/services/Bike_Racks/FeatureServer/0/query"
params = {
    "where": "1=1",
    "outFields": "*",
    "outSR": 4326,
    "f": "json",
}

# UVM bikes data
# https://services1.arcgis.com/1bO0c7PxQdsGidPK/ArcGIS/rest/services/UVM_Bicycle_Parking/FeatureServer/0/query

# Turn the json data we recieve into a dict with only the fields that we want
def extract_fields(feature):
    attrs = feature.get("attributes", {})
    geom = feature.get("geometry", {})

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
        "Latitude": geom.get("y"),
        "Longitude": geom.get("x"),
    }

# Run Once a day, query the api, format the data, and write to firestore
@scheduler_fn.on_schedule(schedule="0 0 * * 0")
def update_racks(_: scheduler_fn.ScheduledEvent) -> None:
    try:
        response = requests.get(burlington_rack_url, params=params, verify="./burlingtonvt-gov.pem")
        response.raise_for_status()
        json_data = response.json()

        raw_features = json_data.get("features", [])
        # We want to write our data all at once, not a bunch of times for each feature
        batch = db.batch()

        features = [extract_fields(f) for f in raw_features]

        for feature in features:
            doc_ref = db.collection("racks").document(feature["ID"])
            batch.set(doc_ref, feature)

        # Write all data at once
        batch.commit()
    except Exception as e:
        # We got an error, so log it and fail
        logging.error("Update Racks failed: {}".format(e.__str__()))
        raise(e)



