FROM node:18-alpine

# Install dependencies
RUN apk add --update graphicsmagick tzdata

# Set timezone
ENV TZ=UTC

# Create app directory
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install n8n and dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

# Create data directory
RUN mkdir -p /home/node/.n8n

# Set permissions
RUN chown -R node:node /home/node/.n8n
RUN chown -R node:node /usr/src/app

# Switch to non-root user
USER node

# Expose port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

# Start n8n
CMD ["npm", "start"]
