import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}!")
st.write('### What would you like to do today?')

if st.button('View Listing Analytics',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/21_Listing_Analytics.py')

if st.button('View Competitor Listings',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/22_Competitor_Listings.py')

if st.button('Manage My Discounts',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/23_Manage_Discounts.py')
