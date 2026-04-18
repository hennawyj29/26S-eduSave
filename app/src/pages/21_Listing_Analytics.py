import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout='wide', page_title="Listing Analytics")
SideBarLinks()

first = st.session_state.get('first_name', 'there')

st.title('Listing Analytics')
st.write(f"### Hi {first}! Here's how your discount listings are performing.")

st.divider()

biz_id = st.number_input('Enter your Business ID', min_value=1, step=1, value=1)

resp = requests.get('http://api:4000/b/listing-analytics', params={"Biz_Id": biz_id}, timeout=5)

if resp.status_code == 200:
    analytics = resp.json()

    total_views = sum(a.get('Total_Views', 0) for a in analytics)
    total_saves = sum(a.get('Total_Saves', 0) for a in analytics)
    total_redemptions = sum(a.get('Total_Redemptions', 0) for a in analytics)

    col1, col2, col3 = st.columns(3)
    col1.metric("Total Views", total_views)
    col2.metric("Total Saves", total_saves)
    col3.metric("Total Redemptions", total_redemptions)

    st.divider()
    st.subheader("Your Listings")

    if not analytics:
        st.info("No analytics data found for this business.")
    else:
        for item in analytics:
            with st.container(border=True):
                col1, col2, col3, col4 = st.columns([3, 1, 1, 1])
                with col1:
                    st.subheader(item.get('Disc_Title', 'Untitled'))
                    amount = item.get('Disc_Amount', 0)
                    st.write(f"**{amount}% off**" if amount > 0 else "**Special offer**")
                col2.metric("Views", item.get('Total_Views', 0))
                col3.metric("Saves", item.get('Total_Saves', 0))
                col4.metric("Redemptions", item.get('Total_Redemptions', 0))
elif resp.status_code == 404:
    st.error("Business not found. Please check your Business ID.")
else:
    st.error("Could not load analytics data.")