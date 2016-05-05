module Sinatra
  module Contrib
    def self.version
      VERSION
    end

    SIGNATURE = [2, 0, 0].freeze
    VERSION   = SIGNATURE.join('.')

    VERSION.extend Comparable
    def VERSION.<=>(other)
      other = other.split('.').map(&:to_i) if other.respond_to? :split
      SIGNATURE <=> Array(other)
    end
  end
end
