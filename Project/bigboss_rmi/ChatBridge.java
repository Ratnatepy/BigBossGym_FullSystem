package bigboss_rmi;

import java.rmi.Naming;
import java.util.Scanner;

public class ChatBridge {
    public static void main(String[] args) {
        try {
            // Debug output for arguments
            System.out.println("[DEBUG] Received args count: " + args.length);
            for (int i = 0; i < args.length; i++) {
                System.out.println("[DEBUG] arg[" + i + "]: " + args[i]);
            }

            // Connect to the RMI server
            GymService gymService = (GymService) Naming.lookup("rmi://localhost:1099/GymService");

            // Get input from either command line args or Scanner
            String input;
            if (args.length > 0) {
                // Join all command line arguments with spaces
                input = String.join(" ", args);
            } else {
                // Fallback to Scanner if no args provided
                Scanner scanner = new Scanner(System.in);
                input = scanner.nextLine().trim();
                scanner.close();
            }

            System.out.println("[CLIENT_QUERY] " + input);

            // Get response from RMI server
            String response = gymService.askQuestion(input);

            // Final output for Node.js (MUST BE LAST LINE)
            System.out.println("CHATBOT_RESPONSE:" + response);
            
        } catch (Exception e) {
            System.err.println("[ERROR] " + e.getMessage());
            // Error response for Node.js (MUST BE LAST LINE)
            System.out.println("CHATBOT_ERROR:" + e.getMessage());
            System.exit(1);
        }
    }
}