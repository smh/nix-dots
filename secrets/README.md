# Secrets Management with sops-nix

This directory contains encrypted secrets managed with sops-nix.

## Key Files

- `keys.txt` - Personal age key (NEVER COMMIT THIS FILE)
- `*.yaml` - Encrypted secrets files (safe to commit)

## Personal Age Key

Your personal age key public key: `age1f29rsezfv7rf2v9p0wvr7q3w69hdzcxf8mxvysavsr5e60dwkgmsvnu0q0`

## Adding Machine SSH Keys

For each machine, you need to convert its SSH host key to an age key:

### On the target machine:

```bash
# Get the SSH host key's age public key
nix-shell -p ssh-to-age --run "ssh-keyscan <hostname> | ssh-to-age"

# Or if you have local access:
nix-shell -p ssh-to-age --run "cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age"
```

### Update .sops.yaml with the new public key:

Add the machine's age public key to the `keys` section in `.sops.yaml`.

## Editing Secrets

To edit encrypted secrets:

```bash
# Set your age key
export SOPS_AGE_KEY_FILE=./secrets/keys.txt

# Edit a secrets file
nix-shell -p sops --run "sops secrets/common.yaml"
```

## Creating New Secrets Files

```bash
export SOPS_AGE_KEY_FILE=./secrets/keys.txt
nix-shell -p sops --run "sops secrets/newsecret.yaml"
```
