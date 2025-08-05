# Railway Deployment Guide for n8n

## Step-by-Step Deployment Process

### 1. Prepare Your Repository

1. **Create a new GitHub repository** (or use GitLab/Bitbucket)
2. **Clone this project** to your local machine
3. **Push to your repository**:
   ```bash
   git init
   git add .
   git commit -m "Initial n8n Railway deployment setup"
   git remote add origin https://github.com/yourusername/your-repo-name.git
   git push -u origin main
   ```

### 2. Deploy to Railway

1. **Go to Railway**: https://railway.app
2. **Sign up/Login** with your GitHub account
3. **Create New Project** → **Deploy from GitHub repo**
4. **Select your repository** containing the n8n files
5. **Railway will automatically**:
   - Detect the Dockerfile
   - Start building the container
   - Deploy your n8n instance

### 3. Essential Environment Variables

**In Railway Dashboard → Your Project → Variables, add:**

#### 🔑 Security (REQUIRED)
```
N8N_ENCRYPTION_KEY=your-32-character-minimum-encryption-key-here-123456789
N8N_USER_MANAGEMENT_JWT_SECRET=your-jwt-secret-for-user-management-here
```

#### 🗄️ Database (HIGHLY RECOMMENDED)
**Option A: Add PostgreSQL Database in Railway**
1. In your project, click **"New"** → **"Database"** → **"PostgreSQL"**
2. Railway will create a PostgreSQL instance
3. Copy the connection variables from the PostgreSQL service:
```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
```

**Option B: External PostgreSQL**
```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=your-external-postgres-host
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=your-db-user
DB_POSTGRESDB_PASSWORD=your-db-password
```

#### 🔐 Authentication (OPTIONAL but RECOMMENDED)
```
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your-secure-password-here
```

### 4. Generate Secure Keys

**For N8N_ENCRYPTION_KEY** (32+ characters):
```bash
# Option 1: Using openssl
openssl rand -hex 32

# Option 2: Using Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Option 3: Manual (ensure 32+ characters)
your-super-secure-encryption-key-123456789abcdef
```

**For N8N_USER_MANAGEMENT_JWT_SECRET**:
```bash
# Generate a strong JWT secret
openssl rand -base64 64
```

### 5. Configure Domain and URLs

**After deployment, Railway provides a domain like:**
`https://your-app-name-production-xxxx.up.railway.app`

**Add these variables:**
```
WEBHOOK_URL=https://your-railway-domain.railway.app
N8N_EDITOR_BASE_URL=https://your-railway-domain.railway.app
```

### 6. Custom Domain (Optional)

1. **In Railway**: Project Settings → Domains
2. **Add your domain**: `n8n.yourdomain.com`
3. **Update DNS**: Add CNAME record pointing to Railway domain
4. **Update environment variables**:
   ```
   WEBHOOK_URL=https://n8n.yourdomain.com
   N8N_EDITOR_BASE_URL=https://n8n.yourdomain.com
   ```

### 7. Verify Deployment

1. **Check deployment logs** in Railway dashboard
2. **Visit your n8n URL** (Railway domain or custom domain)
3. **Create your first user account**
4. **Test basic functionality**

## Production Checklist

### ✅ Security
- [ ] Strong encryption key (32+ characters)
- [ ] Secure JWT secret
- [ ] Basic auth enabled (or proper user management)
- [ ] HTTPS enabled (automatic on Railway)
- [ ] Database password secured

### ✅ Database
- [ ] PostgreSQL configured (not SQLite)
- [ ] Database backups enabled
- [ ] Connection pooling configured

### ✅ Monitoring
- [ ] Health checks working (`/healthz` endpoint)
- [ ] Logging configured
- [ ] Error notifications set up

### ✅ Performance
- [ ] Appropriate Railway plan selected
- [ ] Memory/CPU limits configured
- [ ] Redis configured (for scaling)

## Common Issues & Solutions

### 🚨 Deployment Fails
**Check:**
- Dockerfile syntax
- Package.json dependencies
- Railway build logs

**Solution:**
```bash
# Test locally first
docker build -t n8n-test .
docker run -p 5678:5678 n8n-test
```

### 🚨 Database Connection Error
**Check:**
- Database service is running
- Connection variables are correct
- Network connectivity

**Solution:**
- Verify PostgreSQL service in Railway
- Check environment variable names
- Test connection from Railway logs

### 🚨 Authentication Issues
**Check:**
- Encryption key length (minimum 32 chars)
- JWT secret is set
- User management is properly configured

**Solution:**
- Regenerate encryption key
- Clear browser cache
- Check Railway environment variables

### 🚨 Webhooks Not Working
**Check:**
- WEBHOOK_URL matches your domain
- HTTPS is properly configured
- Firewall/security settings

**Solution:**
- Update WEBHOOK_URL environment variable
- Test webhook endpoints manually
- Check Railway networking settings

## Scaling Options

### Vertical Scaling
- Upgrade Railway plan for more CPU/memory
- Monitor resource usage in Railway dashboard

### Horizontal Scaling
1. **Add Redis**:
   ```
   QUEUE_BULL_REDIS_HOST=your-redis-host
   QUEUE_BULL_REDIS_PORT=6379
   EXECUTIONS_MODE=queue
   ```

2. **Multiple Workers**:
   - Deploy additional n8n instances
   - Configure queue mode
   - Load balance with Railway

### Database Scaling
- Use Railway PostgreSQL with connection pooling
- Consider external managed PostgreSQL
- Implement read replicas for heavy workloads

## Maintenance

### Updates
1. **Update package.json** with new n8n version
2. **Commit and push** changes
3. **Railway auto-deploys** the update
4. **Monitor logs** for any issues

### Backups
- **Database**: Use Railway's automatic backups
- **Workflows**: Export from n8n interface
- **Configuration**: Keep environment variables documented

### Monitoring
- **Railway Dashboard**: Monitor resource usage
- **n8n Logs**: Check execution logs
- **Health Checks**: Monitor `/healthz` endpoint

## Support Resources

- **Railway Support**: https://railway.app/help
- **n8n Documentation**: https://docs.n8n.io/
- **n8n Community**: https://community.n8n.io/
- **This Repository**: Create issues for deployment-specific problems

---

**Need Help?** Create an issue in this repository with:
- Railway deployment logs
- Environment variables (without sensitive values)
- Error messages
- Steps to reproduce the issue
