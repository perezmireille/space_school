# frozen_string_literal: true

# Manejo el input del usuario. No es necesario entender por ahora que es lo que está pasando aquí ;)

module Utils
  # Check if Win32API is accessible or not
  @use_stty = begin
    require 'Win32API'
    false
  rescue LoadError
    # Use Unix way
    true
  end

  # Return the ASCII code last key pressed, or nil if none
  #
  # Return::
  # * _Integer_: ASCII code of the last key pressed, or nil if none
  def self.get_key
    return char if @use_stty
      system('stty raw -echo') # => Raw mode, no echo
      char = (STDIN.read_nonblock(1).ord rescue nil)
      system('stty -raw echo') # => Reset terminal mode
    else
      return Win32API.new('crtdll', '_kbhit', [], 'I').Call.zero? ? nil : Win32API.new('crtdll', '_getch', [], 'L').Call
    end
  end
end
