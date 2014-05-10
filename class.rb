class Class

  def estrategiaResolucion

    return EstrategiaStandard if @estrategiaResolucion.nil?

    @estrategiaResolucion
  end

  def estrategia estrategia
    @estrategiaResolucion = estrategia
  end

  def uses trait

    #consigo los metodos del trait  como hash {nombre=>bloqueMetodo}
    metodosDeTrait = trait.metodos

    #los metodos de la clase [symbol,..]
    metodosDeClase = self.methods()

    #define metodos con los nombres y los bloques del hash resultante si el metodo fue seleccionado
    metodosDeTrait.each do |nombreMetodo, cuerpoMetodo|
      define_method nombreMetodo,cuerpoMetodo
    end

  end

end