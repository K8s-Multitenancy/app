# Stage 1: Fetching the node image and building the application
FROM node:18.18.2 AS builder

# Setting up the work directory
WORKDIR /skripsi-orders

# Copying package.json separately
COPY package.json ./

# Install pnpm
RUN npm install -g pnpm typescript

# Installing dependencies
RUN pnpm install

# Copying the rest of the application
COPY . .

# ✅ Ensure `drizzle.config.ts` is copied
RUN ls -la drizzle.config.ts

# Building our application
RUN pnpm run build

# Stage 2: Creating a lightweight image for production
FROM node:18.18.2-slim

# Declaring env
ENV PORT=8002
ENV NODE_ENV=production

# Set working directory
WORKDIR /skripsi-orders

# Copy built files from the previous stage
COPY --from=builder /skripsi-orders/dist ./dist
COPY --from=builder /skripsi-orders/package.json ./package.json
COPY --from=builder /skripsi-orders/drizzle.config.ts ./drizzle.config.ts 
COPY --from=builder /skripsi-orders/db/schema ./db/schema

# Install production dependencies only
RUN npm install --only=production

# Expose server port
EXPOSE 8002

# Start the application
CMD ["sh", "-c", "npm run generate && npm run push && node dist/src/server.js"]
