# Scaffold a new project using ExpressJS
# Usage: sh ./scaffold.sh <project-"name">
# Example: sh ./scaffold.sh my-project

# Pluralize a word
pluralize() {
  local word="$1"
  # Check if the word ends with 'y' and change 'y' to 'ies'
  if [[ "$word" =~ y$ ]]; then
    echo "${word%y}ies"
  # Check if the word ends with 's' or 'x' and change 's' to 'es'
  elif [[ "$word" =~ [sx]$ ]]; then
    echo "${word}es"
  # Otherwise just append an 's'
  else
    echo "${word}s"
  fi
}

# Check if project "name" is provided
if [ -z "$1" ]; then
  echo "Please provide a project "name"."
  exit 1
fi
# Check if project "name" is valid
if [[ ! "$1" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Project "name" can only contain letters, numbers, dashes, and underscores."
  exit 1
fi
# Check if project "name" already exists
if [ -d "$1" ]; then
  echo "Project "name" already exists. Please choose a different "name"."
  exit 1
fi
# Check node version
if ! command -v node &> /dev/null; then
  echo "Node.js is not installed. Please install Node.js and try again."
  exit 1
fi
# Check npm version
if ! command -v npm &> /dev/null; then
  echo "npm is not installed. Please install npm and try again."
  exit 1
fi
# Check yarn version
if ! command -v yarn &> /dev/null; then
  echo "yarn is not installed. Please install yarn and try again."
  exit 1
fi
# Make new directory
mkdir "$1"
cd "$1" || exit
# Initialize git
git init
# Initialize gitignore
echo "node_modules" > .gitignore
# Initialize npm
npm init -y
# Install typescript ts-node @types/node nodemon
yarn add typescript ts-node @types/node nodemon --dev
# Initialize typescript with target es2020
npx tsc --init --target es2020
# Replace tsconfig.json content
cat <<EOF > tsconfig.json
{
  "compilerOptions": {
    "target": "es2020",
    "module": "commonjs",
    "outDir": "./dist",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules"]
}

EOF
# Install express and @types/express zod
yarn add express @types/express zod
# Make src directory
mkdir src

ROUTER_NAME=sample
# Pluralize the router "name"
PLURAL_ROUTER_NAME=$(pluralize "$ROUTER_NAME")

# Create collections directory
mkdir collections
# Create collections/<project_name>.json file
cat <<EOL > collections/$1.json
{
    "clientName": "Thunder Client",
    "collectionName": "${1}",
    "collectionId": "50401041-1695-4c8e-8830-274fcbc73742",
    "dateExported": "2025-04-18T07:29:28.522Z",
    "version": "1.2",
    "folders": [],
    "requests": [
      {
          "_id": "bd5e5d51-3cf8-439a-b0dc-edd9fc3cdc40",
          "colId": "50401041-1695-4c8e-8830-274fcbc73742",
          "containerId": "",
          "name": "$PLURAL_ROUTER_NAME-health",
          "url": "http://localhost:3000/health",
          "method": "GET",
          "sortNum": 10000,
          "created": "2025-04-18T07:26:08.307Z",
          "modified": "2025-04-18T07:26:08.307Z",
          "headers": []
      },
      {
          "_id": "d4ce6f0a-4c65-4e87-a42d-8f503e55a543",
          "colId": "50401041-1695-4c8e-8830-274fcbc73742",
          "containerId": "",
          "name": "$PLURAL_ROUTER_NAME-get-all",
          "url": "http://localhost:3000/$PLURAL_ROUTER_NAME",
          "method": "GET",
          "sortNum": 20000,
          "created": "2025-04-18T07:26:08.308Z",
          "modified": "2025-04-18T07:26:08.308Z",
          "headers": []
      },
      {
          "_id": "ace8e68f-5b5d-4b0e-ad8f-9c7e39c2f8e0",
          "colId": "50401041-1695-4c8e-8830-274fcbc73742",
          "containerId": "",
          "name": "$PLURAL_ROUTER_NAME-get-by-id",
          "url": "http://localhost:3000/$PLURAL_ROUTER_NAME/1",
          "method": "GET",
          "sortNum": 30000,
          "created": "2025-04-18T07:26:08.309Z",
          "modified": "2025-04-18T07:26:08.309Z",
          "headers": []
      },
      {
          "_id": "ba5d9af2-5dc1-438e-b76a-ab59b49a4b48",
          "colId": "50401041-1695-4c8e-8830-274fcbc73742",
          "containerId": "",
          "name": "$PLURAL_ROUTER_NAME-post",
          "url": "http://localhost:3000/$PLURAL_ROUTER_NAME",
          "method": "POST",
          "sortNum": 40000,
          "created": "2025-04-18T07:26:08.310Z",
          "modified": "2025-04-18T07:26:08.310Z",
          "headers": [],
          "body": {
              "type": "json",
              "raw": "{\n  \"id\": \"1\",\n  \"text\": \"test\"\n}",
              "form": []
          }
      },
      {
          "_id": "049423d0-e285-4f4a-996a-a13c04f64b74",
          "colId": "50401041-1695-4c8e-8830-274fcbc73742",
          "containerId": "",
          "name": "$PLURAL_ROUTER_NAME-put",
          "url": "http://localhost:3000/$PLURAL_ROUTER_NAME/1",
          "method": "PUT",
          "sortNum": 50000,
          "created": "2025-04-18T07:26:08.311Z",
          "modified": "2025-04-18T07:26:08.311Z",
          "headers": [],
          "body": {
              "type": "json",
              "raw": "{\n  \"text\": \"test\"\n}",
              "form": []
          }
      },
      {
          "_id": "4000716a-f45a-406a-9a03-6fddc76fddfe",
          "colId": "50401041-1695-4c8e-8830-274fcbc73742",
          "containerId": "",
          "name": "$PLURAL_ROUTER_NAME-patch",
          "url": "http://localhost:3000/$PLURAL_ROUTER_NAME/1",
          "method": "PATCH",
          "sortNum": 60000,
          "created": "2025-04-18T07:26:08.312Z",
          "modified": "2025-04-18T07:26:08.312Z",
          "headers": [],
          "body": {
              "type": "json",
              "raw": "{\n  \"text\": \"test\"\n}",
              "form": []
          }
      },
      {
          "_id": "ec49fd57-1b41-4170-9746-cb4015d49c65",
          "colId": "50401041-1695-4c8e-8830-274fcbc73742",
          "containerId": "",
          "name": "$PLURAL_ROUTER_NAME-delete",
          "url": "http://localhost:3000/$PLURAL_ROUTER_NAME/1",
          "method": "DELETE",
          "sortNum": 70000,
          "created": "2025-04-18T07:26:08.313Z",
          "modified": "2025-04-18T07:26:08.313Z",
          "headers": []
      }
    ],
    "ref": "fWTzTa2Fas8xVnaS-gz7_gz1_RsASQbD-prNs9pxgQxh4_swOTR9bzT-RGobXxHgcXEjbC9WRW3oIISqyUzgEw"
}

EOL

# Create router using create-router.sh script
sh ../utils/create-router.sh $ROUTER_NAME

# Create src/index.ts file
cat <<EOF > src/index.ts
import express, { Request, Response } from 'express';
import { ${PLURAL_ROUTER_NAME}Router } from './routers/${PLURAL_ROUTER_NAME}Router/${PLURAL_ROUTER_NAME}Router';
import { logger } from './middlewares/logger/logger';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use(logger);

app.use('/${PLURAL_ROUTER_NAME}', ${PLURAL_ROUTER_NAME}Router);

app.get(['/', '/health'], (req: Request, res: Response) => {
  res.send({ status: 'OK' });
});

app.listen(PORT, () => {
  console.log(\`Server is running on port \${PORT} at http://localhost:\${PORT}\`);
});

EOF

# Create src/middlewares directory
mkdir src/middlewares
# Create src/middlewares/logger directory
mkdir src/middlewares/logger
# Create src/middlewares/logger/logger.ts file
cat <<"EOL" > src/middlewares/logger/logger.ts
import { Request, Response } from 'express';

export const logger = (req: Request, res: Response, next: () => void) => {
  const methodColors: { [key: string]: string } = {
    GET: '\x1b[32m', // Green
    POST: '\x1b[34m', // Blue
    PATCH: '\x1b[35m', // Magenta
    PUT: '\x1b[33m', // Yellow
    DELETE: '\x1b[31m', // Red
  };
  const color = methodColors[req.method as keyof typeof methodColors] || '\x1b[30m'; // Default color Grey
  console.info(`${color}[${req.method}]\x1b[0m:`, req.url);
  // console.debug('Headers:', req.headers); // Uncomment to log headers
  console.debug('Params:', req.params);
  console.debug('Body:', req.body);
  next();
}

EOL
# Create src/middlewares/validation directory
mkdir src/middlewares/validation
# Create src/middlewares/validation/validateRequest.ts file
cat <<"EOL" > src/middlewares/validation/validateRequest.ts
import { Request, Response, NextFunction } from 'express';
import { ZodTypeAny } from 'zod';

type RequestSource = 'body' | 'params' | 'query';

type SchemaMap = {
  body?: ZodTypeAny;
  params?: ZodTypeAny;
  query?: ZodTypeAny;
};

export const validateRequest = (schemas: SchemaMap) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    for (const key of Object.keys(schemas) as RequestSource[]) {
      const schema = schemas[key];
      const result = schema?.safeParse(req[key]);
      if (!result || !result?.success) {
        res.status(400).json({
          error: result?.error.errors || 'Invalid request',
          source: key,
        });
        return;
      }
      req[key] = result.data;
    };
    next();
  };
}

EOL

# Add a script to package.json to run the app
jq '.scripts += {"start": "ts-node src/index.ts"}' package.json > tmp.json && mv tmp.json package.json
# Add a script to package.json to run the app with nodemon
jq '.scripts += {"dev": "nodemon src/index.ts"}' package.json > tmp.json && mv tmp.json package.json
# Create a README file
cat <<EOL > README.md
# $1
This is a FeathersJS project scaffolded using the scaffold.sh script.
## Getting Started
1. Install dependencies
    \`\`\`bash
    yarn
    \`\`\`
2. Run the app
    \`\`\`bash
    yarn dev
    \`\`\`
3. Open your browser and go to http://localhost:3000/
4. You should see a message saying {"status": "OK"}.
5. You can also use a tool like Postman to send a POST request to the /${PLURAL_ROUTER_NAME} endpoint.
    1. Set the URL to http://localhost:3000/${PLURAL_ROUTER_NAME}
    2. Set the "method" to POST
    3. Set the body to raw JSON and add a message object like this:
    \`\`\`json
    {
      "id": 1,
      "text": "Hello, world!"
    }
    \`\`\`
    4. Send the request
    5. You should see the message in the response.
6. You can also use a tool like Postman to send a GET request to the /${PLURAL_ROUTER_NAME}/:id endpoint.
    1. Set the URL to http://localhost:3000/${PLURAL_ROUTER_NAME}/1
    2. Set the "method" to GET
    3. Send the request
    4. You should see the message in the response.
## License
This project is licensed under the MIT License.
## Author
This project was "created" by Hazem Gharib

EOL

# Commit the changes
git add .
git commit -m "Initial commit"
# Print the instructions
echo "Project $1 "created" successfully!"
echo " Running the app in development..."
echo " Open your browser and go to http://localhost:3000"
# Run the app
yarn dev
