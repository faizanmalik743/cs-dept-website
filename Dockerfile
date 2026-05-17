# ─────────────────────────────────────────────
# Stage 1: Lint HTML/CSS (optional build stage)
# ─────────────────────────────────────────────
FROM node:20-alpine AS lint
WORKDIR /app
COPY src/ ./src/
# Install html-validate for linting (CI can use this stage)
RUN npm install -g html-validate && \
    for f in src/*.html; do html-validate "$f" || true; done

# ─────────────────────────────────────────────
# Stage 2: Serve with Nginx (production image)
# ─────────────────────────────────────────────
FROM nginx:1.25-alpine

# Remove default Nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy static site files
COPY src/ /usr/share/nginx/html/

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Nginx runs in foreground
CMD ["nginx", "-g", "daemon off;"]
