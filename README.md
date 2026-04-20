# README For edU Save
**edU Save is a student discount platform that connects college students to deals both locally and online. Students can search, save and even share discounts as per category or location. Business owners can use this platform to manage listings and look through their performance analytics. Admins can verify discounts, attending to any reports.

---
## Created by (Team Members):
- [Syesha Sen]
- [Laasya Gattu]
- [Julianne Conlee]
- [Jacy Hennawy]
- [Vedant Swarup]

---
## Demo Video
[https://drive.google.com/file/d/1h0yzKUbUNmJF0sdVdxMPhk5XsHh4rNiW/view?usp=sharing]

---
## Structure Of Project (Files)
```
├── api/                  # Flask REST API
│   └── backend/
│       ├── students/     # Student routes blueprint
│       ├── businesses/   # Business owner routes blueprint
│       ├── discounts/    # Discount management blueprint
│       └── admin/        # Admin routes blueprint
├── app/                  # Streamlit frontend
│   └── src/
│       ├── Home.py       # Landing page
│       ├── pages/        # All persona pages
│       └── modules/      # Shared nav/utilities
└── database-files/       # SQL schema and mock data
```
## User Personas used for app:
| Persona | Role | Description |
|---|---|---|
| Benito Fernandez | International Student | Browses discounts using categories, gets notifications on deals, and saves deals |
| Mark Smith | College Student (Athlete) | Filters deals using location and price, and shares discounts with friends |
| Sofia Reyes | Business Owner | Creates and looks through discounts, looks at business analytics |
| Jake Mallory | Admin | Approves discounts, looks through businesses, looks at metrics of platform |

## To Setup
### 1. Clone Repo
```bash
git clone https://github.com/hennawyj29/26S-eduSave.git
```

### 2. Create the '.env' File
```
SECRET_KEY=<yourSecretKey>
DB_USER=root
DB_HOST=db
DB_PORT=3306
DB_NAME=edusave
MYSQL_ROOT_PASSWORD=<yourPassword>
```

### 3. Start Docker Containers

### 4. Go to App
Type into browser:
```
http://localhost:8501
```