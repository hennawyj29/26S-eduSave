import streamlit as st
import requests
import pandas as pd
import math

import logging
logger = logging.getLogger(__name__)
from modules.nav import SideBarLinks
SideBarLinks()

BASE_URL = "http://localhost:4000"

# calculation of latitudes and longitudes for location on earth
def calc_lat_lon(lat1, lng1, lat2, lng2):
    R = 6371
    d_lat = math.radians(lat2 - lat1)
    d_lng = math.radians(lng2 - lng1)
    a = math.sin(d_lat/2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(d_lng/2)**2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))



# fetch universities for dropdown
try:
    uni_res = requests.get(f"{BASE_URL}/s/universities")
    uni_res.raise_for_status()
    uni_data = uni_res.json()
    uni_options = {u["Uni_Name"]: (u["Uni_Lat"], u["Uni_Lng"]) for u in uni_data if u.get("Uni_Lat") and u.get("Uni_Lng")}
except Exception:
    # fall back to the universities in the mock data that have coordinates
    uni_options = {
        "Northeastern University": (42.3398, -71.0892),
        "Boston University":       (42.3505, -71.1054),
        "MIT":                     (42.3601, -71.0942),
    }

# sidebar filters
st.sidebar.subheader("Filters")

default_uni = next((name for name in uni_options if "USC" in name), list(uni_options.keys())[0])
selected_uni = st.sidebar.selectbox("University", list(uni_options.keys()), index=list(uni_options.keys()).index(default_uni))

radius = st.sidebar.slider("Radius (km)", 1, 50, 10, disabled=(selected_uni == "All"))

st.title(f"{selected_uni} Discount Map")

# fetch discounts
params = {}

try:
    res = requests.get(f"{BASE_URL}/s/discounts", params=params)
    res.raise_for_status()
    discounts = res.json()
except Exception as e:
    st.error(f"Could not load discounts: {e}")
    st.stop()


# filtering and sorting
if selected_uni != "All":
    uni_lat, uni_lng = uni_options[selected_uni]
    active = [
        d for d in discounts
        if d.get("Biz_Lat") is not None and d.get("Biz_Lng") is not None
        and calc_lat_lon(uni_lat, uni_lng, d["Biz_Lat"], d["Biz_Lng"]) <= radius
    ]
else:
    active = discounts


st.write(f"{len(active)} discount(s) found.")


# map
if st.sidebar.checkbox("Show map", value=True):
    map_df = pd.DataFrame([
        {"lat": d["Biz_Lat"], "lon": d["Biz_Lng"]}
        for d in active if d.get("Biz_Lat") and d.get("Biz_Lng")
    ])
    if not map_df.empty:
        st.map(map_df)


# discount table
if active:
    rows = [{
        "Business": d.get("Biz_Name"),
        "Discount":  f"{d.get('Disc_Amount')}% off",
        "Title":     d.get("Disc_Title"),
        "Category":  d.get("Category_Name"),
        "Promo":     d.get("Promo_Code") or "—",
    } for d in active]
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)
else:
    st.info("No discounts match your filters.")
