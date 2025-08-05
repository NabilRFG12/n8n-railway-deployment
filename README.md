# n8n Railway Deployment

This repository contains everything you need to deploy n8n (workflow automation tool) on Railway with full control over the configuration and packages.

## 🚀 Quick Deploy to Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/n8n)

## 📋 Prerequisites

- Railway account (free tier available)
- Git repository (GitHub, GitLab, or Bitbucket)
- Basic understanding of environment variables

## 🛠️ Setup Instructions

### 1. Clone and Push to Your Repository

```bash
git clone <your-repo-url>
cd n8n-railway-deployment
git add .
git commit -m "Initial n8n Railway setup"
git push origin main
```

### 2. Deploy on Railway

1. Go to [Railway](https://railway.app)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose this repository
5. Railway will automatically detect the Dockerfile and deploy

### 3. Configure Environment Variables

In your Railway project dashboard, go to Variables and set:

#### Required Variables:
```
N8N_ENCRYPTION_KEY=your-32-character-encryption-key-here
N8N_USER_MANAGEMENT_JWT_SECRET=your-jwt-secret-here
```

#### Database Configuration (Recommended: PostgreSQL):
```
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=your-postgres-host
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=your-db-user
DB_POSTGRESDB_PASSWORD=your-db-password
```

#### Optional Authentication:
```
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your-secure-password
```

### 4. Add PostgreSQL Database (Recommended)

1. In Railway, click "New" → "Database" → "PostgreSQL"
2. Copy the connection details to your environment variables
3. Redeploy your n8n service

## 🔧 Local Development

### Using Docker Compose

```bash
# Start n8n with SQLite (development)
docker-compose up -d

# Start with PostgreSQL
docker-compose --profile postgres up -d

# Start with Redis (for scaling)
docker-compose --profile redis up -d

# View logs
docker-compose logs -f n8n
```

### Using npm directly

```bash
# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your settings
nano .env

# Start n8n
npm start
```

Access n8n at: http://localhost:5678

## 📁 Project Structure

```
├── Dockerfile              # Container configuration
├── package.json            # Node.js dependencies
├── railway.toml            # Railway deployment config
├── docker-compose.yml      # Local development setup
├── .env.example           # Environment variables template
└── README.md              # This file
```

## 🔐 Security Considerations

### Production Setup:
- Use PostgreSQL database (not SQLite)
- Set strong encryption keys
- Enable HTTPS (automatic on Railway)
- Configure proper authentication
- Set up email notifications
- Use Redis for scaling (optional)

### Environment Variables Security:
- Never commit `.env` files to git
- Use Railway's environment variables feature
- Rotate encryption keys periodically
- Use strong, unique passwords

## 🌐 Custom Domain

1. In Railway project settings, go to "Domains"
2. Add your custom domain
3. Update DNS records as instructed
4. Update environment variables:
   ```
   WEBHOOK_URL=https://your-domain.com
   N8N_EDITOR_BASE_URL=https://your-domain.com
   ```

## 📊 Monitoring and Scaling

### Health Checks
- Railway automatically monitors `/healthz` endpoint
- Automatic restarts on failure
- Configurable timeout and retry settings

### Scaling Options
- Vertical scaling: Increase memory/CPU in Railway
- Horizontal scaling: Add Redis and configure queue mode
- Database scaling: Use Railway's PostgreSQL with connection pooling

## 🔄 Updates

To update n8n version:

1. Edit `package.json` and update n8n version
2. Commit and push changes
3. Railway will automatically redeploy

```json
{
  "dependencies": {
    "n8n": "^1.19.4"  // Update this version
  }
}
```

## 🐛 Troubleshooting

### Common Issues:

1. **Database Connection Errors**
   - Verify PostgreSQL connection details
   - Check if database service is running
   - Ensure proper network connectivity

2. **Authentication Problems**
   - Check encryption key length (minimum 32 characters)
   - Verify JWT secret is set
   - Clear browser cache and cookies

3. **Webhook Issues**
   - Ensure WEBHOOK_URL matches your domain
   - Check HTTPS configuration
   - Verify firewall settings

### Logs Access:
```bash
# Railway CLI
railway logs

# Docker Compose
docker-compose logs -f n8n
```

## 📚 Additional Resources

- [n8n Documentation](https://docs.n8n.io/)
- [Railway Documentation](https://docs.railway.app/)
- [n8n Community](https://community.n8n.io/)
- [Railway Discord](https://discord.gg/railway)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Disclaimer

This deployment configuration is provided as-is. Always review and test in a development environment before deploying to production. Ensure you comply with n8n's licensing terms and Railway's terms of service.
