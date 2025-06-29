FROM n8nio/n8n:latest
USER root
RUN npm install -g n8n-nodes-text-manipulation n8n-nodes-base64
USER node
EXPOSE 5678
CMD ["n8n", "start"]
