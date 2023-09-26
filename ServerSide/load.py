import pandas as pd
import sqlite3
import requests
from io import StringIO


# Step 1: Download the CSV
url = "https://serval.uvm.edu/~rgweb/batch/curr_enroll_fall.txt"
response = requests.get(url, verify=False)
data = StringIO(response.text)

# Step 2: Read the CSV into a DataFrame
new_column_names = ["Subject", "CRN", "CourseTitle", "CompNumber", "Section", "Ptrm", "LecLab",
                    "Attribute", "CampusCode", "CollegeCode", "MaxEnrollment", "CurrentEnrollment",
                    "TrueMax", "StartTime", "EndTime", "Days", "Credits", "Building", "Room",
                    "GPInd", "Instructor", "NetId", "Email", "Fees", "XListings"]

# Step 2: Read the CSV into a DataFrame with new column names
df = pd.read_csv(data, header=0, names=new_column_names)
df.rename(columns={'#': 'CRN'}, inplace=True)

# Step 3: Load the DataFrame into an SQLite database
conn = sqlite3.connect("courses.db")
df.to_sql("courses", conn, if_exists="replace", index=False)
conn.close()
print("Data loaded into SQLite database!")
