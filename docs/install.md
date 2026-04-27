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
Run the `setup.sh` wrapper script which will automatically generate the inventory and execute the Ansible playbook against your target machine.

```bash
./setup.sh --target <target_ip_or_hostname> --ssh-user <username>
```

## Step 3: Start the Service
The playbook automatically configures a systemd service to manage the containers. You can ensure it is running with:
```bash
systemctl enable --now nginx-repo-mirror
```

## Step 4: Initial Synchronization
The deployment sets up the directories and scripts, but it **does not** download the packages. 

For each repository you defined, execute its specific synchronization script located in its control folder to perform the initial download and key signing:
```bash
bash /opt/repo/repo_control/<repo_name>/sync-<repo_name>.sh
```
*(Replace `/opt` with your configured `stack_path`)*
