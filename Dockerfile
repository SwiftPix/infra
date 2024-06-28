# Use a imagem base do Nginx
FROM nginx:alpine

# Ajuste as permissões necessárias durante a construção da imagem
USER root

# Crie os diretórios necessários com as permissões adequadas
RUN mkdir -p /var/cache/nginx/client_temp \
    && chmod 755 /var/cache/nginx/client_temp \
    && chown nginx:nginx /var/cache/nginx/client_temp

# Copie o arquivo de configuração personalizado do Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Exponha a porta 80 para o tráfego externo
EXPOSE 80

# Defina o comando de entrada padrão para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
