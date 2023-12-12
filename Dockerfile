# Step 1: Build the Next.js app in a Node.js environment
FROM node:16 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the rest of the app's source code
COPY . .

# Build the app
RUN npm run build

# Step 2: Serve the app using a Node.js server
FROM node:16 as runner

WORKDIR /app

# Copy the built app and necessary files from the builder stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the port the app runs on
EXPOSE 3000

# Command to run the app
CMD ["npm", "start"]
