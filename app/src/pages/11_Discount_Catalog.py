import streamlit as st
import requests
import pandas as pd
import math

import logging
logger = logging.getLogger(__name__)
from modules.nav import SideBarLinks
SideBarLinks()

BASE_URL = "http://localhost:4000"

# sidebar filters
st.sidebar.subheader("Filters")

try:
    cat_res = requests.get(f"{BASE_URL}/s/discounts/categories")
    cat_res.raise_for_status()
    cat_data = cat_res.json()
    seen = set()
    unique_cats = []
    for c in cat_data:
        if c["Category_Name"] not in seen:
            seen.add(c["Category_Name"])
            unique_cats.append(c)
    cat_name_to_id = {c["Category_Name"]: c["Category_Id"] for c in unique_cats}
    category_options = ["All"] + list(cat_name_to_id.keys())
except Exception:
    cat_name_to_id = {}
    category_options = ["All", "Food", "Clothing", "Electronics", "Sports", "Books", "Health", "Travel"]

default_idx = category_options.index("Sports") if "Sports" in category_options else 0
selected_category = st.sidebar.selectbox("Category", category_options, index=default_idx)
sort = st.sidebar.selectbox("Sort by discount", ["Highest first", "Lowest first"])

st.title(f"{selected_category} Discount Catalog")

# fetch discounts
params = {}
if selected_category != "All" and selected_category in cat_name_to_id:
    params["category_id"] = cat_name_to_id[selected_category]

try:
    res = requests.get(f"{BASE_URL}/s/discounts", params=params)
    res.raise_for_status()
    discounts = res.json()
except Exception as e:
    st.error(f"Could not load discounts: {e}")
    st.stop()


# filtering and sorting
active = discounts

active.sort(key=lambda d: d.get("Disc_Amount", 0), reverse=(sort == "Highest first"))

st.write(f"{len(active)} discount(s) found.")


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
