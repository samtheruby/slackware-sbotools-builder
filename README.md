# Slackware SBO Builder

Docker image for building Slackware packages using sbotools from SlackBuilds.org (SBO) repository based on Slackware 15.0.

## Usage

The container automatically:
1. Updates the SlackBuilds repository
2. Builds all specified packages with dependencies
3. Saves built packages to `/packages` (mount this as a volume)

## Quick Start

Pull the image:
```bash
docker pull ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME:latest
```

Build a package:
```bash
docker run --rm -v $(pwd)/packages:/packages \
  ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME:latest package-name
```

Build multiple packages:
```bash
docker run --rm -v $(pwd)/packages:/packages \
  ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME:latest package1 package2 package3
```

### Examples

Build nginx:
```bash
docker run --rm -v $(pwd)/packages:/packages \
  ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME:latest nginx
```

Build with custom job count:
```bash
docker run --rm -v $(pwd)/packages:/packages \
  -e JOBS=4 \
  ghcr.io/YOUR_USERNAME/YOUR_REPO_NAME:latest nginx
```

## Environment Variables

- `PKG_DIR`: Output directory for built packages (default: `/packages`)
- `JOBS`: Number of parallel make jobs (default: 75% of CPU cores)

## Building Locally

```bash
docker build -t slackware-sbo-builder .
```
