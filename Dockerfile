# Use the official NGINX image from Docker Hub
FROM nginx:latest

# Copy your custom nginx.conf to the container
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 8080 (where NGINX will listen for incoming requests)
EXPOSE 8080

# Start NGINX when the container launches
CMD ["nginx", "-g", "daemon off;"]
