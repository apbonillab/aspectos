import java.util.Scanner;

import ejemplo.cajero.modelo.Banco;
import ejemplo.cajero.modelo.Cuenta;

public aspect Consignaciones {
	

	pointcut callMethod(): call(* ejemplo.cajero.control.Comando.ejecutar(..));

	@SuppressWarnings("resource")
	void around() throws Exception : callMethod() {
		String operacion = thisJoinPoint.getTarget().toString();
		int consignar = operacion.indexOf("Consignar");
		if (consignar != -1) {
	System.out.println("Consignación de Dinero");
	System.out.println();
	System.out.println();
	Scanner console = new Scanner(System.in);			
	
	// Ingresa los datos
	System.out.println("Ingrese el número de cuenta");
	String numeroDeCuenta = console.nextLine();
	Object[] args = thisJoinPoint.getArgs();
	Banco contexto = new Banco();
	for (Object arg : args) {
		contexto = (Banco) arg;
	}
	Cuenta cuenta = contexto.buscarCuenta(numeroDeCuenta);
	if (cuenta == null) {
		throw new Exception("No existe cuenta con el número " + numeroDeCuenta);
	}
	
	System.out.println("Ingrese el valor a consignar");
	String valor = console.nextLine();

	try {
		long valorNumerico = Long.parseLong(valor);
		cuenta.consignar(valorNumerico);
	
	} catch (NumberFormatException e) {
		throw new Exception("Valor a consignar no válido : " + valor);
	}
}else {
	proceed();
}
	}

}
