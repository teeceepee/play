require 'bindata'

# https://www.w3.org/Graphics/GIF/spec-gif89a.txt
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

    def to_metadata
      {
        application_identifier: self.application_identifier.to_s,
        application_authentication_code: self.application_authentication_code.to_s,
      }
    end
  end

  # 0x21 '!' 0xFE
  class CommentExtension < BinData::Record
    data_sub_blocks :comment_data_and_block_terminator

    def to_metadata
      comment = self.comment_data_and_block_terminator.sub_blocks.first.data_values.to_s
      {
        comment: comment
      }
    end
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

    def to_metadata
      {
        disposal_method: self.disposal_method_text,
        user_input_flag: self.user_input_flag.to_i,
        delay_time: self.delay_time.to_i,
        transparent_color_index: self.transparent_color_index.to_i,
      }
    end

    def disposal_method_text
      DISPOSAL_METHODS[self.disposal_method.to_i]
    end

    DISPOSAL_METHODS = {
      0 => 'No disposal specified',
      1 => 'Do not dispose',
      2 => 'Restore to background color',
      3 => 'Restore to previous',
    }
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
      self.separator == 0x21 && self.inner.label == 0xF9
    end

    def image?
      self.graphic? && self.inner.inner.graphic_rendering_block.separator == 0x2C
    end

    def application?
      self.separator == 0x21 && self.inner.label == 0xFF
    end

    def comment?
      self.separator == 0x21 && self.inner.label == 0xFE
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

    def metadata
      {
        header: {
          signature: self.header.signature.to_s,
          version: self.header.version.to_s,
        },
        logical_screen_descriptor: {
          logical_screen_width: self.logical_screen_descriptor.logical_screen_width.to_i,
          logical_screen_height: self.logical_screen_descriptor.logical_screen_height.to_i,
        },
        has_gct: self.has_gct?,
        block_count: self.data_list.size,
        image_count: self.image_indicies.size,
        applications: self.applications.map(&:to_metadata),
        comments: self.comments.map(&:to_metadata),
        graphic_controls: self.graphic_controls.map(&:to_metadata),
      }
    end

    def graphic_controls
      self.data_list.select { |b| b.image? }.map { |b| b.inner.inner.graphic_control_extension }
    end

    # @return Array<Gifriend::GraphicRenderingBlockInner>
    def images
      self.data_list.select { |b| b.image? }.map { |b| b.inner.inner.graphic_rendering_block.inner }
    end

    def image_indicies
      indicies = []
      self.data_list.each_with_index do |b, i|
        if b.image?
          indicies.push(i)
        end
      end

      indicies
    end

    def applications
      self.data_list.select { |b| b.application? }.map { |b| b.inner.inner }
    end

    def comments
      self.data_list.select { |b| b.comment? }.map { |b| b.inner.inner }
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

    FileUtils.mkdir_p('tmp/gif')
    File.open('tmp/gif/gray.gif', 'wb') do |f|
      f.write(g.to_binary_s)
    end
  end


  def self.sub_frames
    f = File.new(Rails.root.join('app/assets/images/test.gif'))
    g = Gifriend::Gif.read(f); nil
    original_list = g.data_list.clone

    FileUtils.mkdir_p('tmp/gif')
    g.image_indicies.each do |index|
      File.open("tmp/gif/#{index}.gif", 'wb') do |f|
        g.data_list = [original_list[index], original_list.last]
        f.write(g.to_binary_s)
      end
    end
  end

  def self.change_speed(factor = 2.0)
    f = File.new(Rails.root.join('app/assets/images/test.gif'))
    g = Gifriend::Gif.read(f); nil

    g.graphic_controls.each do |graphic_control|
      time = (graphic_control.delay_time / factor.to_f).floor
      new_time = time > 0 ? time : 2 # TODO, why zero and one don't work
      graphic_control.delay_time = new_time
    end

    FileUtils.mkdir_p('tmp/gif')
    File.open('tmp/gif/speed.gif', 'wb') do |f|
      f.write(g.to_binary_s)
    end
  end
end
