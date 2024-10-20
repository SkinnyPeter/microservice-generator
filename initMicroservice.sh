#!/bin/bash

# Check if a microservice name was provided
if [ -z "$1" ]; then
  echo "Usage: $0 MicroserviceName"
  exit 1
fi

MICROSERVICE_NAME=$1

# Create the folder structure
mkdir -p $MICROSERVICE_NAME/{controllers,db,handler,models,routes,services,templates}

# Create files at the root of the microservice
touch $MICROSERVICE_NAME/.env
touch $MICROSERVICE_NAME/.gitignore
touch $MICROSERVICE_NAME/Dockerfile
touch $MICROSERVICE_NAME/index.js
touch $MICROSERVICE_NAME/INFO.md

# Navigate to the microservice directory
cd $MICROSERVICE_NAME

# Initialize Node.js project with npm init (default values)
npm init -y

# Ask for the desired port number
read -p "⚓ Which port do you want to use for the application? (default: 5000): " port
port=${port:-5000}  # Default to 5000 if no input is given

# Ask if MongoDB should be used
read -p "🍃 Do you want to set up MongoDB ? (y/n): " use_mongodb

if [ "$use_mongodb" = "y" ]; then
  # Install mongoose package
  npm install mongoose

  # Copy Mongoose connection template
  db_file="db/mongoDB.js"
  sed templates/template_mongoDB/template_mongoDB_basic.js > $db_file
  echo "💾🛠️ MongoDB connection file created"

  # Ask for data types to create models and controllers
  echo "📊 Which data types do you need? (comma-separated, e.g., User,Product,Order)"
  read -p "Data types: " data_types

  # Convert comma-separated input into an array
  IFS=',' read -ra TYPES <<< "$data_types"

  # Generate boilerplate Mongoose schema and controller CRUD for each data type
  for type in "${TYPES[@]}"; do
    type=$(echo "$type" | tr -d ' ')  # Remove spaces
    model_file="models/${type}.js"
    controller_file="controllers/${type}Controller.js"

    # Copy Mongoose model template and replace placeholder
    sed "s/{{TYPE}}/${type}/g" templates/templateModel.js > $model_file
    echo "📐 Created model: $model_file"

    # Copy CRUD controller template and replace placeholder
    sed "s/{{TYPE}}/${type}/g" templates/templateController.js > $controller_file
    echo "🎮 Created CRUD controller: $controller_file"
  done

  echo "✅ MongoDB setup completed. Mongoose installed, connection script created, models and CRUD controllers generated."
else
  echo "❌ Skipping MongoDB setup."
fi

# Create .env file
cat > .env <<EOL
MONGO_URI=mongodb://localhost:27017/${MICROSERVICE_NAME}
PORT=$port
EOL

# Create .gitignore file
cat > .gitignore <<EOL
node_modules/
.env
EOL

# Create Dockerfile
cat > Dockerfile <<EOL
# Use the official Node.js image.
FROM node:14

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port from the .env file
EXPOSE \${PORT}

# Command to run the app
CMD ["node", "index.js"]
EOL

# Create index.js file
cat > index.js <<EOL
const express = require('express');
const connectDB = require('./db/mongoDB');

const app = express();
app.use(express.json());

// Connect to MongoDB
connectDB();

// Sample route to test the server
app.get('/', (req, res) => {
  res.send('Welcome to the ${MICROSERVICE_NAME} API!');
});

// Define your routes here
// Example: app.use('/api/users', require('./controllers/userController'));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(\`Server is running on port \${PORT}\`);
});
EOL

echo "Configuration files created: .env, .gitignore, Dockerfile, and index.js"
echo "File structure and npm initialization completed for $MICROSERVICE_NAME"
