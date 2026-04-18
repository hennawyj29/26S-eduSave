import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from modules.nav import SideBarLinks
 
st.set_page_config(layout='wide', page_title="My Deals")
SideBarLinks()
 
first = st.session_state.get('first_name', 'there')
student_id = st.session_state.get('student_id', 1)
 
st.title('My Saved Deals')
st.write(f"### Hi {first}! Here are all the deals you've saved.")
 
st.divider()

resp = requests.get(f'http://api:4000/s/saved-discounts/{student_id}', timeout=5)
saved_deals = resp.json() if resp.status_code == 200 else []
 
categories = list({d.get('Category_Name', 'Other') for d in saved_deals})
 
col1, col2 = st.columns(2)
col1.metric("Total Saved Deals", len(saved_deals))
col2.metric("Categories", len(categories))
 
st.divider()
 
st.subheader("➕ Save a New Deal")
with st.expander("Save a deal by Discount ID"):
    new_disc_id = st.number_input("Discount ID", min_value=1, step=1, value=1)
    if st.button("Save Deal", type="primary"):
        try:
            r = requests.post(
                'http://api:4000/s/saved-discounts',
                json={"Student_Id": student_id, "Discount_Id": int(new_disc_id)},
                timeout=5
            )
            if r.status_code in (200, 201):
                st.success(f"Deal #{new_disc_id} saved!")
                st.rerun()
            elif r.status_code == 409:
                st.info("You've already saved this deal.")
            else:
                st.warning("Could not save deal.")
        except Exception:
            st.error("Could not connect to the server. Please try again.")
 
st.divider()
 
st.subheader("Your Saved Deals")
all_cats = sorted({d.get('Category_Name', 'Other') for d in saved_deals})
selected_cat = st.selectbox("Filter by category", ["All"] + list(all_cats))
 
filtered = saved_deals if selected_cat == "All" else [
    d for d in saved_deals if d.get('Category_Name', 'Other') == selected_cat
]
 
st.write(f"**{len(filtered)} deal(s)**")
 
if not filtered:
    st.info("No deals in this category yet. Go browse and save some!")
else:
    for deal in filtered:
        with st.container(border=True):
            st.subheader(deal.get('Disc_Title', 'Untitled'))
            st.caption(f"{deal.get('Biz_Name', '')}")
            st.caption(f"{deal.get('Category_Name', '')}")
            st.caption(f"Saved {deal.get('Saved_At', '')}")
 
            amount = deal.get('Disc_Amount', 0)
            st.write(f"**{amount}% off**" if amount > 0 else "**Special offer**")
 
            promo = deal.get('Promo_Code')
            if promo:
                st.write(f"Promo code: `{promo}`")