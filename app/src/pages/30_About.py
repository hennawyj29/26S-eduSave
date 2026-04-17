import streamlit as st
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

SideBarLinks()

st.write("# About this App")

st.markdown(
    """
    This is a demo app for EduSave! A student-focused app for disocunts all over the country. 

    The goal of this demo is to provide information on all of the recent dicounts and  
    deals avaliable for college students across the United States. With search features, 
    location services and more, EduSave is commited to providng students with an easy to use
    platform to promote healthy spending habits.

    From California to Boston, we have deals for everyone!
    """
)

# Add a button to return to home page
if st.button("Return to Home", type="primary"):
    st.switch_page("Home.py")
