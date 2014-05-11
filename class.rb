class Class

  def estrategiaResolucion

    return EstrategiaDefault if @estrategiaResolucion.nil?

    @estrategiaResolucion
  end

  def estrategia estrategia
    @estrategiaResolucion = estrategia
  end

  def uses trait
    #los metodos de la clase [symbol,..]
    metodosDeClase = self.methods()

    metodosAAgregar=trait.metodos.clone
    metodosAAgregar.each {|mensaje,metodo|metodosAAgregar[mensaje]=metodo.resolveteCon(self.estrategiaResolucion)}

    #define metodos con los nombres y los bloques del hash resultante si el metodo fue seleccionado
    metodosAAgregar.each do |mensaje, metodo|
      define_method mensaje,metodo unless self.method_defined? mensaje
    end

  end

end