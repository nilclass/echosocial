class CAS::Hook
  class << self
    def register(name, &block)
      @handler ||= { }
      @handler[name.to_sym] = block
    end

    def call(name, *args)
      @handler[name.to_sym] ? @handler[name.to_sym].call(*args) : nil
    end
  end
end
