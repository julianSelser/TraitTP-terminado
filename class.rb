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

    metodosAAgregar=self.estrategiaResolucion.resolver(trait.metodos)

    #define metodos con los nombres y los bloques del hash resultante si el metodo fue seleccionado
    metodosAAgregar.each do |mensaje, metodo|
      define_method mensaje,metodo.bloqueFinal
    end

  end

end