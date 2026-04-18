# Use a faster, smaller base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Use a FAST Debian mirror (Cloudflare)
RUN sed -i 's|deb.debian.org|deb.debian.org.cloudflare-dns.com|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        default-libmysqlclient-dev \
        pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first (better caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app
COPY . .

# Expose Flask port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
