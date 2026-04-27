# Updates and Rollbacks

Because the sync mechanics utilize `rsync --link-dest`, every synchronization produces a complete `YYYYMMDD` snapshot folder. Unchanged files are hard-linked against the previous snapshot, while modified or new files are downloaded natively.

This enables trivial, instant rollbacks to any historical snapshot.

## The Manifest File
When a sync occurs, the script generates a `manifest-YYYYMMDD.txt` file at the root of the repository's `target.host_path`. 

This file acts similarly to `ls -la` but appends the SHA256 cryptographic hash of every file. It allows administrators to perfectly audit the contents of a snapshot at the exact time the repository was mirrored.

## Rolling Back

If an upstream repository pushes a broken package update and it successfully synchronizes to your mirror, you can instantly roll back clients to a previous known-good state.

1. Navigate to the repository configuration folder on the target host.
2. Execute the rollback script for the broken repository, passing the target `YYYYMMDD` date you wish to revert to.

```bash
bash /opt/repo/repo_control/ubuntu/rollback-ubuntu.sh 20260324
```

### What Happens During a Rollback?
The rollback script performs three key actions:
1. Validates that the requested `YYYYMMDD` directory exists.
2. Atomically updates the `Latest` symlink to point to the historical directory.
3. Automatically triggers the `sign-<repo>.sh` script to re-sign the `Release` files in the historical directory using your active GPG keys.

As long as clients run `apt update`, they will immediately see the repository state reverted to the snapshot date!
