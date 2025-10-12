# Laravel Server Tools

**Version:** 1.0.0  
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
✅ Auto-cleans and optimizes Laravel caches  
✅ NPM build integration (optional)  
✅ Auto Supervisor worker creation with log management  
✅ Bash auto-completion for quick commands  
✅ Designed for shared hosting & VPS structures  

---

## 🧰 Installation (One Command)

Run this single command to install everything:

    bash <(curl -fsSL https://raw.githubusercontent.com/donnebanget/laravel-server-tools/main/install.sh)

Or if `curl` is not available:

    bash <(wget -qO- https://raw.githubusercontent.com/donnebanget/laravel-server-tools/main/install.sh)

This will automatically:
- Clone the repository
- Install binaries to `/usr/local/bin`
- Enable bash completions in `/etc/bash_completion.d`
- Create worker log directory `/var/log/laravel-workers`

After installation, enable completions immediately by running:

    source /etc/bash_completion

---

## ⚙️ Commands

### 🔹 `deploy`

Smart Laravel deployment automation.

#### Usage

    deploy                # Quick optimization (no Git/NPM)
    deploy --init         # First-time setup (with full caching)
    deploy --update       # Git pull + full rebuild

#### What it does

- Pulls latest Git changes (when using `--update`)
- Installs Composer dependencies
- Builds front-end (if `package.json` exists)
- Clears Laravel caches (`optimize:clear`)
- Rebuilds and optimizes app (`optimize`)
- Restarts Supervisor workers automatically

---

### 🔹 `worker`

Quickly create and manage Laravel queue workers under Supervisor.

#### Usage

    worker create [user] [domain?] [queue?]
	worker remove [user]
	worker list
	worker restart [user]
	worker status [user?]
	worker logs [user] [out|err]

#### Example

    worker create user-example example.com
    worker create user-example example.com --queue=v2

This will:
- Create `/etc/supervisor/conf.d/[user]-worker.conf`
- Link the worker to your Laravel directory `/var/www/[user]/data/www/[domain]/`
- Save logs to `{project_dir}/storage/logs/worker.out|err.log`

#### Logs

- STDOUT → `{project_dir}/storage/logs/worker.out.log`  
- STDERR → `{project_dir}/storage/logs/worker.err.log`

---

## 📦 Directory Structure

    laravel-server-tools/
    ├── bin/
    │   ├── deploy
    │   └── worker
    ├── completions/
    │   ├── deploy.bash
    │   └── worker.bash
    ├── install.sh
    ├── VERSION
    └── README.md

---

## 🪄 Example Usage

### Full first-time setup:

    cd /var/www/user-xample/data/www/example.com
    deploy --init

### Update from latest Git commit:

    deploy --update

### Create worker for default queue:

    worker create user-example example.com

### Create worker for a specific queue:

    worker create user-example example.com --queue=v2

---

## 🧾 System Compatibility

Designed for systems where Laravel resides under:

    /var/www/[user]/data/www/[domain]/

Works perfectly with:
- **Fastpanel**
- Standard **Debian/Ubuntu VPS**

---

## 💡 Troubleshooting

| Issue | Possible Cause | Fix |
|-------|----------------|-----|
| `deploy: command not found` | Path not reloaded | Run `source /etc/bash_completion` |
| `Supervisor not found` | Not installed | Run `apt install supervisor` |
| Permission denied | Insufficient sudo rights | Run with `sudo` |
| Logs not created | Missing directory | Run `sudo mkdir -p /var/log/laravel-workers && chmod 777 /var/log/laravel-workers` |

---

## 🧠 Tips

- For servers with multiple users, each user will have their own worker (`[username]-worker`).
- Combine with `crontab` to automate deploys nightly or post-Git-push.
- Works beautifully with Inertia.js + Vite projects — it detects and builds automatically.

---

## 🧾 License

MIT License © 2025 Donny Iskandarsyah

You are free to use, modify, and distribute this toolkit as long as attribution is maintained.

---

## ✨ Credits

Built by **Donny Iskandarsyah**  
Assisted by **OpenAI ChatGPT (GPT-5)** for automation logic, documentation, and structure.

---

> 💬 *"Simple. Predictable. Automated."*
