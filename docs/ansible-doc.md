# Ansible Orchestration

The `deploy-mirrors.yml` Ansible playbook orchestrates the deployment of the NGINX repository mirror. It relies entirely on the configuration defined within `vars.yaml`.

## Playbook Execution Flow (`deploy-mirrors.yml`)

1. **Create required directory structure**: Bootstraps the base `nginx/`, `repo/`, and `docker-registry/` directories inside your `stack_path`.
2. **Create repo-specific directories**: Iterates over the `repos` list to create dedicated web-root folders for each repository's landing page and control scripts.
3. **Deploy universal assets**: Copies the `files/` directory from the repository over to the target machine's `.assets/` directory to style the landing pages and directory indexes.
4. **Deploy nginx.conf**: Templates `jinja/nginx.conf.j2` to securely route traffic to the respective repository locations.
5. **Deploy GPG Key Generation Script**: Templates `jinja/generate-gpg.sh.j2`.
6. **Deploy Scripts**: Generates dedicated `sign-<repo>.sh`, `sync-<repo>.sh`, and `rollback-<repo>.sh` scripts for each repository under `/opt/repo/repo_control/<repo_name>/`.
7. **Deploy HTML Landing Pages**: Generates custom `index.html` files for each repository hosting the required `apt` one-liner.
8. **Deploy docker-compose.yml**: Deploys the configuration required to launch the NGINX and Docker Registry containers.
9. **Save Artifacts**: Backs up templates, playbooks, and variables to `/opt/repo/` to track deployment.
10. **Systemd Integration**: Deploys the `docker-compose-app.service.j2` template as `nginx-repo-mirror.service` and enables the containers on boot.

## Configuration Schema (`vars.yaml`)

| Variable | Description |
|---|---|
| `kit_name` | The global identifier for the infrastructure (used in filenames and HTML). |
| `domain` | The internal domain used to generate FQDNs for repositories. |
| `cert_path` | Absolute path to SSL certificates mounted to NGINX. |
| `stack_path` | Base directory on the target host where configuration is written. |
| `nginx_image` | The Docker image for the NGINX container. |
| `repos` | A list of dictionaries defining the mirrored repositories. |

### `repos` List Schema

| Variable | Description |
|---|---|
| `name` | The short name of the repo (e.g., `ubuntu`). Used in URLs and script generation. |
| `fqdn` | The Fully Qualified Domain Name NGINX will listen for (e.g., `ubuntu.repo.jolt.internal`). |
| `target[0].uri` | The IP of the host storing the files. |
| `target[1].host_path` | The absolute path on the host where the `rsync` script will download files. |
| `source[0].uri` | The upstream domain to `rsync` from (e.g., `archive.ubuntu.com`). |
| `source[1].path` | The upstream path to target (e.g., `ubuntu`). |
