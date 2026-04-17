import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome Deal-Seeking College Student Athlete, {st.session_state['first_name']}.")
st.write('### What would you like to do today?')

if st.button('Browse All Discounts',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/11_World_Bank_Viz.py')

if st.button('Search Discounts by Category',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/12_World_Bank_Viz.py')

if st.button('Search Discounts Nearby',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/13_Map_Demo.py')

if st.button('My Favorite Stores',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/14_Map_Demo.py')