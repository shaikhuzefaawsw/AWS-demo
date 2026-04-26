# AWS Amplify Deployment Guide for RAG Agent Platform

This guide walks you through deploying the sample web application to AWS Amplify.

## Prerequisites

- AWS Account with appropriate permissions
- Terraform installed (v1.0+)
- Node.js 14+ and npm
- Git (optional, for GitHub CI/CD)
- AWS CLI configured with credentials

## Step 1: Prepare the Sample Application

The sample React application is located in the `sample-app/` directory. It includes:
- React 18 frontend with semantic search UI
- Responsive design with gradient theme
- Sample document retrieval demo
- Integration ready for your backend APIs

## Step 2: Deploy Infrastructure with Terraform

### Option A: Deploy WITHOUT GitHub (Manual Upload)

1. Navigate to your Terraform root directory:
   ```bash
   cd /path/to/terrafromaws
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan
   ```

4. Apply the infrastructure:
   ```bash
   terraform apply
   ```

5. After deployment completes, note the Amplify app URL from the outputs

### Option B: Deploy WITH GitHub CI/CD (Recommended)

#### Prerequisites:
- GitHub account with a repository
- GitHub Personal Access Token with `repo` and `user` scopes

#### Steps:

1. **Create GitHub Repository:**
   ```bash
   cd sample-app
   git init
   git add .
   git commit -m "Initial commit: RAG Agent Platform sample app"
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

2. **Generate GitHub Token:**
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Click "Generate new token"
   - Select scopes: `repo`, `user`
   - Copy the token (you'll need this in the next step)

3. **Configure Terraform Variables:**
   
   Edit `terraform.tfvars` and add (or uncomment if present):
   ```hcl
   github_token = "YOUR_GITHUB_TOKEN_HERE"
   github_repo  = "https://github.com/YOUR_USERNAME/YOUR_REPO"
   github_branch = "main"
   ```

4. **Deploy:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. **Connect GitHub to Amplify (Manual Step):**
   - Go to AWS Amplify Console
   - Select your app
   - Click "Connected apps" or "Repository"
   - Follow prompts to authorize GitHub
   - Select your repository and branch
   - Amplify will automatically build and deploy on every push

## Step 3: Build the Application

### Local Build (for manual deployment):

```bash
cd sample-app
npm install
npm run build
```

This creates a `build/` directory with optimized production files.

### Amplify-Hosted Build:

If using GitHub CI/CD, Amplify automatically builds using the buildspec in `modules/amplify/main.tf`:
- Installs dependencies: `npm ci`
- Builds: `npm run build`
- Caches node_modules for faster builds
- Creates artifacts for deployment

## Step 4: Deploy to Amplify

### Method 1: GitHub Push (Automatic)
```bash
cd sample-app
# Make changes to your app
git add .
git commit -m "Update app"
git push origin main
# Amplify automatically builds and deploys!
```

### Method 2: Manual Upload (AWS Console)
1. Build locally: `npm run build`
2. Go to AWS Amplify Console
3. Select your app
4. Click "Upload build"
5. Select the `build/` folder
6. Deploy

### Method 3: AWS CLI
```bash
cd sample-app/build
amplify publish
```

## Step 5: Verify Deployment

1. **Check Amplify Console:**
   - AWS Amplify → Your App
   - View build status and deployment logs
   - Check the provisioned domain URL

2. **Test the Application:**
   - Navigate to the Amplify app URL (format: `https://branch-name.xxxxx.amplifyapp.com`)
   - Try the search functionality
   - Check browser console for any errors

3. **View Logs:**
   ```bash
   # Amplify deployment logs
   amplify logs
   ```

## Environment Variables

Set these in Amplify Console → App Settings → Environment Variables:

```
REACT_APP_API_ENDPOINT = https://your-api-gateway-url
REACT_APP_COGNITO_CLIENT_ID = your-cognito-client-id
REACT_APP_REGION = us-east-1
```

## Monitoring and Troubleshooting

### Check Build Status
```bash
# In AWS Console: Amplify → Deployments tab
```

### View Build Logs
- AWS Console → Amplify → App → Deployments → View logs

### Common Issues

**Issue: Build fails with "npm ci" error**
- Solution: Ensure `package.json` and `package-lock.json` are in the root of your repo

**Issue: Deployment succeeds but app shows 404**
- Solution: Check that `index.html` is in the `build/` directory
- Verify the custom routing rule in `modules/amplify/main.tf`

**Issue: GitHub integration not working**
- Verify GitHub token hasn't expired
- Check Amplify Console → Connected apps
- Re-authorize if needed

**Issue: Slow deployment**
- First deployment is slower (builds cache)
- Subsequent pushes should be faster
- Check node_modules caching in buildspec

## Updating the Application

### To update the sample app:

1. **Make changes** in `sample-app/src/`
2. **Test locally:**
   ```bash
   cd sample-app
   npm start  # Opens http://localhost:3000
   ```
3. **Push to GitHub** (if using CI/CD):
   ```bash
   git add .
   git commit -m "Update: new feature"
   git push
   ```
4. **Amplify automatically deploys** within 1-2 minutes

### To update backend API connections:

Edit `src/App.js` to call your actual backend APIs:

```javascript
const handleSubmit = async (e) => {
  e.preventDefault();
  setLoading(true);
  try {
    const response = await fetch(process.env.REACT_APP_API_ENDPOINT, {
      method: 'POST',
      body: JSON.stringify({ query }),
    });
    const data = await response.json();
    setResults(data.results);
  } catch (error) {
    console.error('API error:', error);
  }
  setLoading(false);
};
```

## Terraform Outputs

After deployment, Terraform will display:

```
Outputs:

app_id = "d1234567890abc"
app_url = "https://dev.d1234567890abc.amplifyapp.com"
default_domain = "d1234567890abc.amplifyapp.com"
deployment_instructions = <<EOT
    Sample RAG Application Deployment Instructions:
    ...
EOT
```

## Cleanup

To remove Amplify resources:

```bash
terraform destroy
```

⚠️ **Warning**: This will delete your Amplify app and all deployments.

## Next Steps

1. **Connect Backend APIs:**
   - Update `REACT_APP_API_ENDPOINT` to your API Gateway URL
   - Modify `App.js` to make real API calls

2. **Setup Authentication:**
   - Configure Cognito integration
   - Update login/logout flow in the app

3. **Custom Domain:**
   - Amplify Console → App Settings → Domain Management
   - Add your custom domain

4. **Enable HTTPS:**
   - Automatic with Amplify (free SSL certificate)

5. **Setup CI/CD Pipeline:**
   - Already configured with GitHub push
   - Add automated tests before deployment

## Support

For issues:
- Check Amplify Logs: AWS Console → Amplify → Deployments
- Review Terraform errors: `terraform plan`
- Check application console: Browser DevTools → Console tab

See the main `README.md` for additional project information.
