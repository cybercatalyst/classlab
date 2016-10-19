service postgresql start
su postgres -c "psql -c \"CREATE USER demo WITH PASSWORD 'demo123' CREATEDB;\""
su postgres -c "psql -c \"CREATE DATABASE classlab_demo OWNER=demo TEMPLATE=template0 ENCODING='UTF8';\""
mix ecto.migrate && mix phoenix.server
