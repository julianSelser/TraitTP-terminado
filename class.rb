class Class

  def getEstrategia
    return EstrategiaDefault if @estrategia.nil?
    @estrategia
  end

  def estrategia unaEstrategia
    @estrategia = unaEstrategia
  end

  def uses trait
    metodosDeClase = self.methods()
    trait.sosUsadoPor self
    metodosAAgregar = trait.metodos.clone
    
    metodosAAgregar.each do |mensaje, metodo|
      metodoConEstrategia = metodo.resolveteCon(getEstrategia)
      
      define_method mensaje, metodoConEstrategia unless self.method_defined? mensaje 
    end
  end

  def actualizarMetodo mensaje, metodo
    define_method mensaje, metodo
  end

end
