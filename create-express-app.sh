#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get project name
echo -e "${BLUE}Enter project name (default: express-ts-app):${NC}"
read -r PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-express-ts-app}

# Get port number
echo -e "${BLUE}Enter port number (default: 3000):${NC}"
read -r PORT
PORT=${PORT:-3000}

# Auth selection
echo -e "${BLUE}Add authentication? (y/n, default: n):${NC}"
read -r ADD_AUTH
if [[ "$ADD_AUTH" =~ ^[Yy]$ ]]; then
  AUTH_PACKAGES="bcryptjs jsonwebtoken"
  AUTH_TYPES="@types/bcryptjs @types/jsonwebtoken"
else
  AUTH_PACKAGES=""
  AUTH_TYPES=""
fi

# Create project directory
echo -e "${GREEN}Creating project directory...${NC}"
mkdir "$PROJECT_NAME" && cd "$PROJECT_NAME" || exit

echo -e "${GREEN}Initializing Node.js project...${NC}"
npm init -y > /dev/null 2>&1

echo -e "${GREEN}Installing dependencies...${NC}"
npm install express dotenv cors $AUTH_PACKAGES > /dev/null 2>&1
npm install --save-dev typescript ts-node @types/node @types/express @types/cors nodemon $AUTH_TYPES > /dev/null 2>&1

echo -e "${GREEN}Setting up path resolution...${NC}"
npm install --save module-alias > /dev/null 2>&1
npm install --save-dev @types/module-alias > /dev/null 2>&1

echo -e "${GREEN}Configuring TypeScript...${NC}"
cat << EOT > tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "moduleResolution": "node",
    "baseUrl": "./src",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules"]
}
EOT

echo -e "${GREEN}Configuring module aliases...${NC}"
npm pkg set _moduleAliases.@="src" > /dev/null 2>&1

echo -e "${GREEN}Setting up project structure...${NC}"
mkdir -p src/{routes,controllers,middleware,utils,interfaces}
touch src/index.ts src/routes/index.ts src/controllers/home.controller.ts .env .gitignore

echo -e "${GREEN}Creating main application file...${NC}"
cat << EOT > src/index.ts
import 'module-alias/register';
import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import homeRouter from '@/routes/index';

dotenv.config();

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.use("/", homeRouter);

const PORT = process.env.PORT || ${PORT};
app.listen(PORT, () => {
  console.log(\`Server running on port \${PORT}\`);
});
EOT

echo -e "${GREEN}Setting up routes...${NC}"
cat << EOT > src/routes/index.ts
import { Router } from 'express';
import { homeController } from '@/controllers/home.controller';

const router = Router();

router.get("/", homeController);

export default router;
EOT

echo -e "${GREEN}Creating controller...${NC}"
cat << EOT > src/controllers/home.controller.ts
import { Request, Response } from 'express';

export const homeController = (req: Request, res: Response) => {
  try {
    res.status(200).json({ 
      message: "Hello from Utkarsh Tiwari!",
      description: "You're seeing this because you were too lazy to set up a Node.js/Express/TypeScript project yourself. Don't worry, I got you covered!",
      status: "success"
    });
  } catch (error) {
    res.status(500).json({
      message: "Internal Server Error",
      status: "error"
    });
  }
};
EOT

echo -e "${GREEN}Configuring environment...${NC}"
cat << EOT > .env
PORT=${PORT}
JWT_SECRET=your_jwt_secret_here
EOT

echo -e "${GREEN}Setting up .gitignore...${NC}"
cat << EOT > .gitignore
node_modules
dist
.env
*.log
.DS_Store
.vscode
.idea
EOT

echo -e "${GREEN}Configuring npm scripts...${NC}"
npm pkg set scripts.build="tsc" > /dev/null 2>&1
npm pkg set scripts.start="node dist/index.js" > /dev/null 2>&1
npm pkg set scripts.dev="nodemon --exec ts-node src/index.ts" > /dev/null 2>&1
npm pkg set scripts.lint="eslint . --ext .ts" > /dev/null 2>&1
npm pkg set scripts.format="prettier --write ." > /dev/null 2>&1
npm pkg set scripts.test="echo \"Error: no test specified\" && exit 1" > /dev/null 2>&1
npm pkg set "ts-node"="{\"require\":[\"module-alias/register\"]}" > /dev/null 2>&1

echo -e "${GREEN}Setting up linting and formatting...${NC}"
npm install --save-dev eslint prettier @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-config-prettier > /dev/null 2>&1
cat << EOT > .eslintrc.json
{
  "root": true,
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "prettier"
  ],
  "rules": {
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/no-unused-vars": "warn",
    "no-console": "warn"
  }
}
EOT

cat << EOT > .prettierrc
{
  "semi": true,
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "trailingComma": "all",
  "arrowParens": "avoid"
}
EOT

echo -e "${GREEN}Initializing Git repository...${NC}"
git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "Initial commit: Express + TypeScript setup" --quiet > /dev/null 2>&1

echo -e "${GREEN}Project setup completed successfully.${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. cd $PROJECT_NAME"
echo "2. Start development server: npm run dev"
echo "3. Build for production: npm run build"
echo "4. Run production: npm start"
echo ""
echo -e "${YELLOW}Project features:${NC}"
echo "- TypeScript configured with path aliases"
echo "- Express.js with middleware setup"
echo "- Environment variables ready"
echo "- Linting and formatting pre-configured"
echo "- Git initialized with initial commit"
echo ""
echo -e "${YELLOW}Access the API at: http://localhost:${PORT}${NC}"