# frozen_string_literal: true

require 'rubygems'
require 'rmagick'
require 'fileutils'
require 'rqrcode'

module QrcodeUtility
  # QR code genarator
  class QR
    def self.generate_qrcode(source_data, qrfile_name)
      qrcode = RQRCode::QRCode.new(source_data)

      # NOTE: showing with default options specified explicitly
      png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: 'black',
        file: nil,
        fill: 'white',
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 120
      )

      File.binwrite(qrfile_name, png.to_s)
    end

    def self.generate_thumbnail(source_file, content_type_id_string)
      #      _vfile = '/usr2/teamdomain/spinvfs/root1'
      # サムネールの出力先
      # @target_path = '/usr/local/www/rails/thumbnail'
      target_path = '/usr2/teamdomain/spinvfs/root1_thumbnail'

      # サムネール作成の基準日時（差分の単位は秒）
      # @ago = Time.now - 60 * 60 * 24 * 19
      # サムネールの解像度
      w = 250.0
      h = 190.0
      r = 1.0 * w / h

      unless content_type_id_string =~ %r{video/}
        image = Magick::ImageList.new(source_file)
        ratio = 1.0 * image.columns / image.rows
        if ratio > r
          image.resize!(h * ratio, h)
        else
          image.resize!(w, w / ratio)
        end
        image.crop!(Magick::CenterGravity, w, h)
        #=> end of 'ratio' check

        fname = source_file.split('/')[-1]
        target = "#{target_path}/#{fname}.png"
        target_dir = File.dirname(target)
        FileUtils.mkdir_p(target_dir)
        image.write(target)
      end
      #=> end of '.m4v' check
      target
    end
  end
end
