# Small Linux based image with sourcehawk installed
FROM optum/sourcehawk:1.0.0-alpine

# Copy Entrypoint script into image and make sure its executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Execute the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
