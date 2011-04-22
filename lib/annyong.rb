module Annyong
  VERSION = '0.3'
  autoload :Directory, "annyong/directory"
  autoload :FileHandler, "annyong/file_handler"
  autoload :CSV, "annyong/csv"
  autoload :TSV, "annyong/tsv"
end

unless "".respond_to?(:each)
  String.class_eval do
    def each &block
      self.lines &block
    end
  end
end
