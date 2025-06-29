FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install community packages
RUN npm install -g n8n-nodes-deepseek --force

# Install TypeScript compiler for building custom nodes
RUN npm install -g typescript

# Copy custom node files
COPY custom-nodes/ /tmp/custom-nodes/

# Build the custom node
WORKDIR /tmp/custom-nodes
RUN tsc CodeRunner.node.ts --target es2020 --module commonjs --esModuleInterop --allowSyntheticDefaultImports

# Install the custom node globally
RUN mkdir -p /usr/local/lib/node_modules/wippli-code-runner
RUN cp CodeRunner.node.js /usr/local/lib/node_modules/wippli-code-runner/
RUN cp code-runner.svg /usr/local/lib/node_modules/wippli-code-runner/
RUN cp package.json /usr/local/lib/node_modules/wippli-code-runner/

# Switch back to node user
USER node

# Set working directory back
WORKDIR /home/node

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
