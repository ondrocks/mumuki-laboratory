require 'apartment/elevators/first_subdomain'

Apartment.configure do |config|

  config.excluded_models = %w{ User Assignment Exercise Guide Import Language Tenant }

  config.tenant_names = lambda { Tenant.pluck :name }


  # Apartment can be forced to use raw SQL dumps instead of schema.rb for creating new schemas.
  # Use this when you are using some extra features in PostgreSQL that can't be respresented in
  # schema.rb, like materialized views etc. (only applies with use_schemas set to true).
  # (Note: this option doesn't use db/structure.sql, it creates SQL dump by executing pg_dump)
  #
  # config.use_sql = false

  # There are cases where you might want some schemas to always be in your search_path
  # e.g when using a PostgreSQL extension like hstore.
  # Any schemas added here will be available along with your selected Tenant.
  #
  # config.persistent_schemas = %w{ hstore }

end

Rails.application.config.middleware.use 'Apartment::Elevators::FirstSubdomain'
