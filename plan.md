# Purpose

- To sync from another offline mirror(s) of a repo(s) to privately hosted domain

# Architecture Breakdown
- a setup.sh will wrap all of these ansible playbooks (with --target <ip/hostname> --ssh-user <username>) and allow for easy setup and takedown remotely
- ansible will be used to deploy the infrastructure
- a ansible variable file will be used to 
- nginx will serve the content
- rsync will sync from the source mirror to the target mirror
- GPG key will be used to sign the packages
- Docker will be used to run the infrastructure
- systemd service files will be used to run docker-compose 
- rsyncd will be used to sync from the source mirror to the target mirror
- individual update scripts and control for repos will be saved in /opt/repo/repo_control/<repo_name>
- ansible playbooks will be saved in /opt/repo/playbooks/ as an artificat to track deployment
- templates will be saved in /opt/repo/jinja/ as an artificat to track deployment and to allow future repos to be added and deployed with ease
- ansible variable files will be saved in /opt/repo/vars/ as an artificat to track deployment and to allow future repos to be added and deployed with ease
- nginx config Jinja and helper scripts will be saved in /opt/repo/jinja/ as an artificat to track deployment and to allow future repos to be added and deployed with ease
- docker-registry from https://hub.docker.com/_/registry will be used to host a private registry mirror

# Deployed folder structure:
```text

/opt/nginx/
├─ config/
│  ├─ nginx.conf
|  ├─ repo-key.gpg
│  └─ generate-gpg.sh
├─ www/
│  ├─ assets/
│  │  ├─ style.css
│  │  ├─ autoindex.css
│  │  └─ header.html
│  ├─ ubuntu/
│  │  └─ index.html
│  └─ clamav/
│     └─ index.html
└─ docker-compose.yml

/opt/repo/
|  jinja/
|  | sync-<repo>.sh
|  | sign-<repo>.sh
|  | rollback-<repo>.sh
|  playbooks/
|  repo_control/
|  ├─ ubuntu
│  │  ├─ sync-ubuntu.sh
│  │  ├─ sign-ubuntu.sh
│  │  └─ rollback-ubuntu.sh
│  ├─ clamav
│  │  ├─ sync-clamav.sh
│  │  ├─ sign-clamav.sh
│  │  └─ rollback-clamav.sh
|  ├─ selected_debs
│  │  ├─ sync-debs.sh
│  │  ├─ sign-debs.sh
│  │  └─ rollback-debs.sh

/opt/docker-registry/

/mnt/ubuntu
├  ubuntu
│  ├─ noble
│  │  ├─ dists/
│  │  ├─ pool/
│  │  └─ project_snapshot/ ← historical states
├  selected_debs
│   ├─ firefox/
│   │   └─ project_snapshot/ ← historical states
│   └─ wireshark/
│       └─ project_snapshot/ ← historical states

/mnt/clamav
│  ├─ main/
│  │   └─ project_snapshot/ ← historical states
│  ├─ daily/
│  │   └─ project_snapshot/ ← historical states
│  └─ daily_snapshot/ ← historical states

/mnt/docker-registry/
|  images/ ← local docker images

```