class Viaje{
	const property idiomas = []
	method implicaEsfuerzo()
	method sirveParaBroncearse()
	method cuantoDura()
	
	method esInteresante() = idiomas.size() >= 2
	
	method esRecomendada(socio) = self.esInteresante()
	 	and socio.meAtraeActividad(self) and !socio.actividadesRealizadas().contains(self)
}

class ViajePlaya inherits Viaje{
	const largoPlaya
	
	override method cuantoDura() = largoPlaya / 500
	override method implicaEsfuerzo() = largoPlaya > 1200
	override method sirveParaBroncearse() = true
}

class ViajeCiudad inherits Viaje{
	const numAtracciones
	
	override method cuantoDura() = numAtracciones / 2
	override method implicaEsfuerzo() = numAtracciones.between(5,8)
	override method sirveParaBroncearse() = false
	
	override method esInteresante() = super() or numAtracciones == 5
}

class ViajeCiudadTropical inherits ViajeCiudad{
	override method cuantoDura() = super() + 1
	override method sirveParaBroncearse() = true	
}

class ViajeTrekking inherits Viaje{
	const kmSendero
	const diasDeSol
	
	override method cuantoDura() = kmSendero / 50
	override method implicaEsfuerzo() = kmSendero > 80
	override method sirveParaBroncearse() = diasDeSol > 200 or ( diasDeSol.between(100,200) and kmSendero > 120)
	override method esInteresante() = super() and diasDeSol > 140
}

class ClaseGimnasia inherits Viaje{
	override method idiomas() = ["espanol"]
	override method cuantoDura() = 1
	override method implicaEsfuerzo() = true
	override method sirveParaBroncearse() = false
	
	override method esRecomendada(socio) = socio.edad().between(20,30)
}

class TallerLiterario inherits Viaje{
	const libros = []
	override method idiomas() = libros.map({l => l.idioma()})
	override method cuantoDura() = libros.size() + 1
	override method implicaEsfuerzo() = libros.any({l => l.cantPag() > 500 }) 
		or (libros.all({ l => l.autor() == libros.get(0).autor()}) and libros.size() > 1)
	override method sirveParaBroncearse() = false
	override method esRecomendada(socio) = socio.idiomasQueHabla().size() > 1
}

class Libros{
	const property idioma
	const property cantPag
	const property autor
}

class Socio{
	const property actividadesRealizadas = []
	const maxActividades  
	const property edad
	const property idiomasQueHabla = []
	
	method adoradorDelSol() = actividadesRealizadas.all({a => a.sirveParaBroncearse()})
	method actividadesEsforzadas() = actividadesRealizadas.filter({a => a.implicaEsfuerzo()}).asSet()
	method realizoActividad(actividad){
		if(actividadesRealizadas.size() == maxActividades)
		{
			self.error("Se alcanzo el limite")
		} else {
			actividadesRealizadas.add(actividad)
		} 		
	}
	
	method meAtraeActividad(actividad) = true
}

class SocioTranquilo inherits Socio{
	override method meAtraeActividad(actividad) = actividad.cuantoDura() > 4
}

class SocioCoherente inherits Socio{
	override method meAtraeActividad(actividad) = if(self.adoradorDelSol()) actividad.sirveParaBroncearse()
												 else actividad.implicaEsfuerzo()
}

class SocioRelajado inherits Socio{
	override method meAtraeActividad(actividad) = idiomasQueHabla.any({i => actividad.idiomas().contains(i)})
}

