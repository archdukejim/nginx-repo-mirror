# NGINX Repository Mirror

The `nginx-repo-mirror` repository is an Ansible-driven orchestration stack designed to create highly efficient, version-controlled package repository mirrors (like Ubuntu `apt` repositories). 

It dynamically configures NGINX, manages space-efficient syncing (via `rsync --link-dest`), generates beautiful repository landing pages, and handles internal GPG signing workflows automatically.

## Documentation Navigation

Detailed documentation for this project is available in the `docs/` directory:

- 🏗️ **[Architecture](docs/architecture.md)**: Understand the system design, the `rsync --link-dest` space-saving mechanic, and the GPG signing workflow.
- 🚀 **[Installation Guide](docs/install.md)**: Step-by-step instructions on deploying the infrastructure via Ansible.
- ⚙️ **[Operations Guide](docs/operations.md)**: Day-to-day management, synchronizing repositories manually or via `cron`, and managing GPG keys.
- 🔄 **[Updates & Rollbacks](docs/updates.md)**: Learn how to perform instant rollbacks to historical repository states using generated snapshots.
- 📘 **[Ansible Reference](docs/ansible-doc.md)**: A technical breakdown of the `deploy-mirrors.yml` playbook and the `vars.yaml` schema.

---

## Source Repository Layout

```text
repo-root/
├─ deploy-mirrors.yml         ← Ansible playbook to deploy the stack
├─ vars.yaml                  ← Configuration for all mirrors
├─ files/
│   ├─ style.css              ← Styles for HTML landing pages
│   ├─ autoindex.css          ← Styles for directory listings
│   └─ header.html            ← Header for autoindex
├─ config/
│   ├─ docker-compose.yml.j2  ← Docker container deployment
│   ├─ generate-gpg.sh.j2     ← Key generation script
│   ├─ index.html.j2          ← Landing page template
│   ├─ nginx.conf.j2          ← Dynamic NGINX mapping configuration
│   ├─ rollback-repo.sh.j2    ← Rollback mechanism
│   ├─ sign-repo.sh.j2        ← Signing mechanism
│   └─ sync-repo.sh.j2        ← Sync mechanism
├─ docs/                      ← Comprehensive documentation
└─ README.md
```