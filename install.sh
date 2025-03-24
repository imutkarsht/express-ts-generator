#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Installing Express-TS Generator...${NC}"

# Installation directory
TARGET_DIR="/usr/local/bin"
if [ ! -d "$TARGET_DIR" ]; then
  TARGET_DIR="$HOME/.local/bin"
  mkdir -p "$TARGET_DIR"
  echo -e "${YELLOW}Added $TARGET_DIR to your PATH${NC}"
  echo "export PATH=\"\$PATH:$TARGET_DIR\"" >> ~/.bashrc
  echo "export PATH=\"\$PATH:$TARGET_DIR\"" >> ~/.zshrc
fi

# Download script
echo -e "${GREEN}Downloading generator...${NC}"
sudo curl -L https://raw.githubusercontent.com/imutkarsht/express-ts-generator/main/create-express-app.sh \
  -o "$TARGET_DIR/create-express-app"

# Make executable
sudo chmod +x "$TARGET_DIR/create-express-app"

echo -e "${GREEN}Installation complete!${NC}"
echo -e "Run: ${YELLOW}create-express-app${NC} to start a new project"
echo -e "${YELLOW}Note: You may need to restart your terminal${NC}"