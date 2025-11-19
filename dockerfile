# ================================================
# Nginx oficial + configuração segura e leve
# ================================================
FROM nginx:alpine3.20 AS runtime

# Remove configuração default do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia nossa configuração personalizada
COPY nginx.conf /etc/nginx/conf.d/toshiro.conf

# (Opcional) Copia arquivos estáticos se tiver (ex: front-end React/Vue)
# COPY ./public/ /var/www/html/

# Segurança básica (remove informações do servidor)
RUN echo "server_tokens off;" > /etc/nginx/conf.d/security.conf && \
    echo "add_header X-Content-Type-Options nosniff;" >> /etc/nginx/conf.d/security.conf && \
    echo "add_header X-Frame-Options DENY;" >> /etc/nginx/conf.d/security.conf && \
    echo "add_header X-XSS-Protection '1; mode=block';" >> /etc/nginx/conf.d/security.conf

# Permissões corretas (não rodar como root)
RUN apk add --no-cache shadow && \
    groupmod -g 1001 nginx && \
    usermod -u 1001 -g 1001 nginx && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

# Troca para usuário não-root (segurança!)
USER nginx

# Porta padrão
EXPOSE 80

# Healthcheck (fundamental em microsserviços)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/health || exit 1

# Inicia o Nginx em foreground (obrigatório no Docker)
CMD ["nginx", "-g", "daemon off;"]
