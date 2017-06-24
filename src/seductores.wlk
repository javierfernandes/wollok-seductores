class Seducible {
	var pareja
	const generosPreferidos = []
	var nivelIntelectualMinimoBuscado = 0
	var personalidad = libre
	var rival
	
	method aceptaCitaDe(seductor) = (pareja == null && self.esCompatible(seductor) || pareja == seductor)
	
	method esCompatible(seductor) = (generosPreferidos.size() === 0 || generosPreferidos.contains(seductor.getGenero())) 
		&& personalidad.acepta(self, seductor)
	
	method setPareja(p) { pareja = p }
	method getPareja() = pareja 
	method agregarGeneroPreferido(g) { generosPreferidos.add(g) }
	
	method getNivelIntelectualMinimoBuscado() = nivelIntelectualMinimoBuscado
	method setNivelIntelectualMinimoBuscado(n) { nivelIntelectualMinimoBuscado = n }
	
	method getPersonalidad() = personalidad
	method setPersonalidad(p) { personalidad = p }
	
	method setRival(r) { rival = r }
	method getRival() = rival
}

object millonarios {
	var nivelMinimo = 1000
	method getNivelMinimo() = nivelMinimo
	method setNivelMinimo(m) { nivelMinimo = m }
}

class Seductor {
	var genero
	var nivelEconomicoBase = 0
	var nivelIntelectualBase = 0
	var aspectoPersonalBase = 0
	var artilugios = []
	constructor() = self(0, 0, 0)
	constructor(nEconomicoBase, nIntelectualBase, nPersonalBase) {
		nivelEconomicoBase = nEconomicoBase
		nivelIntelectualBase = nIntelectualBase
		aspectoPersonalBase = nPersonalBase
	}
	
	method esMillonario() = self.getNivelEconomico() > millonarios.getNivelMinimo()
	
	method getGenero() = genero
	method setGenero(g) { genero = g }
	
	method getNivelIntelectual() = nivelIntelectualBase + artilugios.sum { artilugio => 
		artilugio.modificarNivelIntelectual(self, nivelIntelectualBase)
	}
	method getNivelEconomico() = nivelEconomicoBase + artilugios.sum { 
		artilugio => artilugio.modificarNivelEconomico(self, nivelEconomicoBase)
	}
	method getAspectoPersonal() = aspectoPersonalBase + artilugios.sum { artilugio => 
		artilugio.modificarAspectoPersonal(self, aspectoPersonalBase)
	}

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
	method acepta(seducible, seductor) = seductor.esMillonario()
}

object militante {
	method acepta(seducible, seductor) = 
		seductor.getNivelIntelectual() >= seducible.getNivelIntelectualMinimoBuscado() 
		&& (seductor.esMillonario() || seductor.getAspectoPersonal() > seductor.getNivelIntelectual() / 2)
}

object envidioso {
	method acepta(seducible, seductor) = seducible.getRival().aceptaCitaDe(seductor)
}

object libre {
	method acepta(seducible, seductor) = true
}

// ******************
// ** artilugios
// ******************

class Artilugio {
	method modificarNivelIntelectual(seductor, nivel) = 0
	method modificarNivelEconomico(seductor, nivel) = 0
	method modificarAspectoPersonal(seductor, nivel) = 0
}

class Billetera inherits Artilugio {
	var cantidad;
	
	constructor(cantidadInicial) {
		cantidad = cantidadInicial
	}
	override method modificarNivelEconomico(seductor, nivel) = cantidad
	override method modificarAspectoPersonal(seductor, nivel) = nivel * 0.10
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

