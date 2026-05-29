######################## BEGIN LICENSE BLOCK ########################
# The Original Code is mozilla.org code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 1998
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Jeff Hodges - port to Ruby
#   Mark Pilgrim - port to Python
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301  USA
######################### END LICENSE BLOCK #########################

module CharDet
  MIN_CHARS_FOR_DETECTION = 20
  EXPECTED_RATIO = 0.94

  class UTF1632Prober < CharSetProber
    def initialize
      super()
      @position = 0
      @zeros_at_mod = [0, 0, 0, 0]
      @nonzeros_at_mod = [0, 0, 0, 0]
      @state = EDetecting
      @quad = [0, 0, 0, 0]
      @invalid_utf16be = false
      @invalid_utf16le = false
      @invalid_utf32be = false
      @invalid_utf32le = false
      @first_half_surrogate_pair_detected_16be = false
      @first_half_surrogate_pair_detected_16le = false
      reset()
    end

    def reset
      super()
      @position = 0
      @zeros_at_mod = [0, 0, 0, 0]
      @nonzeros_at_mod = [0, 0, 0, 0]
      @state = EDetecting
      @invalid_utf16be = false
      @invalid_utf16le = false
      @invalid_utf32be = false
      @invalid_utf32le = false
      @first_half_surrogate_pair_detected_16be = false
      @first_half_surrogate_pair_detected_16le = false
      @quad = [0, 0, 0, 0]
    end

    def get_charset_name
      if is_likely_utf32be
        return "UTF-32BE"
      end
      if is_likely_utf32le
        return "UTF-32LE"
      end
      if is_likely_utf16be
        return "UTF-16BE"
      end
      if is_likely_utf16le
        return "UTF-16LE"
      end
      # default to something valid
      return "UTF-16"
    end

    def feed(aBuf)
      aBuf.each_byte do |b|
        mod4 = @position % 4
        @quad[mod4] = b
        if mod4 == 3
          validate_utf32_characters(@quad)
          validate_utf16_characters(@quad[0..2])
          validate_utf16_characters(@quad[2..4])
        end
        if b == 0
          @zeros_at_mod[mod4] += 1
        else
          @nonzeros_at_mod[mod4] += 1
        end
        @position += 1
      end

      return get_state()
    end

    def get_state
      if [ENotMe, EFoundIt].include? @state
        # terminal, decided states
        return @state
      end
      if get_confidence > 0.80
        @state = EFoundIt
      elsif @position > 4 * 1024
        # if we get to 4kb into the file, and we can't conclude it's UTF,
        # let's give up
        @state = ENotMe
      end
      return @state
    end

    def get_confidence
      if is_likely_utf16le || is_likely_utf16be || is_likely_utf32le || is_likely_utf32be
        0.85
      else
        0.00
      end
    end

    private

    def approx_32bit_chars
      return [1.0, @position / 4.0].max
    end

    def approx_16bit_chars
      return [1.0, @position / 2.0].max
    end

    def is_likely_utf32be
      approx_chars = approx_32bit_chars
      return approx_chars >= MIN_CHARS_FOR_DETECTION &&
             @zeros_at_mod[0] / approx_chars > EXPECTED_RATIO &&
             @zeros_at_mod[1] / approx_chars > EXPECTED_RATIO &&
             @zeros_at_mod[2] / approx_chars > EXPECTED_RATIO &&
             @nonzeros_at_mod[3] / approx_chars > EXPECTED_RATIO &&
             !@invalid_utf32be

    end

    def is_likely_utf32le
      approx_chars = approx_32bit_chars
      return approx_chars >= MIN_CHARS_FOR_DETECTION &&
             @nonzeros_at_mod[0] / approx_chars > EXPECTED_RATIO &&
             @zeros_at_mod[1] / approx_chars > EXPECTED_RATIO &&
             @zeros_at_mod[2] / approx_chars > EXPECTED_RATIO &&
             @zeros_at_mod[3] / approx_chars > EXPECTED_RATIO &&
             !@invalid_utf32le
    end

    def is_likely_utf16be
      approx_chars = approx_16bit_chars
      return approx_chars >= MIN_CHARS_FOR_DETECTION &&
             (@nonzeros_at_mod[1] + @nonzeros_at_mod[3]) / approx_chars > EXPECTED_RATIO &&
             (@zeros_at_mod[0] + @zeros_at_mod[2]) / approx_chars > EXPECTED_RATIO &&
             !@invalid_utf16be
    end

    def is_likely_utf16le
      approx_chars = approx_16bit_chars
      return approx_chars >= MIN_CHARS_FOR_DETECTION &&
             (@nonzeros_at_mod[0] + @nonzeros_at_mod[2]) / approx_chars > EXPECTED_RATIO &&
             (@zeros_at_mod[1] + @zeros_at_mod[3]) / approx_chars > EXPECTED_RATIO &&
             !@invalid_utf16le
    end

    # Validate if the quad of bytes is valid UTF-32.
    # UTF-32 is valid in the range 0x00000000 - 0x0010FFFF
    # excluding 0x0000D800 - 0x0000DFFF
    # https://en.wikipedia.org/wiki/UTF-32
    # @param [Array<Integer>] quad four consecutive bytes
    # @return [void]
    def validate_utf32_characters(quad)
      if quad[0] != 0 or quad[1] > 0x10 or quad[0] == 0 and quad[1] == 0 and (0xD8..0xDF).include?(quad[2])
        @invalid_utf32be = true
      end
      if quad[3] != 0 or quad[2] > 0x10 or quad[3] == 0 and quad[2] == 0 and (0xD8..0xDF).include?(quad[1])
        @invalid_utf32le = true
      end
    end

    # Validate if the pair of bytes is valid UTF-16.
    # UTF-16 is valid in the range 0x0000 - 0xFFFF excluding 0xD800 - 0xFFFF
    # with an exception for surrogate pairs, which must be in the range
    # 0xD800-0xDBFF followed by 0xDC00-0xDFFF
    # https://en.wikipedia.org/wiki/UTF-16
    # @param [Array<Integer>] pair two consecutive bytes
    # @return [void]
    def validate_utf16_characters(pair)
      if !@first_half_surrogate_pair_detected_16be
        if (0xD8..0xDB).include? pair[0]
          @first_half_surrogate_pair_detected_16be = true
        elsif (0xDC..0xDF).include? pair[0]
          @invalid_utf16be = true
        end
      else
        if (0xDC..0xDF).include? pair[0]
          @first_half_surrogate_pair_detected_16be = false
        else
          @invalid_utf16be = true
        end
      end

      if not @first_half_surrogate_pair_detected_16le
        if (0xD8..0xDB).include? pair[1]
          @first_half_surrogate_pair_detected_16le = true
        elsif (0xDC..0xDF).include? pair[1]
          @invalid_utf16le = true
        end
      else
        if (0xDC..0xDF).include? pair[1]
          @first_half_surrogate_pair_detected_16le = false
        else
          @invalid_utf16le = true
        end
      end
    end
  end
end