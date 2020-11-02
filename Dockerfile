# Github Docs: https://docs.github.com/en/free-pro-team@latest/actions/creating-actions/dockerfile-support-for-github-actions

# Small Linux based image with sourcehawk installed
FROM optumopensource/sourcehawk:0.1.5-alpine

# Need root to write
USER root

# Repository gets mounted to this directory
WORKDIR /github/workspace

# Copy Entrypoint script into image
COPY entrypoint.sh /entrypoint.sh

# Execute the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
