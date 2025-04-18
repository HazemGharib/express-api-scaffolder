# Scaffold a new router
# Usage: sh ./create-router.sh <singular-router-name>
# Example: sh ./create-router.sh post

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

# Check if the router name is provided
if [ -z "$1" ]; then
  echo "Please provide a singular router name. (eg. post, blog, user)"
  exit 1
fi
# Check if the router name is valid
if ! [[ "$1" =~ ^[a-zA-Z0-9_-]+$ ]]; then
  echo "Invalid router name. Only alphanumeric characters, underscores, and hyphens are allowed."
  exit 1
fi
# Check if routers folder exists
if [ ! -d "src/routers" ]; then
  echo "Routers folder does not exist. Creating it..."
  mkdir -p src/routers
fi

# Pluralize the router name
ROUTER_NAME=$(pluralize "$1")

# Check if the router already exists
if [ -d "src/routers/${ROUTER_NAME}Router" ]; then
  echo "Router '${ROUTER_NAME}Router' already exists."
  exit 1
fi
# Create src/routers/<router-name>s/<router-name>s.ts file
# Example: src/routers/posts/posts.ts
mkdir -p "src/routers/${ROUTER_NAME}Router"
cat <<EOF > src/routers/${ROUTER_NAME}Router/${ROUTER_NAME}Router.ts
import { Router, Request, Response } from 'express';
import { validateRequest } from '../../middlewares/validation/validateRequest';
import { idParamSchema, ${1}BodySchema, ${1}UpdateBodySchema } from './schema';

export const ${ROUTER_NAME}Router = Router();

// Get all ${ROUTER_NAME}
${ROUTER_NAME}Router.get(
  '/',
  (req: Request, res: Response) => {
  res.send({ ${1}: 'Get all $ROUTER_NAME' });
});

// Get a $1 by ID
${ROUTER_NAME}Router.get(
  '/:id',
  validateRequest({
    params: idParamSchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    res.send({ ${1}: \`${1} with ID: \${id}\` });
});

// Create a new $1
${ROUTER_NAME}Router.post(
  '/',
  validateRequest({
    body: ${1}BodySchema,
  }),
  (req: Request, res: Response) => {
    const { id, text } = req.body;
    res.send({ ${1}: \`${1} with ID: \${id} and text: \${text}\` });
});

// Update a ${1} by ID
${ROUTER_NAME}Router.patch(
  '/:id',
  validateRequest({
    params: idParamSchema,
    body: ${1}UpdateBodySchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    const { text } = req.body;
    res.send({ ${1}: \`${1} with ID: \${id} updated with text: \${text}\` });
});

// Update a ${1} by ID (PUT)
${ROUTER_NAME}Router.put(
  '/:id',
  validateRequest({
    params: idParamSchema,
    body: ${1}UpdateBodySchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    const { text } = req.body;
    res.send({ ${1}: \`${1} with ID: \${id} updated with text: \${text}\` });
});

// Delete a ${1} by ID
${ROUTER_NAME}Router.delete(
  '/:id',
  validateRequest({
    params: idParamSchema,
  }),
  (req: Request, res: Response) => {
    const { id } = req.params;
    res.send({ ${1}: \`${1} with ID: \${id} deleted\` });
});

EOF

# Create src/routers/<router-name>s/schema.ts file
# Example: src/routers/posts/schema.ts
cat <<EOF > src/routers/${ROUTER_NAME}Router/schema.ts
import { coerce, string, object } from 'zod';

export const idParamSchema = object({
  id: coerce.number().min(1),
});

export const ${1}BodySchema = object({
  id: coerce.number().min(1),
  text: string().min(1),
});

export const ${1}UpdateBodySchema = object({
  text: string().min(1),
});

EOF
