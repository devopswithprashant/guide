# User Management in PostgreSQL

## How to create a user (role) in PostgreSQL:

⸻

🔧 Syntax:
```sql
CREATE USER username WITH PASSWORD 'password';
```
✅ Example:
```sql
CREATE USER devuser WITH PASSWORD 'StrongPass123!';
```
This will create a basic user without any special privileges.

⸻

🔐 Optional: Grant privileges

1. Give the user permission to connect to a database:
```sql
GRANT CONNECT ON DATABASE yourdb TO devuser;
```
2. Give permission to use a specific schema:
```sql
GRANT USAGE ON SCHEMA public TO devuser;
```
3. Grant permission to select, insert, update, delete on all tables:
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO devuser;
```
4. Grant permission on future tables (optional):
```sql
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO devuser;
```

⸻

👑 If you want to make the user an admin (superuser):
```sql
CREATE USER devadmin WITH PASSWORD 'StrongAdminPass' SUPERUSER;
```
⚠️ Use superuser with caution – it has full access to the entire cluster.


## GRANT Permission to User/Role

To grant a PostgreSQL user the ability to log in and create databases, you can either set these at creation or alter an existing user.

⸻

✅ Option 1: Create a new user with login and create DB privileges
```sql
CREATE USER devuser WITH PASSWORD 'StrongPass123' LOGIN CREATEDB;
```

⸻

✅ Option 2: Grant login & createdb to an existing user

If the user already exists:
```sql
ALTER ROLE devuser WITH LOGIN CREATEDB;
```


## Delete a User

To delete (drop) a user in PostgreSQL, use the DROP ROLE or DROP USER command:

⸻

✅ Syntax:
```sql
DROP USER username;
```
or
```sql
DROP ROLE username;
```
Both do the same thing — DROP USER is just more semantic when you’re referring to login roles.

⸻

⚠️ Important: Make sure the user is not:
	•	Connected to any active sessions
	•	The owner of any databases, tables, or objects

If they are, you’ll get an error like:

ERROR: role "username" cannot be dropped because some objects depend on it

⸻

🔧 Steps to safely delete a user

1. Terminate any active connections:
```sql
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE usename = 'devuser';
```
2. Reassign or drop owned objects (optional, but often needed):
	•	To reassign all their objects to another user:

REASSIGN OWNED BY devuser TO anotheruser Or to drop all objects they own:
```sql
DROP OWNED BY devuser;
```
Run these while connected to each database where the user owns something.

3. Finally, drop the user:
```sql
DROP USER devuser;
```


