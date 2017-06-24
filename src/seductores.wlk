class Seducible {
	var pareja // any
	const generosPreferidos = [] // "List[any]"
	var nivelIntelectualMinimoBuscado = 0 
	 
	var personalidad = libre  // cazafortunas | militante | envidioso | libre" at "personalidad"
	var rival // Seducible
	
	// Seductor => Boolean
	method aceptaCitaDe(seductor) = (pareja == null && self.esCompatible(seductor) || pareja == seductor)
	
	// Seductor => Boolean
	method esCompatible(seductor) = (generosPreferidos.size() === 0 || generosPreferidos.contains(seductor.getGenero())) 
		&& personalidad.acepta(self, seductor)
	
	// any => void
	method setPareja(p) { pareja = p }
	// () => any
	method getPareja() = pareja
	// any => void 
	method agregarGeneroPreferido(g) { generosPreferidos.add(g) }
	
	// () => Number 
	method getNivelIntelectualMinimoBuscado() = nivelIntelectualMinimoBuscado
	// number => void
	method setNivelIntelectualMinimoBuscado(n) { nivelIntelectualMinimoBuscado = n }
	
	// () => cazafortunas | militante | envidioso | libre
	method getPersonalidad() = personalidad
	// cazafortunas | militante | envidioso | libre => void
	method setPersonalidad(p) { personalidad = p }
	
	// Seducible => void
	method setRival(r) { rival = r }
	// () => Seducible
	method getRival() = rival
}

object millonarios {
	// Number
	var nivelMinimo = 1000
	// () => number
	method getNivelMinimo() = nivelMinimo
	// Number => void
	method setNivelMinimo(m) { nivelMinimo = m }
}

class Seductor {
	// any ? generoMasculino | generoFemenino
	var genero
	// Number
	var nivelEconomicoBase = 0
	// Number
	var nivelIntelectualBase = 0
	// Number
	var aspectoPersonalBase = 0
	// List[
	//	Artilugio    << PREFERIBLE (?)
	//  | { 
	//       modificarNivelIntelectual(Seductor, Number),
	//       modificarNivelEconomico(Seductor, Number),
	//       modificarAspectoPersonal(Seductor, Number)
	//    }
	// ]
	var artilugios = []
	constructor() = self(0, 0, 0)
	// (Number, Number, Number)
	constructor(nEconomicoBase, nIntelectualBase, nPersonalBase) {
		nivelEconomicoBase = nEconomicoBase
		nivelIntelectualBase = nIntelectualBase
		aspectoPersonalBase = nPersonalBase
	}
	
	// () => Boolean
	method esMillonario() = self.getNivelEconomico() > millonarios.getNivelMinimo()
	
	// () => any ? generoMasculino | generoFemenino
	method getGenero() = genero
	// (any ? generoMasculino | generoFemenino) => void
	method setGenero(g) { genero = g }
	
	// void => Number
	method getNivelIntelectual() = nivelIntelectualBase + artilugios.sum { artilugio => 
		artilugio.modificarNivelIntelectual(self, nivelIntelectualBase)
	}
	// void => Number
	method getNivelEconomico() = nivelEconomicoBase + artilugios.sum { 
		artilugio => artilugio.modificarNivelEconomico(self, nivelEconomicoBase)
	}
	// void => Number
	method getAspectoPersonal() = aspectoPersonalBase + artilugios.sum { artilugio => 
		artilugio.modificarAspectoPersonal(self, aspectoPersonalBase)
	}

	// Artilugio => void
	method artilugio(a) { artilugios.add(a) }
}

// ******************
// ** generos
// ******************

object generoMasculino {}
object generoFemenino {}

// ******************
// ** personalidades
// ******************

object cazafortunas {
	// (any, Seductor) => Boolean
	method acepta(seducible, seductor) = seductor.esMillonario()
}

object militante {
	// (Seducible, Seductor) => Boolean
	method acepta(seducible, seductor) = 
		seductor.getNivelIntelectual() >= seducible.getNivelIntelectualMinimoBuscado() 
		&& (seductor.esMillonario() || seductor.getAspectoPersonal() > seductor.getNivelIntelectual() / 2)
}

object envidioso {
	// (Seducible, Seductor) => Boolean
	method acepta(seducible, seductor) = seducible.getRival().aceptaCitaDe(seductor)
}

object libre {
	// (any, any) => Boolean
	method acepta(seducible, seductor) = true
}

// ******************
// ** artilugios
// ******************

class Artilugio {
	// (any, any) => Number
	method modificarNivelIntelectual(seductor, nivel) = 0
	// (any, any) => Number
	method modificarNivelEconomico(seductor, nivel) = 0
	// (any, any) => Number
	method modificarAspectoPersonal(seductor, nivel) = 0
}

class Billetera inherits Artilugio {
	// Number (from usage in overriden method)
	var cantidad;
	
	constructor(cantidadInicial) {
		cantidad = cantidadInicial
	}
	// (any, any) => Number
	override method modificarNivelEconomico(seductor, nivel) = cantidad
	// (any, Number) => Number
	override method modificarAspectoPersonal(seductor, nivel) = nivel * 0.10
	// (Seductor, Number) => Number
	override method modificarNivelIntelectual(seductor, nivel) = if (seductor.esMillonario()) nivel * -0.2 else 0  
}

class Auto inherits Artilugio {
	var precio
	constructor(_precio) { precio = _precio }
	override method modificarNivelEconomico(seductor, nivel) = -precio * 0.10
	override method modificarAspectoPersonal(seductor, nivel) = 2 * precio
}

class Reputacion inherits Artilugio {
	const intelectual
	const economica
	const personal
	constructor(i, e, p) {
		intelectual = i
		economica = e
		personal = p
	}
	override method modificarNivelEconomico(seductor, nivel) = economica
	override method modificarNivelIntelectual(seductor, nivel) = intelectual
	override method modificarAspectoPersonal(seductor, nivel) = personal
}

object titulo inherits Artilugio {
	override method modificarNivelEconomico(seductor, nivel) = nivel * 0.8
	override method modificarNivelIntelectual(seductor, nivel) = nivel * 1.00
}

