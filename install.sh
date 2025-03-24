#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}[1/3] Installing Express-TS Generator...${NC}"

# Installation directory
TARGET_DIR="$HOME/.local/bin"
mkdir -p "$TARGET_DIR"

# Download script
echo -e "${GREEN}[2/3] Downloading generator...${NC}"
curl -L https://raw.githubusercontent.com/imutkarsht/express-ts-generator/main/create-express-app.sh \
  -o "$TARGET_DIR/create-express-app"

# Make executable
chmod +x "$TARGET_DIR/create-express-app"

# Add to PATH if not already present
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
  echo -e "${YELLOW}[3/3] Adding to PATH...${NC}"
  echo "export PATH=\"\$PATH:$TARGET_DIR\"" >> ~/.bashrc
  echo "export PATH=\"\$PATH:$TARGET_DIR\"" >> ~/.zshrc
  source ~/.bashrc
fi

echo -e "${GREEN}Installation complete!${NC}"
echo -e "Run: ${YELLOW}create-express-app${NC} to start a new project"
echo -e "${YELLOW}If the command isn't found, try: source ~/.bashrc or restart your terminal${NC}"