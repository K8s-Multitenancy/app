# Stage 1: Fetching the node image and building the application
FROM node:18.18.2 AS builder

# Setting up the work directory
WORKDIR /skripsi-auth

# Copy package.json separately
COPY package.json ./

# Install pnpm
RUN npm install -g pnpm typescript

# Installing dependencies
RUN pnpm install

# Copying the rest of the application (including `drizzle.config.ts`)
COPY . .

# ✅ Ensure `drizzle.config.ts` is copied
RUN ls -la drizzle.config.ts

# Building our application
RUN pnpm run build

# Stage 2: Creating a lightweight image for production
FROM node:18.18.2-slim

# Declaring env
ENV PORT=8000
ENV NODE_ENV=production

# Set working directory
WORKDIR /skripsi-auth

# Copy built files from the previous stage
COPY --from=builder /skripsi-auth/dist ./dist
COPY --from=builder /skripsi-auth/package.json ./package.json
COPY --from=builder /skripsi-auth/drizzle.config.ts ./drizzle.config.ts 
COPY --from=builder /skripsi-auth/db/schema ./db/schema

# Install production dependencies only
RUN npm install --only=production

# Expose server port
EXPOSE 8000

# ✅ Run Drizzle Migrations at startup
CMD ["sh", "-c", "npm run generate && npm run push && node dist/src/server.js"]
