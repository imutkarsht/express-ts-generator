#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const readline = require('readline');

// Color support without chalk
const colors = {
  red: (text) => `\x1b[31m${text}\x1b[0m`,
  green: (text) => `\x1b[32m${text}\x1b[0m`,
  yellow: (text) => `\x1b[33m${text}\x1b[0m`,
  blue: (text) => `\x1b[34m${text}\x1b[0m`
};

// Cross-platform console clear
function clearConsole() {
  process.stdout.write(
    process.platform === 'win32' ? '\x1B[2J\x1B[0f' : '\x1B[2J\x1B[3J\x1B[H'
  );
}

// Silent exec with error handling
function execute(command, options = {}) {
  try {
    execSync(command, { stdio: 'ignore', ...options });
    return true;
  } catch (error) {
    return false;
  }
}

// File templates
const templates = {
  tsconfig: `{
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
}`,

  indexTs: (port) => `import 'module-alias/register';
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

const PORT = process.env.PORT || ${port};
app.listen(PORT, () => {
  console.log(\`Server running on port \${PORT}\`);
});`,

  homeController: `import { Request, Response } from 'express';

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
};`
};

async function main() {
  clearConsole();
  console.log(colors.green('Express-TS Project Generator\n'));

  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  const question = (query, color = colors.blue) => new Promise(resolve => {
    rl.question(color(query), resolve);
  });

  try {
    // Get user input
    const projectName = await question('Enter project name (default: express-ts-app): ') || 'express-ts-app';
    const port = await question('Enter port number (default: 3000): ') || '3000';
    const addAuth = (await question('Add authentication? (y/n, default: n): ')).toLowerCase() === 'y';

    console.log(colors.green('\nCreating project...'));

    // Create project structure
    fs.mkdirSync(projectName);
    process.chdir(projectName);

    // Initialize project
    execute('npm init -y');
    execute(`npm install express dotenv cors ${addAuth ? 'bcryptjs jsonwebtoken' : ''}`);
    execute(`npm install --save-dev typescript ts-node @types/node @types/express @types/cors nodemon ${addAuth ? '@types/bcryptjs @types/jsonwebtoken' : ''}`);
    execute('npm install --save module-alias');
    execute('npm install --save-dev @types/module-alias');

    // Create files
    fs.writeFileSync('tsconfig.json', templates.tsconfig);
    execute('npm pkg set _moduleAliases.@="src"');

    // Create src structure
    const srcDirs = ['routes', 'controllers', 'middleware', 'utils', 'interfaces'];
    srcDirs.forEach(dir => fs.mkdirSync(path.join('src', dir), { recursive: true }));

    fs.writeFileSync(path.join('src', 'index.ts'), templates.indexTs(port));
    fs.writeFileSync(path.join('src', 'routes', 'index.ts'), `import { Router } from 'express';\nimport { homeController } from '@/controllers/home.controller';\n\nconst router = Router();\nrouter.get("/", homeController);\n\nexport default router;`);
    fs.writeFileSync(path.join('src', 'controllers', 'home.controller.ts'), templates.homeController);
    fs.writeFileSync('.env', `PORT=${port}\nJWT_SECRET=your_jwt_secret_here`);
    fs.writeFileSync('.gitignore', 'node_modules\ndist\n.env\n*.log\n.DS_Store\n.vscode\n.idea');

    // Configure scripts
    execute('npm pkg set scripts.build="tsc"');
    execute('npm pkg set scripts.start="node dist/index.js"');
    execute('npm pkg set scripts.dev="nodemon --exec ts-node src/index.ts"');
    execute('npm pkg set ts-node="{\\"require\\":[\\"module-alias/register\\"]}"');

    // Initialize Git
    if (execute('git --version')) {
      execute('git init');
      execute('git add .');
      execute('git commit -m "Initial commit"');
    }

    console.log(colors.green('\nProject created successfully!'));
    console.log(colors.yellow('\nNext steps:'));
    console.log(`1. cd ${projectName}`);
    console.log('2. npm run dev');
    console.log(`3. Open http://localhost:${port}`);

  } catch (error) {
    console.error(colors.red('\nError:'), error.message);
    process.exit(1);
  } finally {
    rl.close();
  }
}

main();