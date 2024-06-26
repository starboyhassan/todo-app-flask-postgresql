import os
import pytest
import psycopg2
from flask import Flask
from app import app, db_connection, add_task_to_database  


@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_add_task(client):
    # Test adding a task
    response = client.post('/add', data={'title': 'Test Task', 'description': 'Test Description'})
    assert response.status_code == 302  # Check for redirection
    with db_connection.cursor(cursor_factory=psycopg2.extras.DictCursor) as cursor:
        cursor.execute("SELECT * FROM tasks WHERE title = %s", ('Test Task',))
        task = cursor.fetchone()
        
    assert task is not None
    assert task['title'] == 'Test Task'
    assert task['description'] == 'Test Description'

def test_delete_task(client):
    # Add a task to delete
    add_task_to_database('Task to Delete', 'This task will be deleted')
    with db_connection.cursor(cursor_factory=psycopg2.extras.DictCursor) as cursor:
        cursor.execute("SELECT id FROM tasks WHERE title = %s", ('Task to Delete',))
        task = cursor.fetchone()
    
    # Test deleting the task
    response = client.post(f'/delete/{task["id"]}')
    assert response.status_code == 302  # Check for redirection
    with db_connection.cursor(cursor_factory=psycopg2.extras.DictCursor) as cursor:
        cursor.execute("SELECT * FROM tasks WHERE id = %s", (task["id"],))
        task = cursor.fetchone()
    assert task is None

def test_complete_task(client):
    # Add a task to complete
    add_task_to_database('Task to Complete', 'This task will be completed')
    with db_connection.cursor(cursor_factory=psycopg2.extras.DictCursor) as cursor:
        cursor.execute("SELECT id FROM tasks WHERE title = %s", ('Task to Complete',))
        task = cursor.fetchone()
    
    # Test completing the task
    response = client.post(f'/complete/{task["id"]}')
    assert response.status_code == 302  # Check for redirection
    with db_connection.cursor(cursor_factory=psycopg2.extras.DictCursor) as cursor:
        cursor.execute("SELECT is_complete FROM tasks WHERE id = %s", (task["id"],))
        is_complete = cursor.fetchone()['is_complete']
    assert is_complete == True

# Cleanup function to clear the tasks table after each test run
@pytest.fixture(autouse=True)
def cleanup():
    yield
    with db_connection.cursor() as cursor:
        cursor.execute("DELETE FROM tasks")
        db_connection.commit()
