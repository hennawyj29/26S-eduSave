import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from modules.nav import SideBarLinks
 
st.set_page_config(layout='wide', page_title="Clothing Deals")
SideBarLinks()
 
first = st.session_state.get('first_name', 'there')
student_id = st.session_state.get('student_id', 1)
 
st.title('Clothing & Gift Deals')
st.write(f"### Hi {first}! Find clothing discounts at local shops and branded stores.")
 
search = st.text_input("Search deals", placeholder="e.g. jacket, hoodie, accessories...")
 
st.divider()
 
resp = requests.get('http://api:4000/s/discounts', params={"category_id": 2}, timeout=5)
deals = resp.json() if resp.status_code == 200 else []
 
if search:
    q = search.lower()
    deals = [d for d in deals if q in d.get('Disc_Title', '').lower()
             or q in d.get('Biz_Name', '').lower()]
 
local_deals   = [d for d in deals if d.get('Discount_Id', 0) % 2 == 0]
branded_deals = [d for d in deals if d.get('Discount_Id', 0) % 2 != 0]
 
tab1, tab2 = st.tabs(["Local Shops & Gifts", "Branded Stores"])
 
def render_deals(deal_list, tab_key):
    if not deal_list:
        st.info("No deals found in this category.")
        return
 
    st.write(f"**{len(deal_list)} deal(s) found**")
 
    for deal in deal_list:
        with st.container(border=True):
            col1, col2 = st.columns([4, 1])
 
            with col1:
                st.subheader(deal.get('Disc_Title', 'Untitled'))
                st.caption(f"{deal.get('Biz_Name', 'Unknown')}")
 
                amount = deal.get('Disc_Amount', 0)
                st.write(f"**{amount}% off**" if amount > 0 else "**Special offer**")
 
                promo = deal.get('Promo_Code')
                if promo:
                    st.write(f"Promo code: `{promo}`")
 
            with col2:
                if st.button("Save", key=f"save_{tab_key}_{deal.get('Discount_Id')}"):
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
 
with tab1:
    st.write("Local boutiques, gift shops and campus stores near you.")
    render_deals(local_deals, "local")
 
with tab2:
    st.write("Branded clothing stores with student discounts.")
    render_deals(branded_deals, "branded")