FROM n8nio/n8n:latest

# Switch to root user
USER root

# Install pnpm globally 
RUN npm install -g pnpm

# Try a simpler, more reliable community package first
RUN npm install -g n8n-nodes-html-css-to-image

# Switch back to node user
USER node

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
