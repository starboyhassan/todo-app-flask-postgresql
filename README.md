# todo-app-flask-postgresql

This is a simple web application built using Flask, a lightweight web framework in Python, and PostgreSQL, a powerful open-source relational database. The app allows users to manage their tasks with basic functionalities such as adding new tasks, marking tasks as complete, and deleting tasks. It provides a clean and intuitive interface for organizing daily tasks efficiently.

![](https://github.com/starboyhassan/todo-app-flask-postgresql/blob/main/screens/Web_Page_Screen.png)


## Prerequisites
Before you begin, ensure you have met the following requirements:

- [Python](https://www.python.org/downloads/)
- [PostgreSQL](https://www.postgresql.org/download/)

## Running the Application

### Setting Up the Database

1. Start your PostgreSQL server.
2. Create a new PostgreSQL database for the application.
3. Update the database configuration in `app.py` to match your PostgreSQL settings:

   - DB_HOST: localhost
   - DB_USER: your PostgreSQL username
   - DB_PASSWORD: your PostgreSQL password
   - DB_DATABASE: your database name
   - DB_PORT: your database port

4. Create a table in the database that will be used by your application
   ```
   CREATE TABLE tasks (
   id SERIAL PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   description TEXT,
   is_complete BOOLEAN DEFAULT false
   );
   ```

### Running Flask App

1. Clone the repository:

   ```
   git clone https://https://github.com/starboyhassan/todo-app-flask-postgresql
   ```

2. Create a virtual environment:

   ```
   python3 -m venv venv
   # on Windows use `python -m venv venv`
   ```
3. Activate virtual environment:

   ```
   source venv/bin/activate
   # On Windows use `venv\Scripts\activate`
   ```

4. Install the required dependencies:

   ```
   pip3 install -r requirements.txt
   # On Windows use `pip install -r requirements.txt`
   ```

4. Start the Flask application:

   ```
   python3 app.py
   # On Windows use `python app.py`
   ```

5. Access the application at `http://localhost:5000`.

### Running the Tests

This project includes a test suite to ensure the functionality of adding, deleting, and completing tasks works as expected. The tests are written using **pytest** and **pytest-flask**.

1. overview of test_app.py and what each test does:

- **test_add_task(client):** This test checks if a new task can be added successfully.
- **test_delete_task(client):** This test ensures that a task can be deleted correctly.
- **test_complete_task(client):** This test verifies that a task can be marked as complete.
- A cleanup fixture ensures that the tasks table is cleared after each test run to maintain isolation between tests.

2. Run the Tests:

```
pytest
```