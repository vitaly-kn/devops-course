#!/bin/bash
ARG="$1"
OPT_PARAM="$2"
DATABASE="users.db"
BACKUP_TEMPLATE="-users.db.backup"

check_db() {
    local ANSWER
    if [ ! -f "$DATABASE" ]; then
        read -rp "Database does not exist. Create it? [y/n] " -n 1 ANSWER
        echo
        if [[ "$ANSWER" = [yY] ]]; then
            touch "$DATABASE"
        else
            echo "Database was not created. Terminating program"
            exit 0
        fi
    fi
}

validated_read() {
    local PROMPT
    local INPUT
    PROMPT="$1"
    while :; do
        read -rp "$PROMPT " INPUT
        if [[ "$INPUT" =~ ^([A-Za-z])+$ ]]; then
            echo "$INPUT"
            return 0
        else
            >&2 echo "Only latin letters are allowed for this input! Try again"
        fi
    done
}

add() {
    local USERNAME
    local ROLE
    echo "Adding a user"
    USERNAME=$(validated_read "Username:")
    ROLE=$(validated_read "Role:")
    echo "$USERNAME, $ROLE" >>$DATABASE
}

backup() {
    local BACKUP
    echo "Backing up of the database..."
    BACKUP="$(date +%FT%T.%3N)$BACKUP_TEMPLATE"
    cp "$DATABASE" "$BACKUP"
    echo "Database's backup has been saved as $BACKUP"
}

restore() {
    local RESTORE
    echo "Searching for backups..."
    RESTORE=$(find -- *$BACKUP_TEMPLATE 2>/dev/null | sort -r | head -n 1)
    if [ "$RESTORE" != "" ]; then
        cp "$RESTORE" "$DATABASE"
        echo "Database has been restored from $RESTORE"
    else
        echo "No backups of the database found"
    fi
}

find_user() {
    local USERNAME
    local FOUND
    echo "Searching for user:"
    USERNAME=$(validated_read "Username:")
    FOUND=$(grep "^$USERNAME," "$DATABASE")
    if [ "$FOUND" != "" ]; then
        echo "$FOUND"
    else
        echo "User not found"
    fi
}

list() {
    echo "Users in database:"
    if [ "$OPT_PARAM" = '--inverse' ]; then
        nl -s ". " $DATABASE | (tac 2> /dev/null || tail -r)
    else
        nl -s ". " $DATABASE
    fi
}

help() {
    echo "Syntax: db.sh [add|backup|find|list|restore|help]"
    printf "\nOptions:\n"
    echo "  add                Add a user into database."
    echo "  backup             Backup the database."
    echo "  find               Verbose mode."
    echo "  list               List all entries of the database."
    echo "      , --inverse    List all entries of the database in inverted order."
    echo "  restore            Restore the database from the latest backup."
    echo "  help               Print this help."
    echo
}

# Main code

check_db

if [ "$ARG" = "" ]; then
    ARG="help"
fi

case $ARG in
add)
    add
    ;;
backup)
    backup
    ;;
restore)
    restore
    ;;
find)
    find_user
    ;;
list)
    list
    ;;
help)
    help
    ;;
*)
    echo "Unknown argument \"$ARG\"!"
    ;;
esac
