import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout='wide', page_title="Manage Discounts")
SideBarLinks()

first = st.session_state.get('first_name', 'there')

st.title('Manage My Discounts')
st.write(f"### Hi {first}! Create a new discount or update an existing one.")

st.divider()

# Create a New Discount 
st.subheader('Create a New Discount')

with st.expander("Submit a new discount listing"):
    biz_id = st.number_input('Business ID', min_value=1, step=1)
    category_id = st.number_input('Category ID', min_value=1, step=1)
    disc_id = st.number_input('Discount ID', min_value=1, step=1)
    disc_title = st.text_input('Discount Title')
    disc_amount = st.number_input('Discount Amount (%)', min_value=0, max_value=100, step=1)
    promo_code = st.text_input('Promo Code (optional)')

    if st.button('Create Discount', type='primary'):
        if not disc_title:
            st.error('Discount title is required.')
        else:
            payload = {
                'Discount_Id': int(disc_id),
                'Biz_Id': int(biz_id),
                'Category_Id': int(category_id),
                'Disc_Title': disc_title,
                'Disc_Amount': int(disc_amount),
                'Disc_Status': 1,
                'Created_At': '2026-01-01 00:00:00',
                'Promo_Code': promo_code if promo_code else None
            }
            try:
                r = requests.post('http://api:4000/b/discounts', json=payload, timeout=5)
                if r.status_code == 201:
                    st.success('Discount created successfully!')
                else:
                    st.warning(f'Could not create discount: {r.json().get("error", "Unknown error")}')
            except Exception:
                st.error('Could not connect to the server. Please try again.')

st.divider()

# Update Discount Amount 
st.subheader('Update Discount Amount')

with st.expander("Edit an existing discount amount"):
    discount_id = st.number_input('Discount ID to Update', min_value=1, step=1)
    new_amount = st.number_input('New Discount Amount (%)', min_value=0, max_value=100, step=1)

    if st.button('Update Discount', type='primary'):
        payload = {'Disc_Amount': int(new_amount)}
        try:
            r = requests.put(f'http://api:4000/d/discounts/{int(discount_id)}/amount', json=payload, timeout=5)
            if r.status_code == 200:
                st.success('Discount updated successfully!')
            else:
                st.warning(f'Could not update discount: {r.json().get("error", "Unknown error")}')
        except Exception:
            st.error('Could not connect to the server. Please try again.')