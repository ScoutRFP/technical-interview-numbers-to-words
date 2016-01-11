class BatchProcessor
  attr_accessor :processed_items

  def initialize
    reset
  end

  def identify(key)
    @key = key
  end

  # def reset
  #   @key = nil
  #   @processed_items = []
  # end

  # def should_process(&block)
  #   @should_process = block
  # end

  def process_items(items)
    items.each do |item|
      if process?(item)
        yield item if block_given?
        @processed_items << item
      end
    end
  end

  private

  def process?(item)
    # return false unless @should_process.call(item)

    if @key
      test = if item.is_a?(Hash)
        Proc.new {|i| i[@key] == item[@key] }
      else
        Proc.new {|i| i.send(@key) == item.send(@key) }
      end

       @processed_items.none?(&test)
    else
      !@processed_items.include?(item)
    end
  end
end
