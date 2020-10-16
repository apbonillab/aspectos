import ejemplo.cajero.modelo.Banco;

public aspect Transferir {
	pointcut callMethod(): call(* ejemplo.cajero.control.Comando.ejecutar(..));

	@SuppressWarnings("resource")
	void around() throws Exception : callMethod() {
		String operacion = thisJoinPoint.getTarget().toString();
		int transferir = operacion.indexOf("Transferir");
		if (transferir != -1) {
			System.out.println("Transferencia de Dinero");
			System.out.println();
			System.out.println();
			// la clase Console no funciona bien en Eclipse
			Scanner console = new Scanner(System.in);			
			
			// Ingresa los datos
			System.out.println("Ingrese el número de cuenta origen");
			String numeroCuentaOrigen = console.nextLine();
			
			Cuenta cuentaOrigen = contexto.buscarCuenta(numeroCuentaOrigen);
			if (cuentaOrigen == null) {
				throw new Exception("No existe cuenta con el número " + numeroCuentaOrigen);
			}

			System.out.println("Ingrese el número de cuenta destino");
			String numeroCuentaDestino = console.nextLine();
			Object[] args = thisJoinPoint.getArgs();
			Banco contexto = new Banco();
			for (Object arg : args) {
				contexto = (Banco) arg;
			}
			Cuenta cuentaDestino = contexto.buscarCuenta(numeroCuentaDestino);
			if (cuentaDestino == null) {
				throw new Exception("No existe cuenta con el número " + numeroCuentaDestino);
			}
			
			System.out.println("Ingrese el valor a transferir");
			String valor = console.nextLine();
		
			try {
				
				// se retira primero y luego se consigna
				// si no se puede retirar, no se hace la consignación
				
				long valorNumerico = Long.parseLong(valor);
				cuentaOrigen.retirar(valorNumerico);
				cuentaDestino.consignar(valorNumerico);
			
			} catch (NumberFormatException e) {
				throw new Exception("Valor a transferir no válido : " + valor);
			}
		}
}else {
	proceed();
}
	}
