module Goldencobra
  class Context < Radius::Context    
    
    Parser = []
    
    def initialize()
       super()  
       Parser.each do |parse_method| 
         self.send(parse_method)
       end  
     end    
    
  end
end