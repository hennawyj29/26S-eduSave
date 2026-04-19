##################################################
# This is the main/entry-point file for the
# sample application for your project
##################################################

# Set up basic logging infrastructure
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# import the main streamlit library as well
# as SideBarLinks function from src/modules folder
import streamlit as st
from modules.nav import SideBarLinks

# streamlit supports regular and wide layout (how the controls
# are organized/displayed on the screen).
st.set_page_config(layout='wide')

# If a user is at this page, we assume they are not
# authenticated.  So we change the 'authenticated' value
# in the streamlit session_state to false.
st.session_state['authenticated'] = False

# Use the SideBarLinks function from src/modules/nav.py to control
# the links displayed on the left-side panel.
# IMPORTANT: ensure src/.streamlit/config.toml sets
# showSidebarNavigation = false in the [client] section
SideBarLinks(show_home=True)

# ***************************************************
#    The major content of this page
# ***************************************************

# For each of the user personas for which we are implementing
# functionality, we put a button on the screen that the user
# can click to MIMIC logging in as that mock user.


# STARTING IMPLEMENTATION HERE:

logger.info("Loading the Home page of the app")

st.title('edU Save')
st.write('#### Hi! As which user would you like to log in?')

# ------- Persona 1: Benito Fernandez Student (international student browser) -------
if st.button("Act as Benito Fernandez, an International College Student",
             type='primary',
             use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'international_student'
    st.session_state['first_name'] = 'Benito'
    logger.info("Logging in as Student Persona")
    st.switch_page('pages/00_Student_Home.py')

# ------- Persona 2: Mark Smith, Student (deal seeker) -------
if st.button("Act as Mark Smith, a Deal-Seeking College Student Athlete",
             type='primary',
             use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'student_athlete'
    st.session_state['first_name'] = 'Mark'
    logger.info("Logging in as Deal Seeker Persona")
    st.switch_page('pages/10_Student2_Home.py')

# ------- Persona 3: Sofia Reyes (Business Owner) -------
if st.button("Act as Sofia Reyes, a Business Owner",
             type='primary',
             use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'business_owner'
    st.session_state['first_name'] = 'Sofia'
    logger.info("Logging in as Business Owner Persona")
    st.switch_page('pages/20_Sophia_Home.py')

# ------- Persona 4: Jake Mallory (Admin) -------
if st.button("Act as Jake Mallory, a Platform Administrator",
             type='primary',
             use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'administrator'
    st.session_state['first_name'] = 'Jake'
    logger.info("Logging in as Administrator Persona")
    st.switch_page('pages/30_Jake_Home.py')
