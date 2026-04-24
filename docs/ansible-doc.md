# Ansible Orchestration

The `deploy-mirrors.yml` Ansible playbook orchestrates the deployment of the NGINX repository mirror. It relies entirely on the configuration defined within `vars.yaml`.

## Playbook Execution Flow (`deploy-mirrors.yml`)

1. **Create required directory structure**: Bootstraps the base `nginx/` directory inside your `stack_path` with subdirectories like `config`, `certs`, `secret`, and `www`.
2. **Create repo-specific directories**: Iterates over the `repos` list to create dedicated web-root folders for each repository's landing page.
3. **Deploy universal assets**: Copies the `files/` directory from the repository over to the target machine's `.assets/` directory to style the landing pages and directory indexes.
4. **Deploy nginx.conf**: Templates `config/nginx.conf.j2` to securely route traffic to the respective repository locations.
5. **Deploy GPG Key Generation Script**: Templates `config/generate-gpg.sh.j2`.
6. **Deploy Signing Scripts**: Generates a dedicated `sign-<repo>.sh` script for each repository.
7. **Deploy Syncing Scripts**: Generates a dedicated `sync-<repo>.sh` script for each repository based on its unique `source` and `target` configurations.
8. **Deploy Rollback Scripts**: Generates a dedicated `rollback-<repo>.sh` script for each repository.
9. **Deploy HTML Landing Pages**: Generates custom `index.html` files for each repository hosting the required `apt` one-liner.
10. **Deploy docker-compose.yml**: Deploys the configuration required to launch the NGINX container mapping the required repository endpoints.

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
