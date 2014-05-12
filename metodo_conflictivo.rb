class Metodo_conflictivo < Metodo_simple

  def initialize mensaje, unBloque, otroBloque
    self.mensaje=mensaje
    @bloques=[unBloque, otroBloque]
  end

  def resolveteCon estrategia
    self.bloqueFinal=estrategia.resolver(@bloques[0],@bloques[1])
  end

  def simplificate_con estrategia
    Metodo_simple.new self.mensaje,self.resolveteCon(estrategia)
  end

end


