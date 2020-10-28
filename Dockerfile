# Small Linux based image with sourcehawk installed
FROM optumopensource/sourcehawk:0.1.3-alpine

# Copy Entrypoint script into image and make sure its executable
COPY entrypoint.sh /entrypoint.sh

# Execute the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
