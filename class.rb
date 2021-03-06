class Class

  def getEstrategia
    return EstrategiaDefault if @estrategia.nil?
    @estrategia
  end

  def estrategia unaEstrategia
    @estrategia = unaEstrategia
  end

  def uses trait
    #los metodos de la clase [symbol,..]
    metodosDeClase = self.methods()
    trait.sosUsadoPor self

    metodosAAgregar=trait.metodos.clone
    metodosAAgregar.each {|mensaje,metodo|metodosAAgregar[mensaje]=metodo.resolveteCon(getEstrategia)}

    #define metodos con los nombres y los bloques del hash resultante si el metodo fue seleccionado
    metodosAAgregar.each do |mensaje, metodo|
      define_method mensaje,metodo unless self.method_defined? mensaje
    end
  end

  def actualizarMetodo mensaje,metodo
    define_method mensaje,metodo
  end

end