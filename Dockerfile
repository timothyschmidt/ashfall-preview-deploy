FROM mcr.microsoft.com/dotnet/aspnet:8.0-bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# Use a short-lived, asset-scoped signed release URL; never a repository API token.
ARG ASHFALL_PACKAGE_URL
ARG ASHFALL_PACKAGE_SHA256
RUN test -n "$ASHFALL_PACKAGE_URL" && test -n "$ASHFALL_PACKAGE_SHA256" && \
    curl --fail --silent --show-error --location --proto '=https' "$ASHFALL_PACKAGE_URL" -o /tmp/package.tar.gz && \
    echo "$ASHFALL_PACKAGE_SHA256  /tmp/package.tar.gz" | sha256sum -c - && \
    tar -xzf /tmp/package.tar.gz -C /app && rm /tmp/package.tar.gz
ENV ASHFALL_DATA_DIR=/var/data/ashfall \
    ASHFALL_WEB_ROOT=/app/web \
    ASHFALL_STARTER_PROFILE=/app/content/starter-profile.json \
    ASHFALL_REGISTRY=/app/content/first-playable-registry.json \
    PORT=10000
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod 755 /app/entrypoint.sh
EXPOSE 10000
ENTRYPOINT ["/app/entrypoint.sh"]
