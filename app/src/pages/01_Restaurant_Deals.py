import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from modules.nav import SideBarLinks
 
st.set_page_config(layout='wide', page_title="Restaurant Deals")
SideBarLinks()
 
first = st.session_state.get('first_name', 'there')
student_id = st.session_state.get('student_id', 1)
 
st.title('Restaurant Deals')
st.write(f"### Hi {first}! Here are the latest food deals near campus.")
 
search = st.text_input("Search deals", placeholder="e.g. pizza, sandwich...")
promo_only = st.checkbox("Show promo code deals only")
 
st.divider()
 
resp = requests.get('http://api:4000/s/discounts', params={"category_id": 1}, timeout=5)
deals = resp.json() if resp.status_code == 200 else []
 
if search:
    q = search.lower()
    deals = [d for d in deals if q in d.get('Disc_Title', '').lower()
             or q in d.get('Biz_Name', '').lower()]
 
if promo_only:
    deals = [d for d in deals if d.get('Promo_Code')]
 
st.write(f"**{len(deals)} deal(s) found**")
 
if not deals:
    st.warning("No deals match your search. Try different keywords!")
else:
    for deal in deals:
        with st.container(border=True):
            col1, col2 = st.columns([4, 1])
 
            with col1:
                st.subheader(deal.get('Disc_Title', 'Untitled'))
                st.caption(f"{deal.get('Biz_Name', 'Unknown')}")
 
                amount = deal.get('Disc_Amount', 0)
                st.write(f"**{amount}% off**" if amount > 0 else "💰 **Free item / Free delivery**")
 
                promo = deal.get('Promo_Code')
                if promo:
                    st.write(f"Promo code: `{promo}`")
 
            with col2:
                if st.button("Save", key=f"save_{deal.get('Discount_Id')}"):
                    try:
                        r = requests.post(
                            'http://api:4000/s/saved-discounts',
                            json={"Student_Id": student_id, "Discount_Id": deal.get('Discount_Id')},
                            timeout=5
                        )
                        if r.status_code in (200, 201):
                            st.success("Saved!")
                        elif r.status_code == 409:
                            st.info("Already saved.")
                        else:
                            st.warning("Could not save.")
                    except Exception:
                        st.error("Could not connect to the server. Please try again.")


# example code   
import logging
logger = logging.getLogger(__name__)
import pandas as pd
import streamlit as st
import world_bank_data as wb
import matplotlib.pyplot as plt
import numpy as np
import plotly.express as px
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

# Call the SideBarLinks from the nav module in the modules directory
SideBarLinks()

# set the header of the page
st.header('Restaurant Deals')

# get the countries from the world bank data
with st.echo(code_location='above'):
    countries:pd.DataFrame = wb.get_countries()
   
    st.dataframe(countries)

# the with statment shows the code for this block above it 
with st.echo(code_location='above'):
    arr = np.random.normal(1, 1, size=100)
    test_plot, ax = plt.subplots()
    ax.hist(arr, bins=20)

    st.pyplot(test_plot)


with st.echo(code_location='above'):
    slim_countries = countries[countries['incomeLevel'] != 'Aggregates']
    data_crosstab = pd.crosstab(slim_countries['region'], 
                                slim_countries['incomeLevel'],  
                                margins = False) 
    st.table(data_crosstab)
