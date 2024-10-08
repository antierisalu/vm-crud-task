#!/bin/bash
# Check for PostgreSQL

if service postgresql status >/dev/null 2>&1; then
        echo "PostgreSQL service is active: $(psql --version)"
else
    echo "PostgreSQL is not installed. Installing..."
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl enable postgresql

    cp /vagrant/billing/setup-db.sql /tmp/setup_db.sql
    sudo -u postgres psql -f /tmp/setup_db.sql

    sudo systemctl restart postgresql

    if service postgresql status >/dev/null 2>&1; then
        echo "PostgreSQL service is active: $(psql --version)"
    else
        echo "PostgreSQL service is not active."
        exit 1
    fi
fi

exit 0
