class Symbol

  #renombrar selector devuelve una array con los dos simbolos que puede aprovechar un trait
  def >> otroSymbol
    estructuraCopada = [self, otroSymbol]

    def estructuraCopada.nombreAnterior
      self.first
    end

    def estructuraCopada.nombreNuevo
      self.last
    end

    return estructuraCopada

  end

end