module Countdown
  # Used to parse time code strings
  class Counter

    # @param val [Interger|String|Hash] representing a length of time in HH:MM:SS or HH:SS
    # Sets the internal time store in seconds from input
    def initialize(val)
      self.seconds = val
    end

    # @return [Integer] the total number of seconds
    attr_reader :seconds

    # @param val [Integer|String|Hash]
    #   - seconds
    #   - a string representing a length of time in HH:MM:SS or HH:SS
    #   - a Hash or Hash like object with the keys :seconds and :minutes
    # @raise TypeError
    #   if val is not an acceptable parameter
    def seconds= val
      if val.is_a?(Integer)
        @seconds = val
      elsif val.is_a?(String)
        @seconds = from_string val
      elsif self.class.quacks_like_a_hash?(val) # quacks like a hash
        @seconds = from_hash(val)
      else
        raise TypeError, "input must be a String, Integer or Hash like object"
      end
    end

    # Checks the format of a string or hash like object
    # @param input [String|Hash]
    # @return [Boolean]
    def self.valid? input
      hash = input.is_a?(String) ?  HOURS_MINUTES_SECONDS_REGEXP.match(input) : input
      if hash && hash[:minutes] && hash[:seconds]
        if hash[:hours].to_i < 24 && hash[:minutes].to_i < 60 && hash[:seconds].to_i < 60
          return true
        end
      end
      false
    end

    # @param short_format [Boolean] prefer mm:ss output
    # @return [String]
    #   formated as a hh:mm:ss countdown
    def to_s(short_format: false)
      mm, ss = @seconds.divmod(60)
      hh, mm = mm.divmod(60)
      parts = short_format && hh.zero? ? [ mm, ss] : [hh, mm, ss]
      parts.map { |d| d.to_s.rjust(2, '0') }.join(':')
    end

    alias_method :to_i, :seconds

    # @return [Float] the total amount of time in minutes decimal
    def minutes
      to_i / 60.0
    end

    # @return [Float] the total amount of time in hours decimal
    def hours
      to_i / 3600.0
    end

    # @return [Hash]
    def to_h
      mm, ss = @seconds.divmod(60)
      hh, mm = mm.divmod(60)
      {
          hours: hh,
          minutes: mm,
          seconds: ss
      }
    end

    def self.quacks_like_a_hash? val
      val.respond_to?(:[]) && val[:seconds] || val[:minutes] || val[:hours]
    end


    private

    HOURS_MINUTES_SECONDS_REGEXP = /^((?<hours>([0-5]?[0-9]|60))?:)?(?<minutes>([0-5]?[0-9]|60)):(?<seconds>([0-5]?[0-9]|60))$/.freeze

    def from_string tcs
      matches = HOURS_MINUTES_SECONDS_REGEXP.match(tcs)
      unless Counter.valid?(matches)
        raise TypeError, "#{tcs} is not a valid time code string."
      end
      from_hash(matches)
    end

    def from_hash hash
      unless Counter.valid?(matches)
        raise TypeError, "#{hash} is not a valid time input"
      end
      (hash[:hours].to_i * 3600) + (hash[:minutes].to_i * 60) + hash[:seconds].to_i
    end
  end
end
