class Message
  def self.not_found(record = 'record')
    "Desculpe, #{record} não encontrado."
  end

  def self.invalid_credentials
    'Credenciais inválidas'
  end

  def self.invalid_token
    'Token inválido'
  end

  def self.missing_token
    'Token ausente'
  end

  def self.unauthorized
    'Requisição não autorizada'
  end

  def self.account_created
    'Conta criada com sucesso'
  end

  def self.account_not_created
    'Conta não pôde ser criada'
  end

  def self.expired_token
    'Token expirado'
  end
end
