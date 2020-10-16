package ejemplo.cajero.control;

import java.util.Scanner;

import ejemplo.cajero.modelo.Banco;
import ejemplo.cajero.modelo.Cuenta;

/**
 * Comando usado para consignar dinero
 */
public class ComandoConsignar implements Comando {

	@Override
	public String getNombre() {
		return "Consignar dinero";
	}

	@SuppressWarnings("resource")
	@Override
	public void ejecutar(Banco contexto) throws Exception {
		System.out.println();
	
		throw new Exception(
				"No esta habilitada la configuración de CONSIGNACIÓN en este cajero");
	}

}
