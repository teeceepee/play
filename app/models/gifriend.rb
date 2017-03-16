require 'bindata'

module Gifriend

  # primary blocks

  class DataSubBlock < BinData::Record
    uint8 :block_size
    string :data_values, length: :block_size, onlyif: :has_value?

    def has_value?
      self.block_size > 0
    end
  end

  class DataSubBlocks < BinData::Record
    array :sub_blocks, type: :data_sub_block, read_until: -> { element.block_size == 0 }
  end

  class Header < BinData::Record
    string :signature, length: 3
    string :version, length: 3
  end

  class LogicalScreenDescriptor < BinData::Record
    uint16le :logical_screen_width
    uint16le :logical_screen_height

    # packed fields
    bit1 :global_color_table_flag
    bit3 :color_resolution
    bit1 :sort_flag
    bit3 :size_of_global_color_table

    uint8 :background_color_index
    uint8 :pixel_aspect_ratio

    def color_count
      2 ** (self.size_of_global_color_table + 1)
    end

    def table_size
      3 * self.color_count
    end
  end

  class Color < BinData::Record
    uint8 :red
    uint8 :green
    uint8 :blue

    def to_gray!
      gray = (self.red + self.green + self.blue) / 3
      self.red = gray
      self.green = gray
      self.blue = gray
    end
  end

  class ImageDescriptor < BinData::Record
    uint16le :left_position
    uint16le :top_position
    uint16le :width
    uint16le :height

    bit1 :local_color_table_flag
    bit1 :interlace_flag
    bit1 :sort_flag
    bit2 :reserved
    bit3 :size_of_local_color_table

    def color_count
      2 ** (self.size_of_local_color_table + 1)
    end

    def table_size
      3 * self.color_count
    end
  end

  class ImageData < BinData::Record
    uint8 :lzw_minimum_code_size
    data_sub_blocks :image_data
  end

  class Trailer < BinData::Record

  end


  # extensions

  # 0x21 '!' 0xFF
  class ApplicationExtension < BinData::Record
    uint8 :block_size
    string :application_identifier, length: 8
    string :application_authentication_code, length: 3
    data_sub_blocks :application_data_and_block_terminator
  end

  # 0x21 '!' 0xFE
  class CommentExtension < BinData::Record
    data_sub_blocks :comment_data_and_block_terminator
  end

  # 0x21 '!' 0xF9
  class GraphicControlExtension < BinData::Record
    uint8 :block_size

    bit3 :reserved
    bit3 :disposal_method
    bit1 :user_input_flag
    bit1 :transparent_color_flag

    uint16le :delay_time
    uint8 :transparent_color_index
    uint8 :block_terminator
  end

  # 0x21 '!'
  class PlainTextExtension < BinData::Record
    # TODO
  end

  # compound blocks

  # 0x2C ','
  class TableBasedImage < BinData::Record
    image_descriptor :image_descriptor
    array :local_color_table, {
      type: :color,
      read_until: -> { index + 1 == self.image_descriptor.color_count },
      onlyif: :has_lct?,
    }
    image_data :image_data

    def has_lct?
      self.image_descriptor.local_color_table_flag == 1
    end
  end


  # wrapper

  class GraphicRenderingBlockInner < BinData::Choice
    table_based_image 0x2C
    plain_text_extension 0x21
  end


  class GraphicRenderingBlock < BinData::Record
    uint8 :separator
    graphic_rendering_block_inner :inner, selection: :separator
  end

  class GraphicBlock < BinData::Record
    graphic_control_extension :graphic_control_extension
    graphic_rendering_block :graphic_rendering_block
  end

  class ExtensionInner < BinData::Choice
    application_extension 0xFF
    comment_extension 0xFE
    graphic_block 0xF9
  end

  class Extension < BinData::Record
    uint8 :label
    extension_inner :inner, selection: :label
  end

  class DataBlockInner < BinData::Choice
    table_based_image 0x2C
    extension 0x21
    trailer 0x3B
  end

  class DataWrapper < BinData::Record
    uint8 :separator
    data_block_inner :inner, selection: :separator

    def graphic?
      self.separator == 0x21 && self.inner.label == 0xF9 # self.separator == 0x2C
    end
  end


  class Gif < BinData::Record
    header :header
    logical_screen_descriptor :logical_screen_descriptor
    array :global_color_table, {
      type: :color,
      read_until: -> { index + 1 == self.logical_screen_descriptor.color_count },
      onlyif: :has_gct?,
    }

    array :data_list, type: :data_wrapper, read_until: :eof

    def images
      r = []
      self.data_list.each do |b|
        if b.separator == 0x21 && b.inner.label == 0xF9 && b.inner.inner.graphic_rendering_block.separator == 0x2C
          r.push b.inner.inner.graphic_rendering_block.inner
        end
      end

      r
    end


    def has_gct?
      self.logical_screen_descriptor.global_color_table_flag == 1
    end
  end

  def self.foo
    f = File.new(Rails.root.join('app/assets/images/test.gif'))
    Gif.read(f)
  end


  def self.gray
    f = File.new(Rails.root.join('app/assets/images/test.gif'))
    g = Gif.read(f)

    if g.has_gct?
      gct = g.global_color_table
      gct.each do |color|
        color.to_gray!
      end
    end

    g.images.each do |image|
      if image.has_lct?
        image.local_color_table.each do |color|
          color.to_gray!
        end
      end
    end

    File.open('gray.gif', 'wb') do |f|
      f.write(g.to_binary_s)
    end
  end
end
