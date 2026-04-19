import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout='wide', page_title="Platform Metrics")
SideBarLinks()

BASE_URL = "http://api:4000"

st.title('Platform Metrics Dashboard')
st.write(f"### Hi {st.session_state.get('first_name', 'Admin')}! Here's an overview of the platform.")

st.divider()

# fetch platform metrics
try:
    resp = requests.get(f'{BASE_URL}/a/platform-metrics', timeout=5)
    if resp.status_code == 200:
        metrics = resp.json()
    else:
        metrics = {"total_users": "\u2014", "active_discounts": "\u2014", "pending_reports": "\u2014"}
except Exception as e:
    st.error(f"Could not load metrics: {e}")
    metrics = {"total_users": "\u2014", "active_discounts": "\u2014", "pending_reports": "\u2014"}

# display metrics in columns
col1, col2, col3 = st.columns(3)
col1.metric("Total Users", metrics.get("total_users", "\u2014"))
col2.metric("Active Discounts", metrics.get("active_discounts", "\u2014"))
col3.metric("Pending Reports", metrics.get("pending_reports", "\u2014"))

st.divider()

# business account management
st.subheader("Business Account Management")
st.write("Activate or deactivate a business account by ID.")

biz_id = st.number_input("Business ID", min_value=1, step=1)
new_status = st.selectbox("Set status to", ["Active", "Inactive"])

if st.button("Update Business Status", type="primary"):
    try:
        status_val = "Active" if new_status == "Active" else "Inactive"
        r = requests.put(
            f"{BASE_URL}/a/businesses/{int(biz_id)}/status",
            json={"Account_Status": status_val},
            timeout=5
        )
        if r.status_code == 200:
            st.success(f"Business {int(biz_id)} status updated to {new_status}.")
        elif r.status_code == 404:
            st.warning("Business not found.")
        else:
            st.warning(r.json().get("error", "Could not update status."))
    except Exception:
        st.error("Could not connect to the server. Please try again.")
