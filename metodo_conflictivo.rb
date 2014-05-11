class Metodo_conflictivo < Metodo_simple
  def initialize mensaje, bloquesConflictivos
    @mensaje=mensaje
    @bloque=bloquesConflictivos
    @bloqueFinal= proc {raise 'Hay metodos conflictivos entre traits' }
  end
end


