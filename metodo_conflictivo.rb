class Metodo_conflictivo < Metodo_simple
  def initialize mensaje, unBloque, otroBloque
    @mensaje=mensaje
    @bloques=[unBloque, otroBloque]
  end
  def resolveteCon estrategia
    self.bloqueFinal=estrategia.resolver(@bloques[0],@bloques[1])
    self.bloqueFinal
  end
end


