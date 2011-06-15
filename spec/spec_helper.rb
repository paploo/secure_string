# Add the lib dir to the load path.
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
# Require the main require file.
require File.basename(File.expand_path(File.join(File.dirname(__FILE__),'..')))

MESSAGES = [
  {
    :string => "Hello",
    :hex => "48656c6c6f",
    :int => 310939249775,
    :base64 => "SGVsbG8=", # Leave off the \n on purpose so that we can make sure it handles that case appropriately when instantiating using base64.
    :urlsafe_base64 => "SGVsbG8="
  },
  
  {
    :string => "This is a test of the emergency broadcast system; this is only a test.",
    :hex => "5468697320697320612074657374206f662074686520656d657267656e63792062726f6164636173742073797374656d3b2074686973206973206f6e6c79206120746573742e",
    :int => 1244344095146357680190496293767338268850834164562379171846588371816488740307922111470765515885864931093899586331709567338989540039042962957732585272476408412061178229806,
    :base64 => "VGhpcyBpcyBhIHRlc3Qgb2YgdGhlIGVtZXJnZW5jeSBicm9hZGNhc3Qgc3lz\ndGVtOyB0aGlzIGlzIG9ubHkgYSB0ZXN0Lg==\n",
    :urlsafe_base64 => "VGhpcyBpcyBhIHRlc3Qgb2YgdGhlIGVtZXJnZW5jeSBicm9hZGNhc3Qgc3lzdGVtOyB0aGlzIGlzIG9ubHkgYSB0ZXN0Lg=="
  },
  
  # This one tests a special case where url safe encodes differently than the standard.
  {
    :string => "HI?",
    :hex => "48493f",
    :int => 4737343,
    :base64 => "SEk/\n",
    :urlsafe_base64 => "SEk_"
  }
].freeze