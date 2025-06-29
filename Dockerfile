FROM n8nio/n8n:latest

# Switch to root to install packages
USER root

# Install community packages
RUN npm install -g n8n-nodes-deepseek --force

# Create directory for custom node
RUN mkdir -p /usr/local/lib/node_modules/wippli-code-runner

# Copy custom node files directly (no compilation needed)
COPY custom-nodes/code-runner.svg /usr/local/lib/node_modules/wippli-code-runner/
COPY custom-nodes/package.json /usr/local/lib/node_modules/wippli-code-runner/

# Create a simple JavaScript version of the node
RUN echo 'const { NodeOperationError } = require("n8n-workflow"); \
class CodeRunner { \
  constructor() { \
    this.description = { \
      displayName: "Code Runner", \
      name: "codeRunner", \
      icon: "file:code-runner.svg", \
      group: ["transform"], \
      version: 1, \
      description: "Execute custom JavaScript code", \
      defaults: { name: "Code Runner" }, \
      inputs: ["main"], \
      outputs: ["main"], \
      properties: [{ \
        displayName: "JavaScript Code", \
        name: "jsCode", \
        type: "string", \
        typeOptions: { editor: "code", editorLanguage: "javascript", rows: 10 }, \
        default: "return [{ json: { ...items[0].json, processed: true } }];", \
        description: "JavaScript code to execute" \
      }] \
    }; \
  } \
  async execute() { \
    const items = this.getInputData(); \
    const jsCode = this.getNodeParameter("jsCode", 0); \
    try { \
      const func = new Function("items", jsCode); \
      const result = func(items); \
      return [result || items]; \
    } catch (error) { \
      throw new NodeOperationError(this.getNode(), "Code execution failed: " + error.message); \
    } \
  } \
} \
module.exports = { CodeRunner };' > /usr/local/lib/node_modules/wippli-code-runner/CodeRunner.node.js

# Switch back to node user
USER node

# Expose port
EXPOSE 5678

# Start n8n
CMD ["n8n", "start"]
