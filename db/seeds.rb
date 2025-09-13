# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Criando dados iniciais..."

# Criar usuário administrador
admin = User.find_or_create_by(email: 'admin@feral.com') do |user|
  user.first_name = 'Admin'
  user.last_name = 'Sistema'
  user.password = 'admin123'
  user.password_confirmation = 'admin123'
  user.user_type = :admin
  user.address = 'Maceió, AL'
  user.latitude = -9.6658
  user.longitude = -35.7353
end

puts "✅ Admin criado: #{admin.email}"

# Criar categorias
categories_data = [
  {
    name: 'Artesanato',
    description: 'Produtos artesanais, trabalhos manuais e arte local',
    color: '#8B4513',
    icon: '🎨'
  },
  {
    name: 'Alimentos',
    description: 'Comidas típicas, doces, bebidas e produtos gastronômicos',
    color: '#FF6347',
    icon: '🍲'
  },
  {
    name: 'Moda',
    description: 'Roupas, acessórios, calçados e produtos de moda',
    color: '#FF1493',
    icon: '👗'
  },
  {
    name: 'Eventos Culturais',
    description: 'Shows, apresentações, festivais e eventos culturais',
    color: '#9370DB',
    icon: '🎭'
  },
  {
    name: 'Produtos Orgânicos',
    description: 'Frutas, verduras, produtos naturais e orgânicos',
    color: '#32CD32',
    icon: '🌱'
  },
  {
    name: 'Tecnologia',
    description: 'Produtos tecnológicos, eletrônicos e inovações',
    color: '#4169E1',
    icon: '💻'
  }
]

categories = categories_data.map do |cat_data|
  Category.find_or_create_by(name: cat_data[:name]) do |category|
    category.description = cat_data[:description]
    category.color = cat_data[:color]
    category.icon = cat_data[:icon]
  end
end

puts "✅ #{categories.size} categorias criadas"

# Criar usuários organizadores
organizers_data = [
  {
    first_name: 'Maria',
    last_name: 'Silva',
    email: 'maria@organizadora.com',
    address: 'Centro, Maceió, AL',
    latitude: -9.6658,
    longitude: -35.7353
  },
  {
    first_name: 'João',
    last_name: 'Santos',
    email: 'joao@organizador.com',
    address: 'Pajuçara, Maceió, AL',
    latitude: -9.6918,
    longitude: -35.7181
  },
  {
    first_name: 'Ana',
    last_name: 'Costa',
    email: 'ana@organizadora.com',
    address: 'Ponta Verde, Maceió, AL',
    latitude: -9.6801,
    longitude: -35.7056
  }
]

organizers = organizers_data.map do |org_data|
  User.find_or_create_by(email: org_data[:email]) do |user|
    user.first_name = org_data[:first_name]
    user.last_name = org_data[:last_name]
    user.password = 'organizador123'
    user.password_confirmation = 'organizador123'
    user.user_type = :organizer
    user.address = org_data[:address]
    user.latitude = org_data[:latitude]
    user.longitude = org_data[:longitude]
    user.phone = "(82) 9#{rand(1000..9999)}-#{rand(1000..9999)}"
  end
end

puts "✅ #{organizers.size} organizadores criados"

# Criar usuários visitantes
visitors_data = [
  {
    first_name: 'Carlos',
    last_name: 'Oliveira',
    email: 'carlos@visitante.com'
  },
  {
    first_name: 'Fernanda',
    last_name: 'Lima',
    email: 'fernanda@visitante.com'
  },
  {
    first_name: 'Pedro',
    last_name: 'Rocha',
    email: 'pedro@visitante.com'
  }
]

visitors = visitors_data.map do |vis_data|
  User.find_or_create_by(email: vis_data[:email]) do |user|
    user.first_name = vis_data[:first_name]
    user.last_name = vis_data[:last_name]
    user.password = 'visitante123'
    user.password_confirmation = 'visitante123'
    user.user_type = :visitor
    user.address = 'Maceió, AL'
    user.phone = "(82) 9#{rand(1000..9999)}-#{rand(1000..9999)}"
  end
end

puts "✅ #{visitors.size} visitantes criados"

# Criar eventos
events_data = [
  {
    title: 'Feira de Artesanato de Pajuçara',
    description: 'Uma feira repleta de produtos artesanais únicos, feitos por artesãos locais. Encontre peças decorativas, utensílios domésticos, joias e muito mais.',
    start_date: 2.days.from_now,
    end_date: 2.days.from_now + 8.hours,
    address: 'Praia de Pajuçara, Maceió, AL',
    latitude: -9.6918,
    longitude: -35.7181,
    status: :published,
    featured: true,
    category: Category.find_by(name: 'Artesanato'),
    user: organizers[0]
  },
  {
    title: 'Festival Gastronômico de Alagoas',
    description: 'Deguste os melhores pratos típicos alagoanos em um só lugar. Sururu, peixe assado, tapioca e muito mais.',
    start_date: 5.days.from_now,
    end_date: 5.days.from_now + 12.hours,
    address: 'Mercado do Artesanato, Maceió, AL',
    latitude: -9.6658,
    longitude: -35.7353,
    status: :published,
    featured: true,
    category: Category.find_by(name: 'Alimentos'),
    user: organizers[1]
  },
  {
    title: 'Feira de Moda Sustentável',
    description: 'Roupas e acessórios produzidos de forma sustentável por designers locais. Moda consciente e estilosa.',
    start_date: 1.week.from_now,
    end_date: 1.week.from_now + 6.hours,
    address: 'Shopping Ponta Verde, Maceió, AL',
    latitude: -9.6801,
    longitude: -35.7056,
    status: :published,
    featured: false,
    category: Category.find_by(name: 'Moda'),
    user: organizers[2]
  },
  {
    title: 'Mostra Cultural Nordestina',
    description: 'Apresentações de música, dança e teatro celebrando a rica cultura nordestina.',
    start_date: 10.days.from_now,
    end_date: 10.days.from_now + 4.hours,
    address: 'Teatro Deodoro, Maceió, AL',
    latitude: -9.6658,
    longitude: -35.7353,
    status: :published,
    featured: true,
    category: Category.find_by(name: 'Eventos Culturais'),
    user: organizers[0]
  },
  {
    title: 'Feira Orgânica da Cidade',
    description: 'Produtos orgânicos frescos diretamente dos produtores locais. Frutas, verduras, legumes e produtos naturais.',
    start_date: 3.days.from_now,
    end_date: 3.days.from_now + 5.hours,
    address: 'Parque Municipal, Maceió, AL',
    latitude: -9.6658,
    longitude: -35.7353,
    status: :published,
    featured: false,
    category: Category.find_by(name: 'Produtos Orgânicos'),
    user: organizers[1]
  }
]

events = events_data.map do |event_data|
  Event.create!(event_data)
end

puts "✅ #{events.size} eventos criados"

# Criar algumas imagens para os eventos
events.each_with_index do |event, index|
  2.times do |i|
    EventImage.create!(
      event: event,
      url: "https://picsum.photos/800/600?random=#{index * 10 + i}",
      caption: "Imagem #{i + 1} do evento #{event.title}"
    )
  end
end

puts "✅ Imagens dos eventos criadas"

# Criar algumas avaliações para eventos passados
past_event = Event.create!(
  title: 'Feira de Artesanato - Edição Passada',
  description: 'Uma feira que já aconteceu para demonstrar o sistema de avaliações.',
  start_date: 1.week.ago,
  end_date: 1.week.ago + 6.hours,
  address: 'Centro, Maceió, AL',
  latitude: -9.6658,
  longitude: -35.7353,
  status: :finished,
  featured: false,
  category: Category.find_by(name: 'Artesanato'),
  user: organizers[0]
)

visitors.each do |visitor|
  Review.create!(
    user: visitor,
    event: past_event,
    rating: rand(3..5),
    comment: "Evento muito bom! Recomendo para todos. #{['Adorei os produtos!', 'Organização excelente!', 'Voltarei na próxima edição!'].sample}"
  )
end

puts "✅ Avaliações criadas para evento passado"

# Criar algumas notificações
organizers.each do |organizer|
  Notification.create!(
    user: organizer,
    title: 'Bem-vindo ao Fer Al!',
    message: 'Sua conta de organizador foi criada com sucesso. Comece criando seu primeiro evento.',
    notification_type: :system_message
  )
end

puts "✅ Notificações criadas"

puts ""
puts "🎉 Seeds executados com sucesso!"
puts ""
puts "👤 Usuários criados:"
puts "   Admin: admin@feral.com (senha: admin123)"
puts "   Organizadores: maria@organizadora.com, joao@organizador.com, ana@organizadora.com (senha: organizador123)"
puts "   Visitantes: carlos@visitante.com, fernanda@visitante.com, pedro@visitante.com (senha: visitante123)"
puts ""
puts "📊 Dados criados:"
puts "   - #{Category.count} categorias"
puts "   - #{User.count} usuários"
puts "   - #{Event.count} eventos"
puts "   - #{EventImage.count} imagens de eventos"
puts "   - #{Review.count} avaliações"
puts "   - #{Notification.count} notificações"