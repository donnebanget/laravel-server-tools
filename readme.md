# Laravel Server Tools

**Version:** 1.0.1  
**Author:** Donny Iskandarsyah  
**Credits:** ChatGPT (GPT-5)

---

## 🧩 Overview

**Laravel Server Tools** is a lightweight command-line toolkit designed to simplify **Laravel deployment** and **Supervisor worker management** for multi-user Linux environments such as **Fastpanel** or standard VPS setups.

It provides two key utilities:

- `deploy` — Smart Laravel deployer that handles Git pulls, Composer installs, NPM builds, and optimization.  
- `worker` — Automated Supervisor configurator for Laravel queue workers.

---

## 🚀 Features

✅ Zero configuration deployment  
✅ Supports multiple modes (`--init`, `--update`, normal)  
✅ Auto-detects environment (production/staging/local)  
✅ Smart NPM build detection  
✅ Auto Supervisor worker creation with log management  
✅ Queue driver auto-detection from .env  
✅ Interactive domain selection for multi-site users  
✅ Bash auto-completion for quick commands  
✅ Designed for shared hosting & VPS structures  

---

## 🧰 Installation (One Command)

Run this single command to install everything:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/donnebanget/laravel-server-tools/main/install.sh)
```

Or if `curl` is not available:

```bash
bash <(wget -qO- https://raw.githubusercontent.com/donnebanget/laravel-server-tools/main/install.sh)
```

This will automatically:
- Clone the repository
- Install binaries to `/usr/local/bin`
- Enable bash completions in `/etc/bash_completion.d`
- Create worker log directory `/var/log/laravel-workers` (with secure permissions)

After installation, enable completions immediately by running:

```bash
source /etc/bash_completion
```

### Requirements

- **Git** - For cloning and updating repositories
- **PHP** - Required for Laravel
- **Composer** - For dependency management
- **Supervisor** - Required for worker management (optional for deploy-only usage)
- **NPM** - Optional, only needed if your project uses front-end builds

---

## ⚙️ Commands

### 🔹 `deploy`

Smart Laravel deployment automation with environment-aware optimizations.

#### Usage

```bash
deploy                # Quick optimization (no Git/NPM)
deploy --init         # First-time setup (with full caching)
deploy --update       # Git pull + full rebuild
deploy --help         # Show help message
```

#### What it does

- **Pre-flight checks** - Validates PHP, Composer, and project structure
- **Git updates** - Pulls latest changes (when using `--update`)
  - Includes detached HEAD detection
  - Safe reset and clean before pull
- **Environment-aware Composer** - Automatically uses `--no-dev` in production
- **Smart NPM builds** - Auto-detects `build`, `prod`, or `production` scripts
- **Cache optimization** - Clears and rebuilds Laravel caches
- **Conditional commands** - Only runs `opcache:clear` and `icons:cache` if available
- **Worker restart** - Automatically restarts Supervisor workers if configured

#### Examples

```bash
# First deployment on a new server
cd /var/www/user-example/data/www/example.com
deploy --init

# Daily/production updates
deploy --update

# Quick cache refresh (no rebuilds)
deploy
```

---

### 🔹 `worker`

Quickly create and manage Laravel queue workers under Supervisor with intelligent defaults.

#### Usage

```bash
worker create [user] [domain?] [queue?]    # Create new worker
worker remove [user] [--force]             # Remove worker (with confirmation)
worker list                                 # List all workers
worker restart [user]                       # Restart specific worker
worker status [user?]                       # Show worker status (all or specific)
worker logs [user] [out|err]                # Tail worker logs
```

#### Smart Features

- **Auto-detects queue driver** from `.env` (`QUEUE_CONNECTION`)
- **Auto-detects environment** from `.env` (`APP_ENV`, `APP_DEBUG`)
- **Interactive domain selection** when multiple Laravel sites exist
- **Safe removal** with confirmation prompt (unless `--force` is used)
- **Proper log rotation** - 10MB per file, 5 backups
- **Graceful shutdowns** - 60 second timeout for long-running jobs

#### Examples

```bash
# Create worker with auto-detected settings
worker create user-example example.com

# Create worker for specific queue
worker create user-example example.com emails

# Create worker with domain auto-selection
worker create user-example

# Remove worker with confirmation
worker remove user-example

# Force remove without confirmation
worker remove user-example --force

# Check status of all workers
worker status

# Check specific worker
worker status user-example

# View output logs (live tail)
worker logs user-example out

# View error logs
worker logs user-example err
```

#### Configuration Details

The worker automatically creates `/etc/supervisor/conf.d/[user]-worker.conf` with:

```ini
[program:user-example-worker]
command=php artisan queue:work redis --sleep=3 --tries=3 --max-time=3600
directory=/var/www/user-example/data/www/example.com
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=user-example
numprocs=1
stdout_logfile={project_dir}/storage/logs/worker.out.log
stderr_logfile={project_dir}/storage/logs/worker.err.log
stdout_logfile_maxbytes=10MB
stdout_logfile_backups=5
stopwaitsecs=60
environment=APP_ENV=production,APP_DEBUG=false
```

**Note:** Queue driver, environment variables, and queue name are automatically detected from your project's `.env` file.

#### Auto-Generated Sudoers

When you create a worker, the script automatically creates `/etc/sudoers.d/[user]-worker` to allow the user to manage their own worker without needing full sudo access:

```bash
user-example ALL=(root) NOPASSWD: /usr/bin/supervisorctl restart user-example-worker
user-example ALL=(root) NOPASSWD: /usr/bin/supervisorctl status user-example-worker
user-example ALL=(root) NOPASSWD: /usr/bin/supervisorctl stop user-example-worker
user-example ALL=(root) NOPASSWD: /usr/bin/supervisorctl start user-example-worker
```

This means:
- ✅ Users can restart their own workers from `deploy` script
- ✅ Users can check status and manage their own workers
- ✅ No full sudo access required
- ✅ Automatically cleaned up when worker is removed

#### Logs Location

- **STDOUT** → `{project_dir}/storage/logs/worker.out.log`  
- **STDERR** → `{project_dir}/storage/logs/worker.err.log`

Logs are automatically rotated when they reach 10MB, keeping 5 backup files.

---

## 📦 Directory Structure

```
laravel-server-tools/
├── bin/
│   ├── deploy              # Deployment script
│   └── worker              # Worker management script
├── completions/
│   ├── deploy.bash         # Bash completion for deploy
│   └── worker.bash         # Bash completion for worker
├── install.sh              # One-command installer
├── VERSION                 # Version tracking
└── README.md               # This file
```

---

## 🪄 Complete Workflow Example

### Initial Server Setup

```bash
# 1. Install Laravel Server Tools
bash <(curl -fsSL https://raw.githubusercontent.com/donnebanget/laravel-server-tools/main/install.sh)

# 2. Enable bash completions
source /etc/bash_completion

# 3. Navigate to your Laravel project
cd /var/www/user-example/data/www/example.com

# 4. First-time deployment
deploy --init

# 5. Create queue worker
worker create user-example example.com

# 6. Check worker status
worker status user-example
```

### Daily Deployment Workflow

```bash
# Navigate to project
cd /var/www/user-example/data/www/example.com

# Pull latest changes and rebuild
deploy --update

# Worker automatically restarts during deployment
```

### Monitoring & Maintenance

```bash
# Check all workers
worker list

# Check specific worker status
worker status user-example

# View live logs
worker logs user-example out

# Restart worker manually
worker restart user-example
```

---

## 🧾 System Compatibility

### Directory Structure

Designed for systems where Laravel resides under:

```
/var/www/[user]/data/www/[domain]/
```

### Tested Platforms

- ✅ **Fastpanel** - Full compatibility
- ✅ **Standard Debian/Ubuntu VPS** - Tested on Debian 11/12, Ubuntu 20.04/22.04
- ✅ **Multi-user environments** - Each user can have their own workers

### PHP Versions

- Tested with PHP 7.4, 8.0, 8.1, 8.2, 8.3
- Should work with any Laravel-supported PHP version

---

## 💡 Troubleshooting

| Issue | Possible Cause | Fix |
|-------|----------------|-----|
| `deploy: command not found` | Path not reloaded | Run `source /etc/bash_completion` or restart shell |
| `Supervisor not found` | Not installed | Run `sudo apt install supervisor` |
| `Permission denied` on deploy | Insufficient file permissions | Check ownership of Laravel files |
| `Permission denied` on worker | Insufficient sudo rights | Add user to sudoers with NOPASSWD for supervisorctl |
| Worker not starting | Invalid queue connection | Check `QUEUE_CONNECTION` in `.env` |
| `Composer install failed` | Memory limit or dependencies | Increase PHP memory_limit or check composer.json |
| Git pull fails | Uncommitted changes | Commit or stash changes, or use `--update` (does hard reset) |
| NPM build fails | Missing dependencies | Run `npm install` manually first |

### Common Permission Setup

For users to manage Supervisor without full sudo access:

```bash
# Edit sudoers
sudo visudo

# Add this line (replace 'username' with actual user)
username ALL=(ALL) NOPASSWD: /usr/bin/supervisorctl
```

---

## 🧠 Tips & Best Practices

### Deployment Tips

- **Always test on staging first** - Use `APP_ENV=staging` in your .env
- **Use `--init` only once** - For first deployment, use `--update` for subsequent deploys
- **Check logs after deployment** - Monitor Laravel logs and worker logs
- **Combine with cron** - Automate nightly deployments if needed

### Worker Tips

- **One worker per user** - This is the current design, sufficient for most use cases
- **Monitor worker status** - Set up monitoring alerts for failed workers
- **Use specific queues** - Separate critical jobs (emails, notifications) from heavy jobs
- **Adjust `max-time`** - Default is 1 hour, increase for long-running jobs
- **Check queue driver** - Ensure Redis/database is running and accessible

### Automation Example

```bash
# Add to crontab for auto-deployment at 3 AM
0 3 * * * cd /var/www/user/data/www/example.com && /usr/local/bin/deploy --update >> /var/log/deploy.log 2>&1
```

---

## 🔐 Security Notes

- Log directory created with **755** permissions (not 777)
- Supervisor config files owned by root
- Workers run under their specific user context
- No sudo password required (uses `sudo -n` for non-interactive mode)
- Git `reset --hard` used in `--update` mode - ensure no uncommitted work

---

## 📝 Changelog

### v1.0.1 (Current)
- ✅ Fixed emoji encoding in all scripts
- ✅ Added pre-flight dependency checks
- ✅ Smart queue driver detection from .env
- ✅ Environment-aware composer install (production/staging)
- ✅ Smart NPM build script detection
- ✅ Improved worker removal with confirmation prompt
- ✅ Better error messages and exit codes
- ✅ Detached HEAD state detection in git pull
- ✅ Dynamic environment variables from .env
- ✅ Increased log rotation (10MB, 5 backups)
- ✅ Safer default permissions (755 instead of 777)
- ✅ Added --help flag to commands

### v1.0.0
- Initial release

---

## 🧾 License

MIT License © 2025 Donny Iskandarsyah

You are free to use, modify, and distribute this toolkit as long as attribution is maintained.

---

## ✨ Credits

Built by **Donny Iskandarsyah**  
Assisted by **OpenAI ChatGPT (GPT-5)** for automation logic, documentation, and structure.

---

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/donnebanget/laravel-server-tools/issues)
- **Discussions:** [GitHub Discussions](https://github.com/donnebanget/laravel-server-tools/discussions)

---

> 💬 *"Simple. Predictable. Automated."*