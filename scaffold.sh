# Scaffold a new project using ExpressJS
# Usage: sh ./scaffold.sh <project-name>
# Check if project name is provided
if [ -z "$1" ]; then
  echo "Please provide a project name."
  exit 1
fi
# Check if project name is valid
if [[ ! "$1" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Project name can only contain letters, numbers, dashes, and underscores."
  exit 1
fi
# Check if project name already exists
if [ -d "$1" ]; then
  echo "Project name already exists. Please choose a different name."
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
cat <<EOL > tsconfig.json
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

EOL
# Install express and @types/express zod
yarn add express @types/express zod
# Make src directory
mkdir src
# Create src/index.ts file
cat <<"EOL" > src/index.ts
import express, { Request, Response } from 'express';
import { messagesRouter } from './routers/messagesRouter/messagesRouter';
import { logger } from './middlewares/logger/logger';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.use(logger);

app.use('/messages', messagesRouter);

app.get(['/', '/health'], (req: Request, res: Response) => {
  res.send({ status: 'OK' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

EOL

# Create src/routers directory
mkdir src/routers
# Create src/routers/messagesRouter directory
mkdir src/routers/messagesRouter
# Create src/routers/messagesRouter/messagesRouter.ts file
cat <<"EOL" > src/routers/messagesRouter/messagesRouter.ts
import { Router, Request, Response } from 'express';
import { validateRequest } from '../../middlewares/validation/validateRequest';
import { idParamSchema, messageBodySchema, messageUpdateBodySchema } from './schema';

export const messagesRouter = Router();

// Get all messages
messagesRouter.get(
  '/',
  (req: Request, res: Response) => {
  res.send({ message: 'Get all messages' });
});

// Get a message by ID
messagesRouter.get(
  '/:id',
  validateRequest({
    params: idParamSchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    res.send({ message: `Message with ID: ${id}` });
});

// Create a new message
messagesRouter.post(
  '/',
  validateRequest({
    body: messageBodySchema,
  }),
  (req: Request, res: Response) => {
    const { id, text } = req.body;
    res.send({ message: `Message with ID: ${id} and text: ${text}` });
});

// Update a message by ID
messagesRouter.patch(
  '/:id',
  validateRequest({
    params: idParamSchema,
    body: messageUpdateBodySchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    const { text } = req.body;
    res.send({ message: `Message with ID: ${id} updated with text: ${text}` });
});

// Update a message by ID (PUT)
messagesRouter.put(
  '/:id',
  validateRequest({
    params: idParamSchema,
    body: messageUpdateBodySchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    const { text } = req.body;
    res.send({ message: `Message with ID: ${id} updated with text: ${text}` });
});

// Delete a message by ID
messagesRouter.delete(
  '/:id',
  validateRequest({
    params: idParamSchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    res.send({ message: `Message with ID: ${id} deleted` });
});


EOL

# Create src/routers/messagesRouter/schema.ts file
cat <<"EOL" > src/routers/messagesRouter/schema.ts
import { coerce, string, object } from 'zod';

export const idParamSchema = object({
  id: coerce.number().min(1),
});

export const messageBodySchema = object({
  id: coerce.number().min(1),
  text: string().min(1),
});

export const messageUpdateBodySchema = object({
  text: string().min(1),
});

EOL

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
5. You can also use a tool like Postman to send a POST request to the /messages endpoint.
    1. Set the URL to http://localhost:3000/messages
    2. Set the method to POST
    3. Set the body to raw JSON and add a message object like this:
    \`\`\`json
    {
      "id": 1,
      "text": "Hello, world!"
    }
    \`\`\`
    4. Send the request
    5. You should see the message in the response.
6. You can also use a tool like Postman to send a GET request to the /messages/:id endpoint.
    1. Set the URL to http://localhost:3000/messages/1
    2. Set the method to GET
    3. Send the request
    4. You should see the message in the response.
## License
This project is licensed under the MIT License.
## Author
This project was created by Hazem Gharib

EOL

# Create collections directory
mkdir collections
# Create collections/<project_name>.json file
cat <<EOL > collections/$1.json
{
    "clientName": "Thunder Client",
    "collectionName": "$1",
    "collectionId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
    "dateExported": "2025-04-14T15:15:31.181Z",
    "version": "1.2",
    "folders": [
        {
            "_id": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "Messages",
            "containerId": "",
            "created": "2025-04-14T15:13:26.606Z",
            "sortNum": 10000
        }
    ],
    "requests": [
        {
            "_id": "6a3f3699-831f-4f55-aa9d-db5f1622f2e8",
            "colId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
            "containerId": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "Health",
            "url": "http://localhost:3000/health",
            "method": "GET",
            "sortNum": 10000,
            "created": "2025-04-14T13:34:08.830Z",
            "modified": "2025-04-14T13:53:02.856Z",
            "headers": []
        },
        {
            "_id": "8855bc00-a10b-4dc2-af85-528d43598a11",
            "colId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
            "containerId": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "GetAll",
            "url": "http://localhost:3000/messages",
            "method": "GET",
            "sortNum": 20000,
            "created": "2025-04-14T13:32:20.668Z",
            "modified": "2025-04-14T13:52:54.537Z",
            "headers": []
        },
        {
            "_id": "4d88a388-0fed-47e0-a57e-68a8831e9d45",
            "colId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
            "containerId": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "GetById",
            "url": "http://localhost:3000/messages/1",
            "method": "GET",
            "sortNum": 30000,
            "created": "2025-04-14T13:32:50.034Z",
            "modified": "2025-04-14T13:53:00.794Z",
            "headers": []
        },
        {
            "_id": "6038c87a-1459-4d23-9344-7e1ab7410ef4",
            "colId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
            "containerId": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "Post",
            "url": "http://localhost:3000/messages",
            "method": "POST",
            "sortNum": 40000,
            "created": "2025-04-14T13:33:10.843Z",
            "modified": "2025-04-14T13:53:20.138Z",
            "headers": [],
            "body": {
                "type": "json",
                "raw": "{\n  \"id\": \"1\",\n  \"text\": \"test\"\n}",
                "form": []
            }
        },
        {
            "_id": "54121267-4351-4584-982f-5bed3f058e94",
            "colId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
            "containerId": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "Put",
            "url": "http://localhost:3000/messages/1",
            "method": "PUT",
            "sortNum": 50000,
            "created": "2025-04-14T13:33:23.403Z",
            "modified": "2025-04-14T13:53:46.860Z",
            "headers": [],
            "body": {
                "type": "json",
                "raw": "{\n  \"text\": \"test\"\n}",
                "form": []
            }
        },
        {
            "_id": "54929cef-d321-4b56-9e25-e7762d016658",
            "colId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
            "containerId": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "Patch",
            "url": "http://localhost:3000/messages/1",
            "method": "PATCH",
            "sortNum": 60000,
            "created": "2025-04-14T13:33:36.156Z",
            "modified": "2025-04-14T13:53:59.069Z",
            "headers": [],
            "body": {
                "type": "json",
                "raw": "{\n  \"text\": \"test\"\n}",
                "form": []
            }
        },
        {
            "_id": "7e2c0071-4fa6-402b-a80f-3cd2aab11b0e",
            "colId": "bcf0437a-a1fe-4c75-b7bd-ff725587b86e",
            "containerId": "e4b3ee29-0c93-41e9-a2e7-9738608cd4c3",
            "name": "Delete",
            "url": "http://localhost:3000/messages/1",
            "method": "DELETE",
            "sortNum": 70000,
            "created": "2025-04-14T13:33:45.582Z",
            "modified": "2025-04-14T13:57:05.009Z",
            "headers": []
        }
    ],
    "ref": "LJPadTI7EurXngpb5hfvV3aN7HkNFxXLGQDXt6vPuxdN7JogDqKpsg7mGdlYoHP7R6K33m080LFP_3xo1_nRUg"
}

EOL

# Commit the changes
git add .
git commit -m "Initial commit"
# Print the instructions
echo "Project $1 created successfully!"
echo " Running the app in development..."
echo " Open your browser and go to http://localhost:3000"
# Run the app
yarn dev
