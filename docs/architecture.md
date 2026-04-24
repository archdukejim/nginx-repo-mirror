# Architecture

The NGINX Repository Mirror (`nginx-repo-mirror`) is designed as a space-efficient, version-controlled mirroring mechanism deployed dynamically via Ansible.

## Core Concepts

### NGINX Container
The frontend of the repository is served by a lightweight NGINX container.
- It dynamically maps subdirectories to each repository defined in `vars.yaml`.
- Custom landing pages (`index.html`) provide simple `apt` one-liners for quick client consumption.
- The repository directories themselves are served with `autoindex` enabled, providing a directory browsing experience styled securely via `.assets/`.

### Storage Space Efficiency
Mirroring entire OS package repositories can consume immense storage. To mitigate this:
- Synchronization uses `rsync --link-dest`.
- During a sync, new downloads are saved in a fresh `YYYYMMDD` date folder.
- Any files that haven't changed since the previous sync are **hard-linked** from the previous folder.
- This creates the illusion of full snapshot folders for every sync date while using zero additional disk space for unchanged data.

### The "Latest" Concept
To simplify NGINX configuration and client access, a `Latest` symlink is maintained at the root of every repository target path. 
- When a new sync completes successfully, the `Latest` link is updated to point to the new `YYYYMMDD` folder.
- Clients always fetch `http://<fqdn>/<repo_name>/Latest/...` securely under the hood, even if the URL they see stops at `<repo_name>`.

### GPG Signing Workflow
Because internal clients need to trust this mirror, custom GPG keys are generated per deployment.
1. `generate-gpg.sh` securely creates an RSA 2048 key.
2. The public key is exported to the web root for clients to download.
3. `sign-<repo>.sh` scans the `Latest` directory for `Release` files and generates detached `.gpg`, clearsign `.asc`, and `.inrelease` signatures using the private key.
