# frozen_string_literal: true
class BackupDatabase < ApplicationJob
  BACKUPS_NUMBER_TO_PERSIST = 5
  BACKUP_TEMP_LOCATION = '/tmp/dump.sql'

  queue_as :default

  def perform
    # TODO: Here we first load all objects from backups folder. We assume, there
    # will be just a few files, much less than required to span multiple pages
    # on S3. But in theory of course we should use :query parameter (missing in
    # AWS Ruby SDK) to order by date
    backups = []

    # Here we depend on pg_dump executable present in the system (Docker image)
    %x(pg_dump --exclude-table-data versions -Fc -h $POSTGRESQL_SERVICE_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE > #{BACKUP_TEMP_LOCATION})

    backup_file_name = "backups/#{Time.now.to_i}-recario-#{Date.today.strftime('%y-%m-%d')}.dump.sql"
    S3_CLIENT.put_object(bucket: ENV['DO_SPACE_NAME'], key: backup_file_name, body: File.new(BACKUP_TEMP_LOCATION))

    FileUtils.rm(BACKUP_TEMP_LOCATION)
    response = S3_CLIENT.list_objects(bucket: ENV['DO_SPACE_NAME'], prefix: 'backups/')

    response.contents.each do |object|
      backups << object.key if object.key =~ /.+\.dump\.sql\Z/
    end

    if backups.size > BACKUPS_NUMBER_TO_PERSIST

      to_delete = backups.sort.reverse[BACKUPS_NUMBER_TO_PERSIST..-1]

      to_delete.each do |backup|
        S3_CLIENT.delete_object(key: backup, bucket: ENV['DO_SPACE_NAME'])
      end
    end
  end
end
