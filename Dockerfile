FROM n8nio/n8n:latest
USER root
RUN npm install -g n8n-nodes-deepseek --force
USER node
EXPOSE 5678
CMD ["n8n", "start"]
