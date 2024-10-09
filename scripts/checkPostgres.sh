#!/bin/bash
# Check for PostgreSQL

# Determine which service is calling the script
if [[ "$1" == "billing" ]]; then
    SETUP_SQL="$BILLING_DIR/setup-db.sql"
elif [[ "$1" == "inventory" ]]; then
    SETUP_SQL="$INVENTORY_DIR/setup-db.sql"
else
    echo "Usage: $0 [billing|inventory]"
    exit 1
fi

if service postgresql status >/dev/null 2>&1; then
    echo "PostgreSQL service is active: $(psql --version)"
else
    echo "PostgreSQL is not installed. Installing..."
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl enable postgresql

    cp $SETUP_SQL /tmp/setup_db.sql
    
    # Create database and user
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
