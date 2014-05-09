require "spec_helper"
require "tempfile"

# TODO: Need to fix fog_credentials, as it works now it's not parsing erb. We could use the new rails configuration thing.
describe S3FileStorage, "#upload_file" do
  before(:all) do
    Fog.mock!
    Fog.credentials_path = Rails.root.join('config/fog_credentials.yml')
    connection = Fog::Storage.new(provider: "AWS")
    @bucket = connection.directories.create(key: "test-bucket")
    @file = Tempfile.new([ "kalle", ".txt" ])
  end

  it "is possible to upload a file to S3" do
    raise Fog.credentials.inspect
    storage.upload_file(full_path)

    expect(files_in_bucket.first).to include("kalle", ".txt")
  end

  it "is possible to download a file from S3" do
    storage.download_file(full_path)

    expect(File.open(full_path)).to_not be_nil
  end

  private

  def storage
    @storage ||= S3FileStorage.new
  end

  def full_path
    @file.path
  end

  def files_in_bucket
    @bucket.files.map(&:key)
  end
end
