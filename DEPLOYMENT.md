# 🚀 Guia de Deployment - Fer Al API

## Preparação para Produção

### 1. Configuração do Banco PostgreSQL

```bash
# Instalar PostgreSQL
sudo apt-get install postgresql postgresql-contrib

# Criar usuário e banco
sudo -u postgres createuser -s fer_al_api
sudo -u postgres createdb fer_al_api_production -O fer_al_api
```

### 2. Variáveis de Ambiente

Criar arquivo `.env` na raiz do projeto:

```env
RAILS_ENV=production
SECRET_KEY_BASE=your_secret_key_base_here
FER_AL_API_DATABASE_PASSWORD=your_database_password
DATABASE_HOST=localhost
DATABASE_PORT=5432
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

### 3. Configuração do Servidor

```bash
# Instalar gems de produção
bundle install --without development test

# Precompilar assets (se necessário)
RAILS_ENV=production bundle exec rails assets:precompile

# Executar migrations
RAILS_ENV=production bundle exec rails db:migrate

# Executar seeds (opcional)
RAILS_ENV=production bundle exec rails db:seed
```

### 4. Configuração com Docker

#### Dockerfile
```dockerfile
FROM ruby:3.3.6

# Instalar dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Definir diretório de trabalho
WORKDIR /app

# Copiar Gemfile
COPY Gemfile Gemfile.lock ./

# Instalar gems
RUN bundle install

# Copiar código da aplicação
COPY . .

# Precompilar assets
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Expor porta
EXPOSE 3000

# Comando padrão
CMD ["rails", "server", "-b", "0.0.0.0"]
```

#### docker-compose.yml
```yaml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: fer_al_api_production
      POSTGRES_USER: fer_al_api
      POSTGRES_PASSWORD: your_password_here
    volumes:
      - postgres_data:/var/lib/postgresql/data

  web:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      DATABASE_HOST: db
      FER_AL_API_DATABASE_PASSWORD: your_password_here
      RAILS_ENV: production
      SECRET_KEY_BASE: your_secret_key_base_here
    volumes:
      - ./storage:/app/storage

volumes:
  postgres_data:
```

### 5. Configuração com Nginx (Opcional)

```nginx
server {
    listen 80;
    server_name seu-dominio.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 6. Configuração SSL com Certbot

```bash
# Instalar certbot
sudo apt install certbot python3-certbot-nginx

# Obter certificado
sudo certbot --nginx -d seu-dominio.com

# Renovação automática
sudo crontab -e
# Adicionar: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 7. Monitoramento e Logs

```bash
# Ver logs da aplicação
tail -f log/production.log

# Monitorar processo
ps aux | grep rails

# Verificar status do banco
sudo -u postgres psql -c "\l"
```

### 8. Backup do Banco de Dados

```bash
# Criar backup
pg_dump -U fer_al_api -h localhost fer_al_api_production > backup_$(date +%Y%m%d).sql

# Restaurar backup
psql -U fer_al_api -h localhost fer_al_api_production < backup_20240115.sql
```

### 9. Configurações de Segurança

#### Firewall
```bash
# Permitir apenas portas necessárias
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

#### Configuração adicional no Rails
```ruby
# config/environments/production.rb
config.force_ssl = true
config.ssl_options = { redirect: { exclude: ->(request) { request.path =~ /health/ } } }
```

### 10. Deploy com Kamal (Recomendado)

A aplicação já vem configurada com Kamal. Para fazer deploy:

```bash
# Configurar secrets
echo "your_secret_key_base" | kamal env push SECRET_KEY_BASE

# Deploy inicial
kamal setup

# Deploys subsequentes
kamal deploy
```

### 11. Verificação do Deploy

```bash
# Testar endpoints
curl https://seu-dominio.com/api/v1/events
curl https://seu-dominio.com/up

# Verificar SSL
curl -I https://seu-dominio.com
```

### 12. Manutenção

#### Atualização da aplicação
```bash
git pull origin main
bundle install --without development test
RAILS_ENV=production bundle exec rails db:migrate
sudo systemctl restart fer_al_api
```

#### Limpeza de logs
```bash
# Limpar logs antigos
sudo logrotate -f /etc/logrotate.conf
```

### 13. Troubleshooting

#### Problemas comuns:

1. **Erro de conexão com banco**:
   - Verificar credenciais em `config/database.yml`
   - Confirmar que PostgreSQL está rodando

2. **Secret key base não configurada**:
   ```bash
   RAILS_ENV=production bundle exec rails secret
   ```

3. **Problemas de permissão**:
   ```bash
   sudo chown -R www-data:www-data /path/to/app
   ```

4. **Logs não aparecem**:
   - Verificar configuração em `config/environments/production.rb`
   - Confirmar permissões do diretório `log/`

### 14. Monitoramento Avançado

Para produção, considere implementar:

- **New Relic** ou **DataDog** para APM
- **Sentry** para tracking de erros
- **Prometheus + Grafana** para métricas
- **ELK Stack** para análise de logs

### 15. Escalabilidade

Para alta demanda:

- **Load Balancer** (Nginx, HAProxy)
- **Redis** para cache e sessions
- **CDN** para assets estáticos
- **Database read replicas**
- **Background job processing** com Sidekiq

---

## 📞 Suporte

Para questões de deployment, consulte a documentação do Rails ou entre em contato com a equipe de desenvolvimento.

**Boa sorte com o deploy! 🚀**
