import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.Date;

import ejemplo.cajero.modelo.Banco;
import ejemplo.cajero.modelo.Cuenta;

public aspect Auditoria {

	pointcut callMethod(): call(* ejemplo.cajero.control.Comando.ejecutar(..));

	
	before(): callMethod(){
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
		LocalDateTime now = LocalDateTime.now();  
		System.out.println();
		System.out.println();
		System.out.println("**************ANTES DE LA TRANSACCION AUDITORIA***********************");
		System.out.println("* Archivo con registro de auditoria:   "+dtf.format(now));
		System.out.println("* Estado inicial:	");
		Object [] args = thisJoinPoint.getArgs();
		for (Object arg : args) {
			Banco banco = new Banco();
			banco = (Banco)arg;
			Collection<Cuenta> listCuentas = banco.getCuentas();
			for(Cuenta cuenta : listCuentas) {
				System.out.println(cuenta.getNumero() + " : $ " + cuenta.getSaldo());
			}
		}
		System.out.println("* Se genera la siguiente transacción Auditoria: ");

	}
	
	after() returning(Object resultado): callMethod(){ 
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
		LocalDateTime now = LocalDateTime.now();
		System.out.println();
		System.out.println();
		System.out.println("********DESPUES DE LA TRANSACCION AUDITORIA********************");
		System.out.println("* Archivo con registro de auditoria:   "+dtf.format(now));
		System.out.println("* Estado final:");
	
		Object [] args = thisJoinPoint.getArgs();
		for (Object arg : args) {
			Banco banco = new Banco();
			banco = (Banco)arg;
			Collection<Cuenta> listCuentas = banco.getCuentas();
			for(Cuenta cuenta : listCuentas) {
				System.out.println(cuenta.getNumero() + " : $ " + cuenta.getSaldo());
			}
			System.out.println("***************FIN AUDITORIA******************************");
			System.out.println();
			System.out.println();
		}
		
	}
	after() throwing(Throwable e) : callMethod() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");  
		LocalDateTime now = LocalDateTime.now();
		System.out.println();
		System.out.println();
		System.out.println("*************INICIO AUDITORIA*********************");
		System.out.println("* Transacción Rechazada: "+dtf.format(now));
		System.out.println("* Se genera error al generar auditoria ");
		System.out.println("*************FIN AUDITORIA************************");
		System.out.println();
		System.out.println();

	}
	

}
