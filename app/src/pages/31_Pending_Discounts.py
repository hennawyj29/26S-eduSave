import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
import pandas as pd
from modules.nav import SideBarLinks

st.set_page_config(layout='wide', page_title="Pending Discounts")
SideBarLinks()

BASE_URL = "http://api:4000"

st.title('Pending Discounts')
st.write(f"### Hi {st.session_state.get('first_name', 'Admin')}! Review and approve pending discounts below.")

st.divider()

# fetch pending discounts
try:
    resp = requests.get(f'{BASE_URL}/a/discounts', timeout=5)
    pending = resp.json() if resp.status_code == 200 else []
except Exception as e:
    st.error(f"Could not load pending discounts: {e}")
    st.stop()

st.write(f"**{len(pending)} pending discount(s)**")

if not pending:
    st.success("No pending discounts to review. You're all caught up!")
else:
    for disc in pending:
        with st.container(border=True):
            col1, col2, col3 = st.columns([4, 1, 1])

            with col1:
                st.subheader(disc.get('Disc_Title', 'Untitled'))
                st.caption(f"Business ID: {disc.get('Biz_Id', 'Unknown')}")

                amount = disc.get('Disc_Amount', 0)
                st.write(f"**{amount}% off**" if amount > 0 else "**Special offer**")

                promo = disc.get('Promo_Code')
                if promo:
                    st.write(f"Promo code: `{promo}`")

            with col2:
                if st.button("Approve", key=f"approve_{disc.get('Discount_Id')}",
                             type="primary"):
                    try:
                        r = requests.put(
                            f"{BASE_URL}/d/discounts/{disc.get('Discount_Id')}/approve",
                            timeout=5
                        )
                        if r.status_code == 200:
                            st.success("Approved!")
                            st.rerun()
                        else:
                            st.warning(r.json().get("error", "Could not approve."))
                    except Exception:
                        st.error("Could not connect to the server. Please try again.")

            with col3:
                if st.button("Delete", key=f"delete_{disc.get('Discount_Id')}"):
                    try:
                        r = requests.delete(
                            f"{BASE_URL}/d/discounts/{disc.get('Discount_Id')}",
                            timeout=5
                        )
                        if r.status_code == 200:
                            st.success("Deleted!")
                            st.rerun()
                        else:
                            st.warning(r.json().get("error", "Could not delete."))
                    except Exception:
                        st.error("Could not connect to the server. Please try again.")

st.divider()

# bulk deactivate section
st.subheader("Bulk Actions")
with st.expander("Deactivate all discounts from unverified businesses"):
    st.write("This will deactivate all active discounts from businesses that have not been verified.")
    if st.button("Bulk Deactivate", type="primary"):
        try:
            r = requests.put(f"{BASE_URL}/d/discounts/bulk-deactivate", timeout=5)
            if r.status_code == 200:
                count = r.json().get("rows_affected", 0)
                st.success(f"Deactivated {count} discount(s) from unverified businesses.")
                st.rerun()
            else:
                st.warning("Could not complete bulk deactivation.")
        except Exception:
            st.error("Could not connect to the server. Please try again.")
