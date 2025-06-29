FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Force cache bust with current timestamp
RUN echo "Cache bust: 2025-06-29-18:10" 

# Install community packages
RUN npm install -g n8n-nodes-deepseek --force

# Switch back to node user
USER node

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
