FROM alpine:3.19

# Install required lightweight tools
RUN apk add --no-cache bash coreutils iputils bind-tools netcat-openbsd

WORKDIR /app

# Copy application files into the image
COPY app/ /app/

# Set executable permissions for application scripts
RUN chmod +x /app/*.sh

# Configure ENTRYPOINT and CMD
ENTRYPOINT ["/app/diagnostic.sh"]
CMD ["help"]
