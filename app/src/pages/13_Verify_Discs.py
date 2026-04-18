import streamlit as st
import requests
import logging
logger = logging.getLogger(__name__)
from modules.nav import SideBarLinks
SideBarLinks()


st.title("Verify Discounts")

first = st.session_state.get('first_name', 'there')
st.write(f"### Hi {first}! Verify and mark any discounts as expired.")

# student ID input
student_id = st.number_input("Student ID", min_value=1, step=1)


# fetch all active discounts
try:
    res = requests.get("http://api:4000/s/discounts")
    res.raise_for_status()
    discounts = res.json()
except Exception as e:
    st.error(f"Could not load discounts: {e}")
    st.stop()

if not discounts:
    st.info("No discounts to verify.")
    st.stop()

st.write(f"{len(discounts)} discount(s) to verify.")
st.markdown("---")


# verify each discount
for d in discounts:
    disc_id = d.get("Discount_Id")
    with st.container(border=True):
        col1, col2, col3 = st.columns([3, 1, 1])
        with col1:
            st.markdown(f"**{d.get('Disc_Title')}**")
            st.caption(f"{d.get('Biz_Name')} · {d.get('Category_Name')} · {d.get('Disc_Amount')}% off")
            if d.get("Promo_Code"):
                st.caption(f"Promo: {d.get('Promo_Code')}")
        with col2:
            st.success("Active")
        with col3:
            if st.button("Mark expired", key=f"expired_{disc_id}"):
                try:
                    res = requests.put(f"{BASE_URL}/d/discounts/{disc_id}/status")
                    res.raise_for_status()
                    st.warning("Marked as expired")
                    st.rerun()
                except Exception as e:
                    st.error(f"Error: {e}")