package bigboss_rmi;

import java.rmi.Naming;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.ExportException;

public class GymServer {
    public static void main(String[] args) {
        try {
            // Attempt to start RMI registry
            try {
                LocateRegistry.createRegistry(1099);
                System.out.println("[Server] RMI registry created.");
            } catch (ExportException e) {
                System.out.println("[Server] Using existing RMI registry...");
            }

            // Create and bind the remote object
            GymService gymService = new GymServiceImpl();
            Naming.rebind("GymService", gymService);
            System.out.println("[Server] GymService bound to RMI registry successfully!");
            System.out.println("[Server] Server is ready to accept client requests.");
        } catch (Exception e) {
            System.out.println("[Server] Server failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
