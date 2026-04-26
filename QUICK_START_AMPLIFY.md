# 🚀 Quick Start: Deploy RAG Agent UI to AWS Amplify

## 3-Minute Deployment

### Step 1: Build the Sample App
```bash
cd sample-app
npm install
npm run build
```

### Step 2: Deploy with Terraform
```bash
cd ..
terraform init
terraform apply
```

When prompted to confirm, type `yes`.

### Step 3: Access Your App
After deployment completes, you'll see output like:
```
Outputs:
app_url = "https://dev.xxxxxxx.amplifyapp.com"
```

Visit that URL to see your RAG Agent UI running! 🎉

---

## With GitHub CI/CD (Recommended for Updates)

### 1. Create GitHub Repository
```bash
cd sample-app
git init
git add .
git commit -m "Initial: RAG Agent UI"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### 2. Get GitHub Token
- GitHub Settings → Developer settings → Personal access tokens
- Generate new token with `repo` scope
- Copy the token

### 3. Update terraform.tfvars
```hcl
github_token = "ghp_YOUR_TOKEN_HERE"
github_repo  = "https://github.com/YOUR_USERNAME/YOUR_REPO"
github_branch = "main"
```

### 4. Deploy
```bash
terraform apply
```

### 5. Now any push to main auto-deploys!
```bash
cd sample-app
# Make changes...
git push
# Done! Amplify automatically builds and deploys
```

---

## What You Get

✅ React-based search UI
✅ Semantic search interface  
✅ Cloud-hosted on AWS Amplify
✅ Automatic HTTPS with SSL
✅ Global CDN distribution
✅ Built-in CI/CD pipeline (with GitHub)

---

## Next Steps

1. **Connect Your Backend API**
   - Update `REACT_APP_API_ENDPOINT` in `terraform.tfvars`
   - Modify `sample-app/src/App.js` to call your API Gateway

2. **Add Authentication**
   - Connect to Cognito user pool
   - Update login flow in App.js

3. **Setup Custom Domain**
   - AWS Amplify Console → Domain Management
   - Add your custom domain

---

## Troubleshooting

**Build fails?**
```bash
cd sample-app && npm install && npm run build
```

**Need to see logs?**
```bash
# AWS Console → Amplify → Your App → Deployments
```

**Want to delete everything?**
```bash
terraform destroy
```

---

📖 See `AMPLIFY_DEPLOYMENT_GUIDE.md` for detailed information and advanced options.
