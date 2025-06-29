FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Cache bust - change timestamp to force rebuild
RUN echo "Build timestamp: 2025-06-29-18:45"

# Install community packages
RUN npm install -g n8n-nodes-deepseek --force
RUN npm install -g n8n-nodes-wippli-code-runner@1.0.1 --force

# Switch back to node user
USER node

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
