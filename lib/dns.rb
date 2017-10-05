# https://www.ietf.org/rfc/rfc1034.txt
# https://www.ietf.org/rfc/rfc1035.txt

# 3.2.2. TYPE values
#
# TYPE fields are used in resource records.  Note that these types are a
# subset of QTYPEs.
#
# TYPE            value and meaning
#
# A               1 a host address
#
# NS              2 an authoritative name server
#
# MD              3 a mail destination (Obsolete - use MX)
#
# MF              4 a mail forwarder (Obsolete - use MX)
#
# CNAME           5 the canonical name for an alias
#
# SOA             6 marks the start of a zone of authority
#
# MB              7 a mailbox domain name (EXPERIMENTAL)
#
# MG              8 a mail group member (EXPERIMENTAL)
#
# MR              9 a mail rename domain name (EXPERIMENTAL)
#
# NULL            10 a null RR (EXPERIMENTAL)
#
# WKS             11 a well known service description
#
# PTR             12 a domain name pointer
#
# HINFO           13 host information
#
# MINFO           14 mailbox or mail list information
#
# MX              15 mail exchange
#
# TXT             16 text strings
#
# 3.2.3. QTYPE values
#
# QTYPE fields appear in the question part of a query.  QTYPES are a
# superset of TYPEs, hence all TYPEs are valid QTYPEs.  In addition, the
# following QTYPEs are defined:
#
# AXFR            252 A request for a transfer of an entire zone
#
# MAILB           253 A request for mailbox-related records (MB, MG or MR)
#
# MAILA           254 A request for mail agent RRs (Obsolete - see MX)
#
# *               255 A request for all records
#
# 3.2.4. CLASS values
#
# CLASS fields appear in resource records.  The following CLASS mnemonics
# and values are defined:
#
# IN              1 the Internet
#
# CS              2 the CSNET class (Obsolete - used only for examples in
# some obsolete RFCs)
#
# CH              3 the CHAOS class
#
# HS              4 Hesiod [Dyer 87]
#
# 3.2.5. QCLASS values
#
# QCLASS fields appear in the question section of a query.  QCLASS values
# are a superset of CLASS values; every CLASS is a valid QCLASS.  In
# addition to CLASS values, the following QCLASSes are defined:
#
# *               255 any class

class Dns
  # types
  A = 1
  NS = 2
  CNAME = 5
  MX = 15
  ANY = 255
  # classes
  IN = 1


  def self.to_type(num)
    case num
    when A; 'A'
    when NS; 'NS'
    when CNAME; 'CNAME'
    when MX; 'MX'
    else
      num.to_s
    end
  end

  class PascalString < BinData::Record
    uint8 :len, value: -> { data.size }
    string :data, read_length: :len
  end

  class DomainName < BinData::Record
    bit2 :mark
    bit14 :offset
    stringz :name, onlyif: :not_compressed?

    def domain_name
      Dns.read_domain_name(self.send(:top_level).to_binary_s, self.abs_offset)
    end

    def not_compressed?
      self.mark != 3
    end
  end

  class Header < BinData::Record
    endian :big

    uint16 :id

    bit1 :qr # query: 0, response: 1
    bit4 :opcode # QUERY: 0, IQUERY: 1, STATUS: 2
    bit1 :aa # Authoritative Answer
    bit1 :tc # Truncation
    # Recursion Desired - this bit may be set in a query and
    # is copied into the response.  If RD is set, it directs
    # the name server to pursue the query recursively.
    # Recursive query support is optional.
    bit1 :rd # Recursion Desired
    bit1 :ra # Recursion Available
    bit3 :z, value: 0 # reserved
    bit4 :rcode # no_error: 0, format_error: 1, server_failure: 2, name_error: 3, not_implemented: 4, refused: 5

    uint16 :qdcount
    uint16 :ancount
    uint16 :nscount
    uint16 :arcount
  end

  class Question < BinData::Record
    endian :big

    stringz :qname
    uint16 :qtype
    uint16 :qclass

    def self.from_domain(domain)
      q = self.new
      q.domain = domain
      q.qtype = A
      q.qclass = IN
      q
    end

    def domain=(domain)
      labels = domain.split('.').map do |label|
        size = [label.size].pack('C')
        size + label
      end.join

      self.qname = labels
    end

    def domain
      labels = []
      io = StringIO.new(self.qname)

      while !io.eof?
        s = PascalString.read(io)
        labels.push(s.data) if s.data.size > 0
      end

      labels.join('.')
    end
  end

  class ResourceRecord < BinData::Record
    endian :big

    domain_name :name
    uint16 :rtype
    uint16 :rclass
    uint32 :ttl
    uint16 :rdlength#, value: -> { rdata.size }
    string :rdata, read_length: :rdlength

    def address
      if self.rtype == A && self.rdlength == 4
        self.rdata.each_byte.to_a.join('.')
      end
    end

    def domain
      if self.rtype == NS
        Dns.read_domain_name(self.send(:top_level).to_binary_s, self.rdata.abs_offset)
      end
    end
  end

  class RequestMessage < BinData::Record
    header :header
    question :question
  end

  class ResponseMessage < BinData::Record
    header :header
    question :question, if: -> { self.header.qdcount == 1 }

    array :resource_records, type: :resource_record, initial_length: :records_count

    def answer_records
      self.resource_records.slice(0, self.header.ancount)
    end

    def authority_records
      self.resource_records[self.header.ancount...(self.header.ancount + self.header.nscount)]
      self.resource_records.slice(self.header.ancount, self.header.nscount)
    end

    def additional_records
      self.resource_records.slice(self.header.ancount + self.header.nscount, self.header.arcount)
    end

    def records_count
      self.header.ancount + self.header.nscount + self.header.arcount
    end
  end

  # @return [String]
  def self.read_domain_name(bytes, offset)
    io = StringIO.new(bytes)
    io.pos = offset

    labels = []

    while (label_size = io.readbyte) != 0
      if label_size >> 6 == 3
        io.ungetbyte(label_size)

        new_offset = DomainName.read(io).offset
        io.pos = new_offset
      else
        labels.push(io.read(label_size))
      end
    end

    labels.join('.')
  end

  def self.question(domain, dest = '8.8.8.8')
    msg = RequestMessage.new
    msg.header.id = Random.rand(1..65535)
    msg.header.rd = 1 # 设置为 1 启用服务端的递归查询，只需一次请求即可返回地址
    msg.header.qdcount = 1
    msg.question = Question.from_domain(domain)
    request = msg.to_binary_s


    puts msg
    puts request.inspect

    u = UDPSocket.new
    u.send(request, 0, dest, 53)
    resp = u.recv(1000)
    puts resp.inspect
    puts resp.size

    response = ResponseMessage.read(resp)

    answer_records = response.answer_records.map do |record|
      {
        type: to_type(record.rtype),
        name: record.name.domain_name,
        address: record.address,
      }
    end

    authority_records = response.authority_records.map do |record|
      {
        type: to_type(record.rtype),
        name: record.name.domain_name,
        domain: record.domain,
      }
    end

    additional_records = response.additional_records.map do |record|
      {
        type: to_type(record.rtype),
        name: record.name.domain_name,
        address: record.address,
        domain: record.domain,
      }
    end

    {
      answer_records_count: answer_records.size,
      authority_records_count: authority_records.size,
      additional_records_count: additional_records.size,
      answer_records: answer_records,
      authority_records: authority_records,
      additional_records: additional_records,
      inspect: response.inspect,
    }
  end
end
