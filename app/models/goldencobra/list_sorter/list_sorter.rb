module Goldencobra
  module ListSorter
    class BasicSorter
      include Enumerable

      def initialize(list)
        @list = list
      end

      def each(&block)
        @list.each(&block)
      end
    end

    class Alphabetical < BasicSorter
      def initialize(list)
        @list = list.flatten.sort_by{ |article| article.title }.to_a
      end
    end

    class CreatedAt < BasicSorter
      def initialize(list)
        @list = list.flatten.sort_by{ |article| article.created_at.to_i}.to_a
      end
    end

    class Random < BasicSorter
      def initialize(list)
        @list = list.flatten.shuffle
      end
    end
  end
end
