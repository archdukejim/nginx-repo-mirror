# Operations Guide

This document outlines the day-to-day operations required to maintain your NGINX Repository Mirror.

## Synchronizing Repositories

Upstream repositories update constantly. You must routinely run the synchronization scripts to pull down new packages. 

Each repository has a dedicated script located at `{{ stack_path }}/nginx/config/sync-<repo_name>.sh`.

### Manual Sync
To manually trigger a synchronization for a specific repository (e.g., Ubuntu):
```bash
bash /opt/nginx/config/sync-ubuntu.sh
```

### Automated Sync (Cron)
It is highly recommended to automate synchronization via Cron. You can configure individual cron jobs to balance network load.

Run `crontab -e` and add the following (adjusting times as needed):
```bash
# Sync Ubuntu every night at 2:00 AM
0 2 * * * /bin/bash /opt/nginx/config/sync-ubuntu.sh >> /var/log/sync-ubuntu.log 2>&1

# Sync ClamAV every night at 4:00 AM
0 4 * * * /bin/bash /opt/nginx/config/sync-clamav.sh >> /var/log/sync-clamav.log 2>&1
```

## Managing GPG Keys

### Generating Keys
During initial deployment, the `generate-gpg.sh` script is run. If you ever need to rotate or regenerate your keys:
1. Delete the old keys in `{{ stack_path }}/nginx/secret/` and `{{ stack_path }}/nginx/www/`.
2. Run `bash /opt/nginx/config/generate-gpg.sh`.
3. Re-sign your repositories using the signing scripts.

### Re-Signing Repositories
If a signature expires, a GPG key changes, or you manually modify the contents of the `Latest` directory, you must re-sign the `Release` files.

Each repository has a dedicated signing script.
```bash
bash /opt/nginx/config/sign-ubuntu.sh
```
This command scans the `Latest` directory, removes old signatures, and applies fresh detached and clearsign signatures based on the current GPG key.
