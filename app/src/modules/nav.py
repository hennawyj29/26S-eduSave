# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has functions to add links to the left sidebar based on the user's role.

import streamlit as st


# ---- General ----------------------------------------------------------------

def home_nav():
    st.sidebar.page_link("Home.py", label="Home", icon="\ud83c\udfe0")


def about_page_nav():
    st.sidebar.page_link("pages/30_About.py", label="About", icon="\ud83e\udde0")


# ---- Role: International Student: Benito ------------------------------------------------

def student_home_nav():
    st.sidebar.page_link(
        "pages/00_Student_Home.py", label="International College Student Home", icon="\ud83d\udc64"
    )


def restaurant_deal_nav():
    st.sidebar.page_link(
        "pages/01_Restaurant_Deal.py", label="Restaurant Deals", icon="\ud83c\udf7d\ufe0f"
    )


def clothing_deals_nav():
    st.sidebar.page_link("pages/02_Clothing_Deals.py", label="Clothing Deals", icon="\ud83d\udc55")


def my_deals_nav():
    st.sidebar.page_link("pages/03_My_Deals.py", label="My Deals", icon="\ud83d\udd16")


# ---- Role: Student Athlete: Mark -----------------------------------------------------

def student2_home_nav():
    st.sidebar.page_link("pages/10_Student2_Home.py", label="Student Athlete Home", icon="\ud83c\udfe0"
    )

def discount_catalog_nav():
    st.sidebar.page_link("pages/11_Discount_Catalog.py", label="Discount Catalog", icon="\ud83d\udcc1"
    )

def discount_map_nav():
    st.sidebar.page_link("pages/12_Discount_Map.py", label="Discount Location Map", icon="\u2795"
    )

def verify_discs_nav():
    st.sidebar.page_link("pages/13_Verify_Discs.py", label="Verifying Discounts", icon="\ud83d\udcc8"
    )


# ---- Role: Business Owner: Sofia ----------------------------------------------------

def business_owner_home_nav():
    st.sidebar.page_link(
        "pages/20_Sophia_Home.py", label="Business Owner Home", icon="\ud83c\udfea"
    )

def listing_analytics_nav():
    st.sidebar.page_link(
        "pages/21_Listing_Analytics.py", label="Listing Analytics", icon="\ud83d\udcca"
    )

def competitor_listings_nav():
    st.sidebar.page_link(
        "pages/22_Competitor_Listings.py", label="Competitor Listings", icon="\ud83c\udfc6"
    )

def manage_discounts_nav():
    st.sidebar.page_link(
        "pages/23_Manage_Discounts.py", label="Manage Discounts", icon="\u270f\ufe0f"
    )


# ---- Role: Administrator: Jake Mallory --------------------------------------

def jake_home_nav():
    st.sidebar.page_link("pages/30_Jake_Home.py", label="Admin Home", icon="\ud83d\udee1\ufe0f")

def pending_discounts_nav():
    st.sidebar.page_link("pages/31_Pending_Discounts.py", label="Pending Discounts", icon="\ud83d\udccb")

def reports_nav():
    st.sidebar.page_link("pages/32_Reports.py", label="User Reports", icon="\ud83d\udea9")

def platform_metrics_nav():
    st.sidebar.page_link("pages/33_Platform_Metrics.py", label="Platform Metrics", icon="\ud83d\udcca")


# ---- Sidebar assembly -------------------------------------------------------

def SideBarLinks(show_home=False):
    """
    Renders sidebar navigation links based on the logged-in user's role.
    The role is stored in st.session_state when the user logs in on Home.py.
    """

    # Logo appears at the top of the sidebar on every page
    # Changing the logo to edU Save logo
    st.sidebar.image("assets/edUSaveLogo.png", width=150)

    # If no one is logged in, send them to the Home (login) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")

    if show_home:
        home_nav()

    if st.session_state["authenticated"]:

        if st.session_state["role"] == "international_student":
            student_home()
            restaurant_deals()
            clothing_deals()
            my_deals()

        if st.session_state["role"] == "student athlete":
            student2_home_nav()
            discount_catalog_nav()
            discount_map_nav()
            verify_discs_nav()


        if st.session_state["role"] == "administrator":
            jake_home_nav()
            pending_discounts_nav()
            reports_nav()
            platform_metrics_nav()

        if st.session_state["role"] == "business_owner":
            business_owner_home_nav()
            listing_analytics_nav()
            competitor_listings_nav()
            manage_discounts_nav()

    # About link appears at the bottom for all roles
    about_page_nav()

    if st.session_state["authenticated"]:
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")
