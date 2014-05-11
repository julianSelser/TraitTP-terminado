class Class

  def laEstrategiaDeResolucionEs unaEstrategia
    @estrategiaResolucion =unaEstrategia
  end

  def estrategia
    return EstrategiaDefault if @estrategiaResolucion.nil?
    @estrategiaResolucion
  end

  def uses trait
    #los metodos de la clase [symbol,..]
    metodosDeClase = self.methods()

    metodosAAgregar=trait.metodos.clone
    metodosAAgregar.each {|mensaje,metodo|metodosAAgregar[mensaje]=metodo.resolveteCon(self.estrategia)}

    #define metodos con los nombres y los bloques del hash resultante si el metodo fue seleccionado
    metodosAAgregar.each do |mensaje, metodo|
      define_method mensaje,metodo unless self.method_defined? mensaje
    end

  end

end