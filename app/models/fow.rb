class Fow
  attr_reader :glyph_data, :woff

  def initialize(io)
    @io = io
    @woff = WoffFile.read(@io)
  end

  def tags
    @woff.table_directory.map(&:tag)
  end

  def table_data(tag)
    entry = @woff.table_directory.find { |entry| entry.tag == tag }

    @io.pos = entry.offset

    if entry.comp_length == entry.orig_length
      @io.read(entry.comp_length)
    else
      compressed = @io.read(entry.comp_length)
      Zlib::Inflate.inflate(compressed)
    end
  end

  def cmap
    @cmap||= CmapTable.read(self.table_data('cmap'))
  end

  def map
    entries = []
    sub_table = self.cmap.format_four_sub_table
    sub_table.end_codes.each_with_index do |code, i|
      glyph_index = (code + sub_table.id_deltas[i]) % 65536
      entry = {
        code: code,
        glyph_index: glyph_index,
      }
      entries.push(entry)
    end
    entries
  end

  def maxp
    @maxp ||= MaxpTable.read(self.table_data('maxp'))
  end

  def loca
    @loca ||= LocaTable.read(self.table_data('loca'))
  end

  class Header < BinData::Record
    endian :big

    string :signature, read_length: 4, value: 'wOFF'
    uint32 :flavor
    uint32 :len
    uint16 :num_tables
    uint16 :reserved, value: 0
    uint32 :total_sfnt_size
    uint16 :major_version
    uint16 :minor_version
    uint32 :meta_offset
    uint32 :meta_length
    uint32 :meta_orig_length
    uint32 :priv_offset
    uint32 :priv_length
  end

  class TableDirectoryEntry < BinData::Record
    endian :big

    string :tag, read_length: 4
    uint32 :offset
    uint32 :comp_length
    uint32 :orig_length
    uint32 :orig_checksum
  end

  class WoffFile < BinData::Record
    header :header

    array :table_directory, type: :table_directory_entry, initial_length: -> { self.header.num_tables }
  end


  class CmapSubTable < BinData::Record
    endian :big

    uint16 :platform_id
    uint16 :platorm_specific_id
    uint32 :offset
  end

  class FormatFourSubTable < BinData::Record
    endian :big

    uint16 :format
    uint16 :len
    uint16 :language
    uint16 :seg_count
    uint16 :search_range
    uint16 :entry_selector
    uint16 :range_shift
    array :end_codes, type: :uint16, initial_length: -> { self.seg_count / 2 }
    uint16 :reserved_pad
    array :start_codes, type: :uint16, initial_length: -> { self.seg_count / 2 }
    array :id_deltas, type: :uint16, initial_length: -> { self.seg_count / 2 }
    array :id_range_offsets, type: :uint16, initial_length: -> { self.seg_count / 2 }
  end

  class CmapTable < BinData::Record
    endian :big

    uint16 :version
    uint16 :num
    array :sub_tables, type: :cmap_sub_table, initial_length: -> { self.number }
    format_four_sub_table :format_four_sub_table
  end

  class MaxpTable < BinData::Record
    endian :big

    uint32 :fixed, value: 0x00010000
    uint16 :num_glyphs
  end

  class LocaTable < BinData::Record
    endian :big

    array :offsets, type: :uint16, initial_length: 46
  end
end
