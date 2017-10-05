require 'socket'
require 'bindata'

module Socks5
  class PascalString < BinData::Record
    uint8 :len, value: -> { data.size }
    string :data, read_length: :len
  end

  # X'00' NO AUTHENTICATION REQUIRED
  # X'01' GSSAPI
  # X'02' USERNAME/PASSWORD
  # X'03' to X'7F' IANA ASSIGNED
  # X'80' to X'FE' RESERVED FOR PRIVATE METHODS
  # X'FF' NO ACCEPTABLE METHODS
  class SelectionRequest < BinData::Record
    uint8 :version, value: 5
    uint8 :n, value: 1
    uint8 :meth, value: 0
  end

  class SelectionResponse < BinData::Record
    uint8 :version
    uint8 :meth
  end

  # +----+-----+-------+------+----------+----------+
  # |VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
  # +----+-----+-------+------+----------+----------+
  # | 1  |  1  | X'00' |  1   | Variable |    2     |
  # +----+-----+-------+------+----------+----------+
  # Where:
  #  VER    protocol version: X'05'
  #  CMD
  #    CONNECT X'01'
  #    BIND X'02'
  #    UDP ASSOCIATE X'03'
  #  RSV    RESERVED
  #  ATYP   address type of following address
  #    IP V4 address: X'01'
  #    DOMAINNAME: X'03'
  #    IP V6 address: X'04'
  #  DST.ADDR    desired destination address
  #  DST.PORT    desired destination port in network octet order
  class Request < BinData::Record
    uint8 :version, value: 5
    uint8 :cmd, value: 1
    uint8 :rsv, value: 0
    uint8 :address_type, value: 3
    pascal_string :dst_address
    uint16be :dst_port
  end

  # +----+-----+-------+------+----------+----------+
  # |VER | REP |  RSV  | ATYP | BND.ADDR | BND.PORT |
  # +----+-----+-------+------+----------+----------+
  # | 1  |  1  | X'00' |  1   | Variable |    2     |
  # +----+-----+-------+------+----------+----------+
  # Where:
  # o  VER    protocol version: X'05'
  # o  REP    Reply field:
  #   o  X'00' succeeded
  #   o  X'01' general SOCKS server failure
  #   o  X'02' connection not allowed by ruleset
  #   o  X'03' Network unreachable
  #   o  X'04' Host unreachable
  #   o  X'05' Connection refused
  #   o  X'06' TTL expired
  #   o  X'07' Command not supported
  #   o  X'08' Address type not supported
  #   o  X'09' to X'FF' unassigned
  # o  RSV    RESERVED
  # o  ATYP   address type of following address
  #   o  IP V4 address: X'01'
  #   o  DOMAINNAME: X'03'
  #   o  IP V6 address: X'04'
  # o  BND.ADDR       server bound address
  # o  BND.PORT       server bound port in network octet order
  class Reply < BinData::Record
    uint8 :version
    uint8 :rep
    uint8 :rsv
    uint8 :address_type
    pascal_string :bnd_address
    uint16be :bnd_port
  end

  def self.foo
    s = TCPSocket.new('127.0.0.1', 1080)
    s.send(SelectionRequest.new.to_binary_s, 0)
    selection_resp = SelectionResponse.read(s)

    puts selection_resp

    req = Request.new
    req.dst_address.data = 'google.com'
    req.dst_port = 80

    s.send(req.to_binary_s, 0)
    reply_resp = Reply.read(s)

    puts reply_resp
  end
end
