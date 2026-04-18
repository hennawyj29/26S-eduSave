import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

# Show appropriate sidebar links for the role of the currently logged in user
SideBarLinks()

st.title(f"Welcome International College Student, {st.session_state['first_name']}.")
st.write('### What would you like to do today?')

if st.button('Restaurant Discount Search',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/01_Restaurant_Deals.py')

if st.button('Clothing Discount Search ',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/02_Clothing_Deals.py')

if st.button('My Deals',
             type='primary',
             use_container_width=True):
    st.switch_page('pages/03_My_Deals.py')
