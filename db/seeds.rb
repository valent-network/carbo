# frozen_string_literal: true
AdminUser.where(email: 'admin@recar.io').first_or_create(password: ENV.fetch('ACTIVE_ADMIN_PASSWORD'))
