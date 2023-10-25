# frozen_string_literal: true
require './read_string_excel'
require './string_file_crypt'
require './resolve_file_name_prefix'

def produce_strings
  file = 'live_strings.xlsx'
  reader = ReadStringExcel.new(file)
  reader.write_file 'bf_live'
  reader
end

# qwertyuiopasdfgh, asdfghjklzxcvbnm
def encrypt_strings(key = 'asjdlfjasdlkfaqw', iv = 'alsjflkasdjflkaq')
  reader = produce_strings

  ase_crypt = StringFileCrypt.new(key, iv, 'AES-128-CBC')

  files = reader.output_files 'bf_live'
  files.each do |file|
    ase_crypt.encrypt file
  end
end

def resolve_prefix(file_path, prefix, other_prefix)
  resolver = ResolveFileNamePrefix.new file_path
  resolver.resolve_prefix(prefix, other_prefix)
end

method = ARGV[0]

case method
when 'encrypt'
  key = ARGV[1]
  iv = ARGV[2]
  encrypt_strings key, iv
when 'resolve'
  path = ARGV[1]
  prefix = ARGV[2]
  other_prefix = ARGV[3]
  resolve_prefix path, prefix, other_prefix
else
  # type code here
end

