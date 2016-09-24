defmodule Cuenta.UserImageService do
  def upload_image(image) do
    date = Timex.now("Asia/Tokyo") |> DateTime.to_date
    image_dir = "/images/users/#{date.year}/#{date.month}/#{date.day}/"
    File.mkdir_p!("uploads#{image_dir}")

    image_path = image_dir <> UUID.uuid4 <> Path.extname(image.filename)
    File.cp!(image.path, "uploads#{image_path}")
    image_path
  end
end
