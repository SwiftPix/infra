# Dockerfile

FROM nginx:alpine

WORKDIR /etc/nginx

# Copy the custom nginx.conf to the container
COPY nginx.conf nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
