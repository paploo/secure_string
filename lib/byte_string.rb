require_relative 'secure_string'

# ByteString works exactly like SecureString, except that it forces the encoding
# to a binary byte encoding (ASCII-8BIT).
#
# Note that even if the byte values are the same, changing the encoding can
# cause comparisons to fail.
class ByteString < SecureString
  def initialize(mode = :data, value)
    super(mode, value)
    force_encoding("ASCII-8BIT")
  end
end