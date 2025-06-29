import {
  IExecuteFunctions,
  INodeExecutionData,
  INodeType,
  INodeTypeDescription,
  NodePropertyTypes,
  NodeOperationError,
} from 'n8n-workflow';

export class CodeRunner implements INodeType {
  description: INodeTypeDescription = {
    displayName: 'Code Runner',
    name: 'codeRunner',
    icon: 'file:code-runner.svg',
    group: ['transform'],
    version: 1,
    description: 'Execute custom JavaScript code on your data',
    defaults: {
      name: 'Code Runner',
    },
    inputs: ['main'],
    outputs: ['main'],
    properties: [
      {
        displayName: 'JavaScript Code',
        name: 'jsCode',
        type: 'string' as NodePropertyTypes,
        typeOptions: {
          editor: 'code',
          editorLanguage: 'javascript',
          rows: 15,
        },
        default: `// Transform input data
const result = {
  ...items[0].json,
  processed: true,
  timestamp: new Date().toISOString(),
  customField: 'Hello from Code Runner!'
};

return [result];`,
        description: 'Enter your custom JavaScript code here',
      },
    ],
  };

  async execute(this: IExecuteFunctions): Promise<INodeExecutionData[][]> {
    const items = this.getInputData();
    const jsCode = this.getNodeParameter('jsCode', 0) as string;

    try {
      const context = {
        items,
        console: console,
      };

      const func = new Function(...Object.keys(context), jsCode);
      const result = func(...Object.values(context));

      let returnData: INodeExecutionData[] = [];

      if (Array.isArray(result)) {
        returnData = result.map(item => ({
          json: typeof item === 'object' ? item : { value: item }
        }));
      } else if (result !== null && result !== undefined) {
        returnData = [{
          json: typeof result === 'object' ? result : { value: result }
        }];
      } else {
        returnData = items;
      }

      return [returnData];

    } catch (error) {
      throw new NodeOperationError(
        this.getNode(),
        `Code execution failed: ${error.message}`,
      );
    }
  }
}
