#!/bin/bash

# Define base directory (directory where the script is located, adjust as needed)
BASE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
META_DIR="${BASE_DIR}/meta"
MODRINTH_DIR="${BASE_DIR}/modrinth"
CURSEFORGE_DIR="${BASE_DIR}/curseforge"

# Check if meta directory exists
if [ ! -d "${META_DIR}" ]; then
    echo "Error: meta directory ${META_DIR} does not exist!"
    exit 1
fi

# Ensure target directories exist (create if not present)
mkdir -p "${MODRINTH_DIR}"
mkdir -p "${CURSEFORGE_DIR}"

# Iterate over all files/directories in the meta directory
find "${META_DIR}" -mindepth 1 -print0 | while IFS= read -r -d '' item; do
    # Get relative path (relative to meta directory)
    rel_path="${item#${META_DIR}/}"
    # Target paths (modrinth and curseforge)
    modrinth_target="${MODRINTH_DIR}/${rel_path}"
    curseforge_target="${CURSEFORGE_DIR}/${rel_path}"

    # First delete the corresponding file/directory in modrinth (if it exists)
    if [ -e "${modrinth_target}" ]; then
        echo "Deleting ${modrinth_target}"
        rm -rf "${modrinth_target}"
    fi

    # First delete the corresponding file/directory in curseforge (if it exists)
    if [ -e "${curseforge_target}" ]; then
        echo "Deleting ${curseforge_target}"
        rm -rf "${curseforge_target}"
    fi

    # Copy content from meta to modrinth
    if [ -d "${item}" ]; then
        echo "Copying directory ${item} to ${modrinth_target}"
        cp -r "${item}" "${modrinth_target}"
    else
        echo "Copying file ${item} to ${modrinth_target}"
        # Ensure the parent directory of the target file exists
        mkdir -p "$(dirname "${modrinth_target}")"
        cp "${item}" "${modrinth_target}"
    fi

    # Copy content from meta to curseforge
    if [ -d "${item}" ]; then
        echo "Copying directory ${item} to ${curseforge_target}"
        cp -r "${item}" "${curseforge_target}"
    else
        echo "Copying file ${item} to ${curseforge_target}"
        # Ensure the parent directory of the target file exists
        mkdir -p "$(dirname "${curseforge_target}")"
        cp "${item}" "${curseforge_target}"
    fi
done

echo "Synchronization completed!"
exit 0