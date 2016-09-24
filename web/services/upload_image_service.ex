defmodule Cuenta.UserImageService do
  @upload_dir "uploads"

  def upload_image(image) do
    date = Timex.now("Asia/Tokyo") |> DateTime.to_date
    image_dir = "/images/users/#{date.year}/#{date.month}/#{date.day}/"
    File.mkdir_p!(@upload_dir <> image_dir)

    image_path = image_dir <> UUID.uuid4 <> Path.extname(image.filename)
    File.cp!(image.path, @upload_dir <> image_path)
    image_path
  end

  def remove_image(image_path) do
    unless image_path |> String.match?(~r/defaults/) do
      File.rm(@upload_dir <> image_path)
    end
  end
end
