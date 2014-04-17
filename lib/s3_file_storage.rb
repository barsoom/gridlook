require "fog"

class S3FileStorage
  def initialize
    Fog.credentials_path = "#{Rails.root}/config/fog_credentials.yml"
    connection = Fog::Storage.new(provider: "aws")
    @bucket = connection.directories.get(ENV["AWS_BUCKET"] || "test-bucket")
  end

  def upload_file(full_path)
    @bucket.files.create(key: file_name(full_path), body: File.open(full_path))
  end

  def download_file(full_path)
    content = @bucket.files.get(file_name(full_path))
    File.open(full_path, "w+") do |file| file.write(content) end
  end

  def file_name(full_path)
    full_path.split("/").last
  end
end
