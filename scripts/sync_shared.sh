#!/bin/bash

# Sync shared files from https://github.com/pexlit/Conventions
# Run this to update shared agents, conventions, and this script itself

set -e

REPO="pexlit/Conventions"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH"
API_URL="https://api.github.com/repos/$REPO/contents"
SELF="$(realpath "$0")"
BASE_DIR="."

# Self-update and re-exec if not already updated
if [ "$1" != "--updated" ]; then
    echo "Updating sync_shared.sh..."
    curl -fsSL "$BASE_URL/scripts/sync_shared.sh" -o "$SELF.tmp"
    mv "$SELF.tmp" "$SELF"
    chmod +x "$SELF"
    exec "$SELF" --updated
fi

# Function to recursively download a directory from GitHub
download_dir() {
    local remote_path="$1"
    local local_path="$2"

    mkdir -p "$local_path"

    # Get directory contents from GitHub API
    local contents=$(curl -fsSL "$API_URL/$remote_path?ref=$BRANCH" 2>/dev/null)

    # Process each item
    echo "$contents" | grep -E '"(name|type)"' | paste - - | while read -r line; do
        local name=$(echo "$line" | grep -o '"name": *"[^"]*"' | cut -d'"' -f4)
        local type=$(echo "$line" | grep -o '"type": *"[^"]*"' | cut -d'"' -f4)

        if [ "$type" == "file" ]; then
            echo "  - $remote_path/$name"
            curl -fsSL "$BASE_URL/$remote_path/$name" -o "$local_path/$name"
        elif [ "$type" == "dir" ]; then
            download_dir "$remote_path/$name" "$local_path/$name"
        fi
    done
}

# Download CONVENTIONS.md
echo "Downloading CONVENTIONS.md..."
echo "command: curl -fsSL "$BASE_URL/CONVENTIONS.md" -o ${BASE_DIR}/CONVENTIONS.md"
curl -fsSL "$BASE_URL/CONVENTIONS.md" -o ${BASE_DIR}/CONVENTIONS.md

# Download .claude/ folder recursively
echo "Downloading .claude/..."
download_dir ".claude" "${BASE_DIR}/.claude"

# Add synced files to .gitignore if not already present
echo "Updating .gitignore..."
touch $BASE_DIR/.gitignore

for entry in "CONVENTIONS.md" ".claude/" "scripts/sync_shared.sh"; do
    if ! grep -qxF "$entry" .gitignore; then
        echo "$entry" >> .gitignore
        echo "  Added $entry to .gitignore"
    fi
done

echo "Done!"
