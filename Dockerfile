FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install community packages that work
RUN npm install -g n8n-nodes-deepseek --force

# Switch back to node user
USER node

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
