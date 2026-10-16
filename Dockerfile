FROM alpine:3.19

# Install required lightweight tools
RUN apk add --no-cache bash coreutils iputils bind-tools netcat-openbsd

WORKDIR /app

# Copy application files into the image
COPY app/ /app/

# Normalize line endings (CRLF -> LF) and set executable permissions
RUN sed -i 's/\r$//' /app/*.sh && chmod +x /app/*.sh

# Configure ENTRYPOINT and CMD
ENTRYPOINT ["/app/diagnostic.sh"]
CMD ["help"]
