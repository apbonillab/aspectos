import java.util.Scanner;

import ejemplo.cajero.modelo.Banco;
import ejemplo.cajero.modelo.Cuenta;


/**
 * 
 * @author adrianabonilla
 * Se implementa este aspecto para controlar la opcion de saldo Reducido cuando esta habilitado en la configuracion
 *	opcion valida para retiro y transferencia que son los que disminuyen el saldo
 */
public aspect SaldoReducido {

	pointcut callMethodSaldo(): call(* ejemplo.cajero.control.Comando.ejecutar(..));

	@SuppressWarnings("resource")
	void around() throws Exception : callMethodSaldo() {
		
		String operacion = thisJoinPoint.getTarget().toString();
		int retirar = operacion.indexOf("Retirar"); //operacion que permite bajar saldo de la cuenta 
		int transferencia = operacion.indexOf("Transferir"); // operacion que tambien permite reducir sald ode la cuenta

		if (retirar != -1) {
			System.out.println("Retiro de Dinero");
			System.out.println("**************FIN AUDITORIA***********************");	
			System.out.println();
			System.out.println();
			Scanner console = new Scanner(System.in);
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

			System.out.println("Ingrese el valor a retirar");
			String valor = console.nextLine();
			if (!saldoReducido(cuenta.getSaldo(), Long.parseLong(valor))) {
				try {
					long valorNumerico = Long.parseLong(valor);
					cuenta.retirar(valorNumerico);

				} catch (NumberFormatException e) {
					throw new Exception("Valor a retirar no válido : " + valor);
				}
			} else {
				throw new Exception(
						"Retiro rechazado, Saldo inferior a 200.000 HABILITADO SALDO REDUCIDO!");
				
			}

		} else {
			if (transferencia != -1) {
				System.out.println("Transferencia de Dinero");
				System.out.println("**************FIN AUDITORIA***********************");	
				System.out.println();
				System.out.println();
				Scanner console = new Scanner(System.in);

				// Ingresa los datos
				System.out.println("Ingrese el número de cuenta origen");
				String numeroCuentaOrigen = console.nextLine();

				Object[] args = thisJoinPoint.getArgs();
				Banco contexto = new Banco();
				for (Object arg : args) {
					contexto = (Banco) arg;
				}

				Cuenta cuentaOrigen = contexto.buscarCuenta(numeroCuentaOrigen);
				if (cuentaOrigen == null) {
					throw new Exception("No existe cuenta con el número " + numeroCuentaOrigen);
				}

				System.out.println("Ingrese el número de cuenta destino");
				String numeroCuentaDestino = console.nextLine();

				Cuenta cuentaDestino = contexto.buscarCuenta(numeroCuentaDestino);
				if (cuentaDestino == null) {
					throw new Exception("No existe cuenta con el número " + numeroCuentaDestino);
				}

				System.out.println("Ingrese el valor a transferir");
				String valor = console.nextLine();
				if (!saldoReducido(cuentaOrigen.getSaldo(), Long.parseLong(valor))) {
					try {
						long valorNumerico = Long.parseLong(valor);
						cuentaOrigen.retirar(valorNumerico);
						cuentaDestino.consignar(valorNumerico);

					} catch (NumberFormatException e) {
						throw new Exception("Valor a transferir no válido : " + valor);
					}
				} else {
					throw new Exception(
							"Transferencia rechazada, Saldo inferior a 200.000 HABILITADO SALDO REDUCIDO!");
					
				}
			} else {
				proceed();
			}
		}
	}
	
	public boolean saldoReducido(long saldo, long valor){
		long saldoFinal = saldo - valor;
		return saldoFinal <= 200000;
		
	}

}
