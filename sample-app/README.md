# RAG Agent Platform - Sample Web Application

This is a sample React web application for the RAG (Retrieval-Augmented Generation) Agent Platform deployed on AWS Amplify.

## Features

- 🔍 **Semantic Search**: Search through documents using natural language
- 📚 **Document Retrieval**: Browse and view retrieved documents
- ⚡ **Real-time Processing**: Get instant results powered by AWS infrastructure
- 🎨 **Modern UI**: Responsive design with gradient theme

## Prerequisites

- Node.js 14+ and npm
- AWS Account with Amplify enabled
- GitHub repository (optional, for CI/CD)

## Installation

1. Navigate to the sample-app directory:
```bash
cd sample-app
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm start
```

The app will open at `http://localhost:3000`

## Building

To create a production build:
```bash
npm run build
```

This creates an optimized build in the `build/` directory.

## Deployment on AWS Amplify

### Option 1: With GitHub CI/CD

1. Push this code to a GitHub repository
2. Configure Amplify to connect to your GitHub repo
3. Amplify will automatically build and deploy on every push

### Option 2: Manual Deployment

1. Build the app locally: `npm run build`
2. Zip the `build/` directory
3. Upload to Amplify via the AWS Console or AWS CLI

### Using Terraform

The Terraform configuration in your root directory automatically deploys this app:

```bash
cd ..
terraform apply
```

Make sure to provide valid AWS credentials and VPC/subnet information in `terraform.tfvars`.

## Environment Variables

Set these in your `.env` file or Amplify console:

- `REACT_APP_API_ENDPOINT`: Backend API endpoint
- `REACT_APP_REGION`: AWS region
- `REACT_APP_COGNITO_CLIENT_ID`: Cognito client ID for authentication

## Architecture

- **Frontend**: React 18 with modern hooks
- **Hosting**: AWS Amplify
- **Backend**: AWS API Gateway → Lambda/ECS
- **Search**: OpenSearch for semantic search
- **Storage**: DynamoDB for metadata, S3 for documents

## Project Structure

```
src/
├── App.js           # Main React component
├── App.css          # App styling
├── index.js         # React entry point
└── index.css        # Global styles
public/
├── index.html       # HTML template
└── favicon.ico      # App icon
```

## Performance Optimization

- Code splitting enabled via React lazy loading
- CSS minification in production builds
- Caching rules configured in Amplify buildspec
- CDN distribution via Amplify's global network

## Support

For issues or questions, refer to the main project README.md in the root directory.
