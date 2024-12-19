#!/usr/bin/env python3
import pymysql

# Function to retrieve data from MySQL database
def retrieve_data_from_db():
    # MySQL database connection parameters
    host = '10.0.0.4'
    user = 'python'
    password = 'passord'
    database = 'ansatte'
    table_name = 'employees'

    retrieved_data = []

    try:
        # Establish connection to the MySQL database
        connection = pymysql.connect(host=host,
                                     user=user,
                                     password=password,
                                     database=database)
        

        # Create a cursor object to interact with the database
        cursor = connection.cursor()

        # SQL query to retrieve data from a specific table (Change table_name and column_name)
        query = "SELECT * FROM "+ table_name+";"

        # Execute the query
        cursor.execute(query)

        # Fetch all results from the query
        results = cursor.fetchall()

        # Loop through and save the retrieved data
        for row in results:
            retrieved_data.append(row)

    except pymysql.MySQLError:
        pass
    finally:
        # Close the cursor and the connection
        if connection:
            cursor.close()
            connection.close()
    return retrieved_data

# Call the function to retrieve data
from_database = retrieve_data_from_db()

print("Content-Type: text/html")    # Tell the browser this is HTML content
print()  # Blank line after the header
# Your actual Python script here
print("<html><body><h1>")
print("Info from database:")
print()
for fosah in from_database:
    print(fosah)
print("</h1></body></html>")
