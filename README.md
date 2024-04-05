# SQL Case Study: Famous Paintings

This project involves analyzing data related to famous paintings stored in a MySQL database. The database contains tables for artists, museums, paintings, subjects, product details, and more.

## Purpose

The purpose of this project is to demonstrate proficiency in SQL queries and database management. By analyzing the provided dataset, various insights can be gained about the paintings, artists, museums, and their characteristics.

## Setup

### Requirements

- Python (3.x)
- Pandas
- SQLAlchemy
- MySQL Server

### Steps

1. Clone this repository to your local machine:

    ```bash
    git clone <repository_url>
    ```

2. Install the required Python packages:

    ```bash
    pip install pandas sqlalchemy
    ```

3. Ensure you have MySQL Server installed and running.

4. Create a MySQL database named `paintings`.

5. Update the connection string in the Python script `famous_paitings_script.ipynb` with your MySQL credentials and database name.

6. Run the Python script to import data into the database:

    ```bash
    python famous_paitings_script.ipynb
    ```

7. Execute SQL queries to retrieve insights from the database.

## SQL Queries

The SQL queries provided in the `famous_paitings.sql` file can be used to extract various insights from the database. Each query addresses a specific problem statement or analytical question related to the dataset.

## Problem Statements

1. Identify paintings with missing museum IDs.
2. Determine if there are museums without any paintings and remove invalid entries from museum hours.
3. Find paintings with an asking price higher than their regular price.
4. Identify paintings with an asking price less than 50% of their regular price.
5. Determine the canvas size that costs the most.
6. Remove duplicate records from various tables.
7. Identify museums with numeric values in their city names.
8. Remove invalid entries from museum hours.
9. Fetch the top 10 most famous painting subjects.
10. Identify museums open on both Sunday and Monday.
11. Determine the number of museums open every single day.
12. Identify the top 5 most popular museums based on the number of paintings.
13. Determine the top 5 most popular artists based on the number of paintings.
14. Display the 3 least popular canvas sizes.
15. Determine the museum open for the longest duration each day.
16. Identify the museum with the most number of paintings in the most popular painting style.
17. Identify artists whose paintings are displayed in multiple countries.
18. Display the country and city with the most number of museums.
19. Identify the most expensive and least expensive paintings and their respective artists and museums.
20. Determine the country with the 5th highest number of paintings.
21. Identify the 3 most popular and 3 least popular painting styles.
22. Determine the artist with the most number of portrait paintings outside the USA.


