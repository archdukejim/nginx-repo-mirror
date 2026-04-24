# Installation Guide

Follow these steps to deploy the NGINX Repository Mirror using Ansible.

## Prerequisites
- A target machine (or localhost) capable of running Docker and Docker Compose.
- `ansible` installed on the deployment machine.
- Sufficient disk space at your target repository mount paths.

## Step 1: Configure Variables
Before running the deployment playbook, you must edit `vars.yaml`.

Open `vars.yaml` and configure the following:
- `kit_name`: An identifier for your infrastructure.
- `domain`: The internal domain where these mirrors will be hosted (e.g., `jolt.internal`).
- `stack_path`: The directory where the NGINX configuration and scripts will be installed.
- **repos**: Define your repositories. For each one:
  - `name`: Identifier (e.g., `ubuntu`).
  - `fqdn`: The domain name it will be accessible at.
  - `target.uri`: The IP/URI of the server hosting it.
  - `target.host_path`: Where on disk the mirrored files should be stored.
  - `source.uri` and `source.path`: Upstream location to `rsync` from.

## Step 2: Deploy Infrastructure
Run the Ansible playbook locally or against your target server to generate the configuration and directories.

```bash
# If running locally
ansible-playbook -i localhost, -c local deploy-mirrors.yml

# If running against a remote host (ensure you have ssh access setup)
ansible-playbook -i inventory.ini deploy-mirrors.yml
```

## Step 3: Initial Synchronization
The deployment sets up the directories and scripts, but it **does not** download the packages. 

For each repository you defined, execute its specific synchronization script to perform the initial download and key signing:
```bash
bash /opt/nginx/config/sync-<repo_name>.sh
```
*(Replace `/opt` with your `stack_path`)*

## Step 4: Start the NGINX Container
Once the initial sync is complete, bring up the web server:
```bash
cd /opt/nginx/
docker-compose up -d
```
