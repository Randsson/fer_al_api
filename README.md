# Fer Al API

API RESTful para a plataforma Fer Al - conectando organizadores e visitantes de feirinhas em Alagoas.

## 🚀 Tecnologias

- **Ruby 3.3.6** (via RVM)
- **Rails 8.0.2.1** - Framework web
- **SQLite3** - Banco de dados (desenvolvimento)
- **PostgreSQL** - Banco de dados (produção)
- **JWT** - Autenticação
- **Geocoder** - Geocodificação de endereços
- **Kaminari** - Paginação
- **Rack-CORS** - Cross-Origin Resource Sharing

## 📋 Pré-requisitos

### Ruby e Rails
- **Ruby 3.3.6** (recomendado via RVM)
- **Rails 8.0.2.1**
- **Bundler** para gerenciamento de gems

### Banco de Dados
- **SQLite3** (desenvolvimento/teste)
- **PostgreSQL** (produção)

### Sistema
- **Git**
- **Node.js** (para assets do Rails)

## 🛠️ Instalação

### 1. Clone o repositório
```bash
git clone <repository-url>
cd fer_al_api
```

### 2. Instale as dependências Ruby
```bash
# Instalar gems
bundle install

# Verificar versão do Ruby (deve ser 3.3.6)
ruby -v
```

### 3. Configure o banco de dados
```bash
# Criar e migrar o banco de dados
rails db:create
rails db:migrate

# Popular com dados de exemplo
rails db:seed
```

### 4. Configure as credenciais (se necessário)
```bash
# Editar credenciais Rails
rails credentials:edit

# Ou usar variáveis de ambiente para secrets
export SECRET_KEY_BASE=your_secret_key_here
```

## 🚀 Executando o Projeto

### Desenvolvimento
```bash
# Iniciar servidor Rails
rails server

# Ou especificar porta e host
rails server -b 0.0.0.0 -p 3000

# Em background
rails server -d
```

### Console Rails
```bash
# Abrir console Rails
rails console

# Executar comandos específicos
rails runner "puts User.count"
```

### Tarefas Rake
```bash
# Listar todas as tarefas disponíveis
rails -T

# Executar migrações
rails db:migrate

# Reverter migração
rails db:rollback

# Reset completo do banco
rails db:drop db:create db:migrate db:seed
```

## 📊 Estrutura do Banco de Dados

### Principais Tabelas
- **users** - Usuários (organizadores, visitantes, admins)
- **categories** - Categorias de eventos
- **events** - Eventos/feirinhas
- **event_images** - Imagens dos eventos
- **reviews** - Avaliações dos eventos
- **notifications** - Notificações do sistema
- **user_event_interests** - Interesses dos usuários

### Modelos Principais
- **User** - Gestão de usuários com autenticação
- **Event** - CRUD de eventos com geocodificação
- **Category** - Categorias com cores e ícones
- **Review** - Sistema de avaliações
- **Notification** - Notificações do sistema

## 🔐 Autenticação

### JWT Token
- **Algoritmo**: HS256
- **Expiração**: 24 horas
- **Header**: `Authorization: Bearer <token>`

### Tipos de Usuário
- **visitor** - Visitante comum
- **organizer** - Organizador de eventos
- **admin** - Administrador do sistema

### Endpoints de Autenticação
```bash
# Login
POST /api/v1/auth/login
{
  "email": "user@example.com",
  "password": "password"
}

# Registro
POST /api/v1/auth/register
{
  "name": "Nome",
  "email": "user@example.com",
  "password": "password",
  "user_type": "visitor"
}
```

## 📡 Endpoints da API

### Autenticação
- `POST /api/v1/auth/login` - Login
- `POST /api/v1/auth/register` - Registro
- `POST /api/v1/auth/logout` - Logout

### Eventos
- `GET /api/v1/events` - Listar eventos
- `GET /api/v1/events/:id` - Detalhes do evento
- `POST /api/v1/events` - Criar evento (organizadores)
- `PUT /api/v1/events/:id` - Atualizar evento
- `DELETE /api/v1/events/:id` - Excluir evento
- `GET /api/v1/events/search` - Buscar eventos
- `GET /api/v1/events/featured` - Eventos em destaque
- `GET /api/v1/events/upcoming` - Próximos eventos
- `GET /api/v1/events/interested` - Eventos de interesse
- `POST /api/v1/events/:id/toggle_interest` - Toggle interesse
- `POST /api/v1/events/:id/add_image` - Adicionar imagem

### Categorias
- `GET /api/v1/categories` - Listar categorias
- `GET /api/v1/categories/:id` - Detalhes da categoria
- `POST /api/v1/categories` - Criar categoria (admins)
- `PUT /api/v1/categories/:id` - Atualizar categoria
- `DELETE /api/v1/categories/:id` - Excluir categoria

### Avaliações
- `GET /api/v1/events/:event_id/reviews` - Listar avaliações
- `POST /api/v1/events/:event_id/reviews` - Criar avaliação
- `PUT /api/v1/reviews/:id` - Atualizar avaliação
- `DELETE /api/v1/reviews/:id` - Excluir avaliação

### Notificações
- `GET /api/v1/notifications` - Listar notificações
- `PUT /api/v1/notifications/:id/read` - Marcar como lida

## 🧪 Testes

### Executar Testes
```bash
# Todos os testes
rails test

# Testes específicos
rails test test/models/user_test.rb
rails test test/controllers/api/v1/events_controller_test.rb

# Com verbose
rails test -v
```

### Testes de Integração
```bash
# Testar endpoints da API
rails test test/requests/api/v1/events_test.rb
```

## 🔧 Scripts Úteis

### Desenvolvimento
```bash
# Verificar rotas
rails routes | grep events

# Console com dados carregados
rails console --sandbox

# Verificar logs
tail -f log/development.log

# Limpar cache
rails tmp:clear
```

### Produção
```bash
# Compilar assets
rails assets:precompile

# Verificar credenciais
rails credentials:show

# Executar migrações em produção
RAILS_ENV=production rails db:migrate
```

## 🐳 Docker

### Dockerfile incluído
```bash
# Build da imagem
docker build -t fer-al-api .

# Executar container
docker run -p 3000:3000 fer-al-api
```

### Docker Compose (se configurado)
```bash
# Subir todos os serviços
docker-compose up -d

# Ver logs
docker-compose logs -f

# Parar serviços
docker-compose down
```

## 📝 Variáveis de Ambiente

### Desenvolvimento
```bash
# .env (criar se necessário)
SECRET_KEY_BASE=your_secret_key_here
DATABASE_URL=sqlite3:db/development.sqlite3
```

### Produção
```bash
# Configurações recomendadas
SECRET_KEY_BASE=your_production_secret_key
DATABASE_URL=postgresql://user:password@host:port/database
RAILS_ENV=production
```

## 🔍 Debugging

### Logs
```bash
# Desenvolvimento
tail -f log/development.log

# Produção
tail -f log/production.log

# Apenas erros
grep ERROR log/development.log
```

### Console Rails
```bash
# Debugging interativo
rails console

# Exemplos úteis
User.find(1)
Event.includes(:category, :user).first
Category.with_events.count
```

## 🚀 Deploy

### Kamal (Recomendado)
```bash
# Configurar deploy
kamal setup

# Deploy
kamal deploy

# Rollback
kamal rollback
```

### Manual
```bash
# Build de produção
RAILS_ENV=production bundle install --without development test
RAILS_ENV=production rails assets:precompile
RAILS_ENV=production rails db:migrate

# Iniciar servidor
RAILS_ENV=production rails server
```

## 📊 Monitoramento

### Métricas
- **Performance**: Logs de request time
- **Erros**: Exception tracking
- **Uso**: Contadores de endpoints

### Health Check
```bash
# Endpoint de saúde
curl http://localhost:3000/api/v1/health

# Status do banco
rails runner "puts ActiveRecord::Base.connection.active?"
```

## 🔒 Segurança

### Implementado
- **JWT Authentication** com expiração
- **CORS** configurado para frontend
- **Validações** de entrada em todos os endpoints
- **Sanitização** de dados do usuário
- **Rate limiting** (se configurado)

### Recomendações
- Usar HTTPS em produção
- Configurar firewall adequado
- Monitorar logs de segurança
- Atualizar dependências regularmente

## 📚 Documentação da API

### Swagger/OpenAPI
- Documentação disponível em `/api-docs` (se configurado)
- Postman collection incluída (`collection.json`)

### Exemplos de Uso
```bash
# Criar evento
curl -X POST http://localhost:3000/api/v1/events \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "event": {
      "title": "Feira de Artesanato",
      "description": "Feira tradicional de artesanato local",
      "start_date": "2025-09-20T08:00:00",
      "end_date": "2025-09-20T18:00:00",
      "address": "Praça dos Martírios, Maceió, AL",
      "category_id": 1,
      "status": "published"
    }
  }'
```