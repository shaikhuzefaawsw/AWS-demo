# 📋 Deployment Quick Reference Card

## Print This! 📠

---

## 🚀 Deploy in 3 Commands

```bash
# 1. Build the app
cd sample-app && npm install && npm run build && cd ..

# 2. Deploy infrastructure
terraform init && terraform apply

# 3. Visit your app
# Copy URL from terraform output and open in browser
# Format: https://dev.xxxxxxx.amplifyapp.com
```

---

## 📚 Documentation Guide

| Situation | Read This |
|-----------|-----------|
| **I want to deploy NOW** | QUICK_START_AMPLIFY.md |
| **I want full details** | AMPLIFY_DEPLOYMENT_GUIDE.md |
| **I want overview** | SAMPLE_APP_SETUP.md |
| **I'm lost** | DEPLOYMENT_INDEX.md |
| **Visual guide** | VISUAL_GUIDE.md |
| **App details** | sample-app/README.md |

---

## ✅ Pre-Deployment Checklist

- [ ] AWS account configured
- [ ] Terraform installed
- [ ] Node.js 14+ installed
- [ ] Valid VPC/subnet IDs in terraform.tfvars
- [ ] AWS credentials working

---

## 🎯 Two Deployment Paths

### Path A: Quick Demo (No GitHub)
```bash
npm install && npm run build
terraform apply
# Your app is live! 🎉
```

### Path B: GitHub CI/CD (Auto-Deploy)
```bash
# 1. Set in terraform.tfvars:
github_token = "ghp_YOUR_TOKEN"
github_repo  = "https://github.com/YOU/REPO"

# 2. Deploy
terraform apply

# 3. Now: Every push auto-deploys! 🚀
```

---

## 🔧 Key Commands

```bash
# Deploy
terraform apply

# Preview changes
terraform plan

# Destroy everything
terraform destroy

# See outputs
terraform output

# Build locally
npm run build

# Test locally
npm start
```

---

## 📊 Expected Output

After `terraform apply`, look for:

```
Outputs:

app_id = "d1a2b3c4d5e6f7g8h9i0"
app_url = "https://dev.d1a2b3c4d5e6f7.amplifyapp.com"
default_domain = "d1a2b3c4d5e6f7.amplifyapp.com"
```

👉 **Copy the app_url and paste into browser**

---

## 🆘 Common Issues

| Issue | Fix |
|-------|-----|
| npm install fails | Update Node.js to 14+ |
| terraform init fails | Check AWS credentials |
| 404 error | Check VPC/subnet IDs |
| Build hangs | Normal first time (~5 min) |
| GitHub not connecting | Regenerate token with `repo` scope |

---

## 🎨 Your App Features

✅ Search interface  
✅ Result cards with scores  
✅ Responsive design  
✅ Demo data included  
✅ Ready for backend API  
✅ Cognito-ready  

---

## 📱 Test Your App

1. Open the URL from terraform output
2. Type any search query
3. Click Search
4. See 3 sample results
5. Try on mobile (responsive!)

---

## 🔐 What's Included

✅ Automatic HTTPS  
✅ Global CDN  
✅ Auto-scaling  
✅ SSL certificate  
✅ DDoS protection  
✅ Production ready  

---

## 🎯 Next Steps

1. **Show demo** to stakeholders
2. **Connect API** - Update App.js with real API calls
3. **Add auth** - Setup Cognito integration
4. **Custom domain** - Point your domain to Amplify
5. **Setup monitoring** - Enable CloudWatch logs

---

## 📞 Troubleshooting Flow

```
Error?
  ↓
Check terraform apply output
  ├─ Terraform error? → Fix & rerun
  └─ Success? → Check AWS Console
  ↓
Check Amplify Console → Build logs
  ├─ Build error? → Fix code
  ├─ Deploy error? → Check permissions
  └─ All good? → Check browser
  ↓
Check Browser Console
  ├─ JavaScript error? → Check App.js
  ├─ Network error? → Check API
  └─ Still stuck? → See AMPLIFY_DEPLOYMENT_GUIDE.md
```

---

## 🚀 From Deploy to Live

| Time | What Happens |
|------|--------------|
| 0:00 | You run `terraform apply` |
| 0:30 | Amplify app created in AWS |
| 1:00 | Build starts |
| 2:00 | Dependencies installed |
| 3:00 | Build completes |
| 3:30 | Deploy to CDN |
| 4:00 | Your app is LIVE! 🎉 |

---

## 🌍 Global Deployment

Your app is now:
- ✅ Hosted on AWS CDN (edge locations worldwide)
- ✅ Served over HTTPS (auto certificate)
- ✅ Auto-scaling (handles traffic)
- ✅ Monitored (AWS Amplify)
- ✅ Backed up (redundancy)

---

## 📝 Terraform.tfvars Template

```hcl
project_name = "rag-agent"
environment  = "dev"
aws_region   = "us-east-1"

vpc_id     = "vpc-YOUR_ID"
subnet_ids = ["subnet-YOUR_ID_1", "subnet-YOUR_ID_2"]

# Optional GitHub CI/CD
github_token = ""              # Leave empty or add ghp_TOKEN
github_repo  = ""              # Leave empty or add GitHub URL
github_branch = "main"         # GitHub branch to deploy
```

---

## 💡 Pro Tips

```
Tip #1: First deployment takes 3-5 min (building & caching)
Tip #2: Subsequent deploys are faster (2-3 min)
Tip #3: Push to GitHub for auto-deployments
Tip #4: Check Amplify console logs for errors
Tip #5: Keep terraform.tfvars.example as backup
Tip #6: Use env vars for API endpoints
Tip #7: Build locally first to catch errors
Tip #8: HTTPS is automatic (no config needed)
```

---

## 🎉 Success Checklist

After deployment, you should have:

- [ ] App URL in terraform output
- [ ] URL accessible in browser
- [ ] Search interface visible
- [ ] Can type in search box
- [ ] Search button works
- [ ] Demo results appear
- [ ] Mobile view responsive
- [ ] HTTPS working (padlock 🔒)
- [ ] No browser console errors
- [ ] Ready to show stakeholders ✅

---

## 🆘 SOS - Can't Deploy?

1. **Check prerequisites:**
   ```bash
   node --version    # Should be 14+
   terraform version # Should be 1.0+
   aws sts get-caller-identity  # Should work
   ```

2. **Check config:**
   ```bash
   grep vpc_id terraform.tfvars  # Should not be empty
   ```

3. **Check Terraform:**
   ```bash
   terraform plan  # See what will happen
   ```

4. **Check AWS:**
   - Is IAM user authorized?
   - Are credentials valid?
   - Is region correct?

5. **Still stuck?**
   - See AMPLIFY_DEPLOYMENT_GUIDE.md
   - Check AWS Amplify Console for errors

---

## 📞 Command Reference

```bash
# Preparation
cd sample-app
npm install
npm run build
cd ..

# Deployment
terraform init
terraform plan
terraform apply

# Status
terraform output
aws amplify list-apps

# Cleanup
terraform destroy

# Quick redeploy
npm run build
terraform apply
```

---

## 🎯 Today's Goal

```
Your Checklist:
1. ✅ Read this card
2. ✅ Read appropriate guide (QUICK_START or DEPLOYMENT)
3. ✅ Run: npm install && npm run build
4. ✅ Run: terraform init && terraform apply
5. ✅ Copy URL from output
6. ✅ Visit URL in browser
7. ✅ See your app live! 🎉
8. ✅ Show to stakeholders

Est. Time: ~20 minutes
```

---

## 🚀 Go Time!

You have everything you need. Deploy now!

**Command:**
```bash
cd sample-app && npm install && npm run build && cd ..
terraform init && terraform apply
```

**Then:** Copy the app URL and visit it in your browser.

**Result:** Your RAG Agent Platform demo is live! 🎉

---

**Questions?** Refer to the guide in the Documentation Guide section above.

**Good luck!** 🚀
