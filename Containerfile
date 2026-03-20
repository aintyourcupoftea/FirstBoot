FROM docker.io/library/nginx:alpine

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy our config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy the static site
COPY index.html /usr/share/nginx/html/index.html
COPY email-template.html /usr/share/nginx/html/email-template.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

118cb446e7642b0c430dfacac75e11858e
