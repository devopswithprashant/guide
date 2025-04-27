#How to create a user (role) in PostgreSQL:

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

