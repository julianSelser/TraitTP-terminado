class Metodo_simple
  attr_accessor :mensaje, :bloqueFinal
  def initialize  mensaje, bloque
    @mensaje = mensaje
    @bloqueFinal=bloque
  end

  def resolveteCon estrategia
    self.bloqueFinal
  end

  def simplificate_con estrategia
    self
  end
end