import streamlit as st
import requests
import pandas as pd

import logging
logger = logging.getLogger(__name__)
from modules.nav import SideBarLinks
SideBarLinks()

BASE_URL = "http://localhost:4000"

st.title("My Saved Discounts")

# student ID input

student_id = st.number_input("Student ID", min_value=1, step=1)


# fetch saved discounts
try:
    res = requests.get(f"{BASE_URL}/s/saved-discounts/{int(student_id)}")
    res.raise_for_status()
    saved = res.json()
except Exception as e:
    st.error(f"Could not load saved discounts: {e}")
    st.stop()

st.write(f"{len(saved)} saved discount(s).")


# saved discounts table
if saved:
    rows = [{
        "Business": d.get("Biz_Name"),
        "Discount":  f"{d.get('Disc_Amount')}% off",
        "Title":     d.get("Disc_Title"),
        "Category":  d.get("Category_Name"),
        "Promo":     d.get("Promo_Code") or "—",
        "Saved on":  d.get("Saved_At", "")[:10],
    } for d in saved]
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)
else:
    st.info("No saved discounts yet.")