import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout='wide', page_title="Competitor Listings")
SideBarLinks()

first = st.session_state.get('first_name', 'there')

st.title('Competitor Listings')
st.write(f"### Hi {first}! See how your discounts compare to nearby businesses.")

st.divider()

biz_id = st.number_input('Enter your Business ID', min_value=1, step=1, value=1)

resp = requests.get('http://api:4000/b/competitor-listings', params={"Biz_Id": biz_id}, timeout=5)

if resp.status_code == 200:
    listings = resp.json()

    search = st.text_input("Search competitors", placeholder="e.g. pizza, coffee...")
    if search:
        q = search.lower()
        listings = [l for l in listings if q in l.get('Biz_Name', '').lower()
                    or q in l.get('Disc_Title', '').lower()]

    st.write(f"**{len(listings)} competitor listing(s) found**")
    st.divider()

    if not listings:
        st.info("No competitor listings found.")
    else:
        for item in listings:
            with st.container(border=True):
                col1, col2 = st.columns([4, 1])
                with col1:
                    st.subheader(item.get('Disc_Title', 'Untitled'))
                    st.caption(f"{item.get('Biz_Name', 'Unknown')}")
                    amount = item.get('Disc_Amount', 0)
                    st.write(f"**{amount}% off**" if amount > 0 else "**Special offer**")
                with col2:
                    st.write(f"**Status:** {'Active' if item.get('Disc_Status') == 1 else 'Inactive'}")
elif resp.status_code == 404:
    st.error("Business not found. Please check your Business ID.")
else:
    st.error("Could not load competitor data.")