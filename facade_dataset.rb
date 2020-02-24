require "zip"
require "dnn/image"

module DNN
  module Facade
    FACADE_URL = "http://cmp.felk.cvut.cz/~tylecr1/facade/"
    BASE_DIR_NAME = "CMP_facade_DB_base"
    EXTENDED_DIR_NAME = "CMP_facade_DB_extended"
    BASE_PATH = "#{DOWNLOADS_PATH}/downloads/#{BASE_DIR_NAME}"
    EXTENDED_PATH = "#{DOWNLOADS_PATH}/downloads/#{EXTENDED_DIR_NAME}"

    def self.downloads
      unless Dir.exist?(BASE_PATH) 
        zip_file_name = "#{BASE_DIR_NAME}.zip"
        Downloader.download("#{FACADE_URL}/#{zip_file_name}")
        zip_decompression(BASE_PATH)
        File.unlink("#{DOWNLOADS_PATH}/downloads/#{zip_file_name}")
      end
      unless Dir.exist?(EXTENDED_PATH)
        zip_file_name = "#{EXTENDED_DIR_NAME}.zip"
        Downloader.download("#{FACADE_URL}/#{zip_file_name}")
        zip_decompression(EXTENDED_PATH)
        File.unlink("#{DOWNLOADS_PATH}/downloads/#{zip_file_name}")
      end
    end

    def self.zip_decompression(zip_path)
      Zip::File.open("#{zip_path}.zip") do |zip|
        zip.each do |entry|
          zip.extract(entry, "#{zip_path}/#{entry.name}") { true }
        end
      end
    end

    def self.load_images(dir_path)
      downloads
      in_imgs = []
      out_imgs = []
      Dir["#{dir_path}/*.png"].each do |fpath|
        img = DNN::Image.read(fpath)
        img = DNN::Image.resize(img, 64, 64)
        in_imgs << img
      end
      Dir["#{dir_path}/*.jpg"].each do |fpath|
        img = DNN::Image.read(fpath)
        img = DNN::Image.resize(img, 64, 64)
        out_imgs << img
      end
      [in_imgs, out_imgs]
    end

    def self.load_train
      load_images("#{BASE_PATH}/base")
    end

    def self.load_test
      load_images("#{EXTENDED_PATH}/extended")
    end
  end
end
