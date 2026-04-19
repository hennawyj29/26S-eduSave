import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
import pandas as pd
from modules.nav import SideBarLinks

st.set_page_config(layout='wide', page_title="User Reports")
SideBarLinks()

BASE_URL = "http://api:4000"

st.title('User Reports')
st.write(f"### Hi {st.session_state.get('first_name', 'Admin')}! Here are the latest user reports, sorted by priority.")

st.divider()

# fetch reports
try:
    resp = requests.get(f'{BASE_URL}/a/reports', timeout=5)
    reports = resp.json() if resp.status_code == 200 else []
except Exception as e:
    st.error(f"Could not load reports: {e}")
    st.stop()

# filter by resolution status
filter_option = st.selectbox("Filter by status", ["All", "Unresolved", "Resolved"])

if filter_option == "Unresolved":
    reports = [r for r in reports if not r.get("Resolution")]
elif filter_option == "Resolved":
    reports = [r for r in reports if r.get("Resolution")]

st.write(f"**{len(reports)} report(s) found**")

if not reports:
    st.info("No reports match your filter.")
else:
    rows = [{
        "Report ID":   r.get("Report_Id"),
        "Student ID":  r.get("Student_Id"),
        "Discount ID": r.get("Discount_Id"),
        "Priority":    r.get("Priority"),
        "Reason":      r.get("Reason", "\u2014"),
        "Resolution":  r.get("Resolution") or "Pending",
        "Filed":       str(r.get("Filed_Date", ""))[:10],
    } for r in reports]
    st.dataframe(pd.DataFrame(rows), use_container_width=True, hide_index=True)
