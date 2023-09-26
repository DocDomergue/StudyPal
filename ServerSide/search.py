import sqlite3
import pandas as pd

pd.set_option('display.max_rows', None)  # Display all rows
pd.set_option('display.max_columns', None)  # Display all columns
pd.set_option('display.width', None)  # Ensure entire width is used for display


def search_database(conn, keyword):
    query = """
    SELECT Subject, CRN, CourseTitle FROM courses
    WHERE "Subject" LIKE ? OR "CRN" LIKE ? OR "CourseTitle" LIKE ? OR "Instructor" LIKE ? OR "Email" LIKE ? OR "Room" LIKE ? OR "Building" LIKE ?
    """

    results = conn.execute(query, ['%' + keyword + '%'] * 7).fetchall()

    selected_columns = ["Subject", "CRN", "CourseTitle"]
    df_results = pd.DataFrame(results, columns=selected_columns)
    print(df_results)


# Get user input and perform the search
keyword = input("Enter keyword to search: ")
with sqlite3.connect("courses.db") as conn:
    search_database(conn, keyword)

